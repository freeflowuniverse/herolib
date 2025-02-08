#!/bin/bash -e

# Log file for cleanup operations
LOG_FILE="/var/log/cleanup_script.log"
exec > >(tee -a $LOG_FILE) 2>&1

# Function to check and execute commands safely
safe_run() {
    echo "Running: $*"
    eval "$*"
}

# Update package lists
safe_run "apt update"

# Remove unused packages and dependencies
safe_run "apt autoremove -y"

# Clean up APT cache
safe_run "apt clean"
safe_run "apt autoclean"

# Remove old kernels (keeping the current and latest one)
safe_run "apt remove --purge -y $(dpkg --list | grep linux-image | awk '{print $2}' | grep -v $(uname -r | sed 's/[^-]*-[^-]*-//') | sort | head -n -1)"

# Clear systemd journal logs, keeping only the latest 7 days
safe_run "journalctl --vacuum-time=7d"

# Remove orphaned packages
safe_run "deborphan | xargs apt-get -y remove --purge"

# Clear thumbnail cache
safe_run "rm -rf ~/.cache/thumbnails/*"

# Remove old log files
safe_run "find /var/log -type f -name '*.log' -delete"

# Clear temporary files
safe_run "rm -rf /tmp/*"
safe_run "rm -rf /var/tmp/*"

# Remove user-specific temporary files (adjust for other users as needed)
safe_run "rm -rf ~/.cache/*"

# Remove .pyc files
safe_run "find / -type f -name '*.pyc' -delete"

# Remove unused snap versions
#safe_run "snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do snap remove "$snapname" --revision="$revision"; done"

# Clear trash for all users
safe_run "rm -rf /home/*/.local/share/Trash/*/**"
safe_run "rm -rf /root/.local/share/Trash/*/**"

# Free up swap space
#safe_run "swapoff -a && swapon -a"

# Update GRUB (in case old kernels were removed)
#safe_run "update-grub"

# # Final system update and upgrade
# safe_run "apt upgrade -y"

# Report completion
echo "System cleanup completed successfully."


