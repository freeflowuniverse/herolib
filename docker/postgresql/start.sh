#!/bin/bash -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Stop any existing containers and remove them
docker compose down

# Start the services in detached mode
docker compose up -d

echo "PostgreSQL is ready"
