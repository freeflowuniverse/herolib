# HeroLib Docker Environment

This directory contains the Docker configuration and scripts for setting up and managing the HeroLib development environment. The environment includes a containerized setup with VSCode server, SSH access, and PostgreSQL database.

## Key Components

### Docker Configuration Files

- `Dockerfile`: Defines the container image based on Ubuntu 24.04, installing necessary dependencies including:
  - V language and its analyzer
  - VSCode server
  - SSH server
  - Development tools (curl, tmux, htop, etc.)
  - HeroLib installation

- `docker-compose.yml`: Orchestrates the multi-container setup with:
  - PostgreSQL database service
  - HeroLib development environment
  - Port mappings for various services
  - Volume mounting for code persistence

## Scripts

### Container Management

- `shell.sh`: Interactive shell access script that:
  - Checks if the container is running
  - Starts the container if it's stopped
  - Verifies port accessibility (default: 4000)
  - Provides interactive bash session inside the container

- `debug.sh`: Launches the container in debug mode with:
  - Interactive terminal
  - Volume mounts for scripts and code
  - Port mappings for various services (4000-4379)
  - Custom entrypoint using ourinit.sh

- `export.sh`: Creates a compressed export of the container:
  - Stops any running instances
  - Launches a temporary container
  - Runs cleanup script
  - Exports and compresses the container to ~/Downloads/herolib.tar.gz

### SSH Access

- `ssh.sh`: Simple SSH connection script to access the container via port 4022

- `ssh_init.sh`: Configures SSH access by:
  - Collecting public keys from local ~/.ssh directory
  - Setting up authorized_keys in the container
  - Installing and configuring SSH server
  - Setting appropriate permissions
  - Enabling root login with key authentication

### Internal Scripts (in scripts/)

- `cleanup.sh`: Comprehensive system cleanup script that:
  - Removes unused packages and dependencies
  - Cleans APT cache
  - Removes old log files
  - Clears temporary files and caches
  - Performs system maintenance tasks

- `install_herolib.vsh`: V script for HeroLib installation:
  - Sets up necessary symlinks
  - Configures V module structure
  - Adds useful shell aliases (e.g., vtest)

- `ourinit.sh`: Container initialization script that:
  - Starts Redis server in daemon mode
  - Launches VSCode server in a tmux session
  - Starts SSH service
  - Provides interactive bash shell

## Port Mappings

- 4000:3000 - Main application port
- 4022:22 - SSH access
- 4100:8100 - Additional service port
- 4101:8101 - Additional service port
- 4102:8102 - Additional service port
- 4379:6379 - Redis port

## Usage

1. Build and start the environment:
   ```bash
   docker compose up -d
   ```

2. Access the container shell:
   ```bash
   ./shell.sh
   ```

3. Connect via SSH:
   ```bash
   ./ssh.sh
   ```

4. Debug mode (interactive with direct terminal):
   ```bash
   ./debug.sh
   ```

5. Create container export:
   ```bash
   ./export.sh
   ```

## Development

The environment mounts your local `~/code` directory to `/root/code` inside the container, allowing for seamless development between host and container. The PostgreSQL database persists data using a named volume.
