#!/bin/bash -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

CONTAINER_NAME="herolib"
TARGET_PORT=4000

# Function to check if a container is running
is_container_running() {
    docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" -q
}

# Function to check if a port is accessible
is_port_accessible() {
    nc -zv 127.0.0.1 "$1" &>/dev/null
}

# Check if the container exists and is running
if ! is_container_running; then
    echo "Container $CONTAINER_NAME is not running."

    # Check if the container exists but is stopped
    if docker ps -a --filter "name=$CONTAINER_NAME" -q | grep -q .; then
        echo "Starting existing container $CONTAINER_NAME..."
        docker start "$CONTAINER_NAME"
    else
        echo "Container $CONTAINER_NAME does not exist. Attempting to start with start.sh..."
        if [[ -f "$SCRIPT_DIR/start.sh" ]]; then
            bash "$SCRIPT_DIR/start.sh"
        else
            echo "Error: start.sh not found in $SCRIPT_DIR."
            exit 1
        fi
    fi

    # Wait for the container to be fully up
    sleep 5
fi

# Verify the container is running
if ! is_container_running; then
    echo "Error: Failed to start container $CONTAINER_NAME."
    exit 1
fi
echo "Container $CONTAINER_NAME is running."

# Check if the target port is accessible
if is_port_accessible "$TARGET_PORT"; then
    echo "Port $TARGET_PORT is accessible."
else
    echo "Port $TARGET_PORT is not accessible. Please check the service inside the container."
fi

# Enter the container
echo
echo " ** WE NOW LOGIN TO THE CONTAINER ** "
echo
docker exec -it herolib bash

