#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Use sudo."
  exit 1
fi

# Update package lists and install prerequisites
echo "Installing prerequisites..."
apt update -y
apt install -y debian-keyring debian-archive-keyring apt-transport-https curl

# Add Caddy's GPG key
echo "Adding Caddy's GPG key..."
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

# Add Caddy's APT repository
echo "Adding Caddy's APT repository..."
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list

# Update package lists to include Caddy's repository
echo "Updating package lists..."
apt update -y

# Install Caddy
echo "Installing Caddy..."
apt install -y caddy

# Confirm installation
echo "Caddy installation completed successfully!"
echo "You can check the Caddy version with: caddy version"

# Use user's Caddyfile
mv ~/Caddyfile /etc/caddy/Caddyfile

# Monitor Caddy service with Zinit
echo "exec: caddy run --config /etc/caddy/Caddyfile" > /etc/zinit/caddy.yaml
zinit monitor caddy
echo "Caddy service monitored"