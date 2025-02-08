#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display an error message and exit
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Update package index and upgrade system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y || error_exit "Failed to update system packages."

# Install required packages for repository setup
echo "Installing prerequisites..."
sudo apt install -y ca-certificates curl gnupg || error_exit "Failed to install prerequisites."

# Create directory for Docker GPG key
echo "Setting up GPG keyring..."
sudo mkdir -p /etc/apt/keyrings || error_exit "Failed to create keyring directory."

# Add Docker's official GPG key
DOCKER_GPG_KEY=/etc/apt/keyrings/docker.gpg
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o $DOCKER_GPG_KEY || error_exit "Failed to add Docker GPG key."
sudo chmod a+r $DOCKER_GPG_KEY

# Set up Docker repository
echo "Adding Docker repository..."
REPO_ENTRY="deb [arch=$(dpkg --print-architecture) signed-by=$DOCKER_GPG_KEY] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
if ! grep -Fxq "$REPO_ENTRY" /etc/apt/sources.list.d/docker.list; then
  echo "$REPO_ENTRY" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || error_exit "Failed to add Docker repository."
fi

# Update package index
echo "Updating package index..."
sudo apt update || error_exit "Failed to update package index."

# Install Docker Engine, CLI, and dependencies
echo "Installing Docker Engine and dependencies..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || error_exit "Failed to install Docker packages."

# Verify Docker installation
echo "Verifying Docker installation..."
if ! docker --version; then
  error_exit "Docker installation verification failed."
fi

# Run a test container
echo "Running Docker test container..."
if ! sudo docker run --rm hello-world; then
  error_exit "Docker test container failed to run."
fi

# Add current user to Docker group (if not already added)
echo "Configuring Docker group..."
if ! groups $USER | grep -q '\bdocker\b'; then
  sudo usermod -aG docker $USER || error_exit "Failed to add user to Docker group."
  echo "User added to Docker group. Please log out and back in for this change to take effect."
else
  echo "User is already in the Docker group."
fi

# Enable Docker service on boot
echo "Enabling Docker service on boot..."
sudo systemctl enable docker || error_exit "Failed to enable Docker service."

# Success message
echo "Docker installation completed successfully!"
