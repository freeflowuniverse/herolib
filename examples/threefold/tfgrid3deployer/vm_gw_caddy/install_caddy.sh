#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

echo "Updating package lists..."
apt update -y

echo "Installing prerequisites..."
apt install -y debian-keyring debian-archive-keyring apt-transport-https curl

echo "Adding Caddy repository..."
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list

echo "Updating package lists for Caddy..."
apt update -y

echo "Installing Caddy..."
apt install -y caddy


echo "exec: caddy run --config /etc/caddy/Caddyfile" > /etc/zinit/caddy.yaml
zinit monitor caddy