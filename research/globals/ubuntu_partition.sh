#!/bin/bash
set -euo pipefail

###############################################################################
# WARNING: THIS SCRIPT ERASES DATA!
#
# This script will:
#   1. Identify all internal (nonremovable) SSD and NVMe disks, excluding the
#      live USB from which Ubuntu is booted.
#   2. Wipe their partition tables.
#   3. On the first detected disk, create:
#         - a 1 GB EFI partition (formatted FAT32, flagged as ESP)
#         - a ~19 GB partition for Ubuntu root (formatted ext4)
#         - if any space remains, a partition covering the rest (formatted btrfs)
#   4. On every other disk, create one partition spanning the entire disk and
#      format it as btrfs.
#
# Double‐check that you want to wipe all these disks BEFORE you run this script.
###############################################################################

# Ensure the script is run as root.
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Helper: given a device like /dev/sda1 or /dev/nvme0n1p1, return the base device.
get_base_device() {
    local dev="$1"
    if [[ "$dev" =~ ^/dev/nvme.*p[0-9]+$ ]]; then
        # For NVMe devices, remove the trailing 'pX'
        echo "$dev" | sed -E 's/p[0-9]+$//'
    else
        # For /dev/sdX type devices, remove trailing numbers
        echo "$dev" | sed -E 's/[0-9]+$//'
    fi
}

# Helper: given a disk (e.g. /dev/sda or /dev/nvme0n1) and a partition number,
# print the proper partition name.
get_partition_name() {
    local disk="$1"
    local partnum="$2"
    if [[ "$disk" =~ nvme ]]; then
        echo "${disk}p${partnum}"
    else
        echo "${disk}${partnum}"
    fi
}

# Determine the boot device (i.e. the device from which the live system is running)
boot_dev_full=$(findmnt -n -o SOURCE /)
boot_disk=$(get_base_device "$boot_dev_full")
echo "Detected boot device (from /): $boot_dev_full"
echo "Base boot disk (will be used for Ubuntu install): $boot_disk"

# Now, enumerate candidate target disks.
# We will scan /sys/block for devices starting with "sd" or "nvme".
target_disks=()

# Loop over sd* and nvme* disks.
for dev_path in /sys/block/sd* /sys/block/nvme*; do
    [ -e "$dev_path" ] || continue
    disk_name=$(basename "$dev_path")
    disk="/dev/$disk_name"

    # Skip removable devices (e.g. USB sticks)
    if [ "$(cat "$dev_path/removable")" -ne 0 ]; then
        continue
    fi

    # Skip disks that are rotational (i.e. likely HDD) if you want only SSD/NVMe.
    # (Usually SSD/NVMe have rotational=0.)
    if [ -f "$dev_path/queue/rotational" ]; then
        if [ "$(cat "$dev_path/queue/rotational")" -ne 0 ]; then
            continue
        fi
    fi

    # Add disk to list.
    target_disks+=("$disk")
done

# Ensure the boot disk is in our list. (It will be partitioned for Ubuntu.)
if [[ ! " ${target_disks[@]} " =~ " ${boot_disk} " ]]; then
    # Check if boot_disk qualifies (nonremovable and nonrotational)
    disk_dir="/sys/block/$(basename "$boot_disk")"
    if [ -f "$disk_dir/removable" ] && [ "$(cat "$disk_dir/removable")" -eq 0 ]; then
        if [ -f "$disk_dir/queue/rotational" ] && [ "$(cat "$disk_dir/queue/rotational")" -eq 0 ]; then
            target_disks=("$boot_disk" "${target_disks[@]}")
        fi
    fi
fi

if [ "${#target_disks[@]}" -eq 0 ]; then
    echo "No qualifying internal SSD/NVMe disks found."
    exit 1
fi

echo
echo "The following disks will be wiped and re-partitioned:"
for disk in "${target_disks[@]}"; do
    echo "  $disk"
done
echo
read -p "ARE YOU SURE YOU WANT TO PROCEED? This will permanently erase all data on these disks (type 'yes' to continue): " answer
if [ "$answer" != "yes" ]; then
    echo "Aborting."
    exit 1
fi

###############################################################################
# Wipe all target disks.
###############################################################################
for disk in "${target_disks[@]}"; do
    echo "Wiping partition table on $disk..."
    sgdisk --zap-all "$disk"
    # Overwrite beginning of disk (optional but recommended)
    dd if=/dev/zero of="$disk" bs=512 count=2048 status=none
    # Overwrite end of disk (ignoring errors if size is too small)
    total_sectors=$(blockdev --getsz "$disk")
    dd if=/dev/zero of="$disk" bs=512 count=2048 seek=$(( total_sectors - 2048 )) status=none 2>/dev/null || true
done

###############################################################################
# Partition the FIRST disk for Ubuntu installation.
###############################################################################
boot_install_disk="${target_disks[0]}"
echo
echo "Partitioning boot/install disk: $boot_install_disk"
parted -s "$boot_install_disk" mklabel gpt

# Create EFI partition: from 1MiB to 1025MiB (~1GB).
parted -s "$boot_install_disk" mkpart ESP fat32 1MiB 1025MiB
parted -s "$boot_install_disk" set 1 esp on

# Create root partition: from 1025MiB to 21025MiB (~20GB total for install).
parted -s "$boot_install_disk" mkpart primary ext4 1025MiB 21025MiB

# Determine if there’s any space left.
disk_size_bytes=$(blockdev --getsize64 "$boot_install_disk")
# Calculate 21025MiB in bytes.
min_install_bytes=$((21025 * 1024 * 1024))
if [ "$disk_size_bytes" -gt "$min_install_bytes" ]; then
    echo "Creating additional partition on $boot_install_disk for btrfs (using remaining space)..."
    parted -s "$boot_install_disk" mkpart primary btrfs 21025MiB 100%
    boot_disk_partitions=(1 2 3)
else
    boot_disk_partitions=(1 2)
fi

# Format the partitions on the boot/install disk.
efi_part=$(get_partition_name "$boot_install_disk" 1)
root_part=$(get_partition_name "$boot_install_disk" 2)

echo "Formatting EFI partition ($efi_part) as FAT32..."
mkfs.fat -F32 "$efi_part"

echo "Formatting root partition ($root_part) as ext4..."
mkfs.ext4 -F "$root_part"

# If a third partition exists, format it as btrfs.
if [ "${boot_disk_partitions[2]:-}" ]; then
    btrfs_part=$(get_partition_name "$boot_install_disk" 3)
    echo "Formatting extra partition ($btrfs_part) as btrfs..."
    mkfs.btrfs -f "$btrfs_part"
fi

###############################################################################
# Partition all OTHER target disks entirely as btrfs.
###############################################################################
if [ "${#target_disks[@]}" -gt 1 ]; then
    echo
    echo "Partitioning remaining disks for btrfs:"
    for disk in "${target_disks[@]:1}"; do
        echo "Processing disk $disk..."
        parted -s "$disk" mklabel gpt
        parted -s "$disk" mkpart primary btrfs 1MiB 100%
        # Determine the partition name (e.g. /dev/sdb1 or /dev/nvme0n1p1).
        if [[ "$disk" =~ nvme ]]; then
            part="${disk}p1"
        else
            part="${disk}1"
        fi
        echo "Formatting $part as btrfs..."
        mkfs.btrfs -f "$part"
    done
fi

echo
echo "All operations complete. Ubuntu install partitions and btrfs volumes have been created."
