#!/bin/bash -ex

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

docker compose down

docker rm herolib --force

# Start the container in detached mode (-d)
docker run --name herolib \
  --entrypoint="/bin/bash" \
  -v "${SCRIPT_DIR}/scripts:/scripts" \
  -p 4022:22 \
  -d herolib -c "while true; do sleep 1; done"

docker exec -it herolib /scripts/cleanup.sh


# Detect the OS
detect_os() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "osx"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
      echo "ubuntu"
    fi
  else
    echo "unknown"
  fi
}

OS=$(detect_os)

if [[ "$OS" == "osx" ]]; then
  echo "Running on macOS..."
  docker export herolib | gzip > "${HOME}/Downloads/herolib.tar.gz"
  echo "Docker image exported to ${HOME}/Downloads/herolib.tar.gz"
elif [[ "$OS" == "ubuntu" ]]; then
  echo "Running on Ubuntu..."
  export TEMP_TAR="/tmp/herolib.tar"

  # Export the Docker container to a tar file
  docker export herolib > "$TEMP_TAR"
  echo "Docker container exported to $TEMP_TAR"

  # Import the tar file back as a single-layer image
  docker import "$TEMP_TAR" herolib:single-layer
  echo "Docker image imported as single-layer: herolib:single-layer"
  
    # Log in to Docker Hub and push the image
  docker login --username despiegk
  docker tag herolib:single-layer despiegk/herolib:single-layer
  docker push despiegk/herolib:single-layer
  echo "Docker image pushed to Docker Hub as despiegk/herolib:single-layer"

  # Optionally remove the tar file after importing
  rm -f "$TEMP_TAR"
  echo "Temporary file $TEMP_TAR removed"

else
  echo "Unsupported OS detected. Exiting."
  exit 1
fi

docker kill herolib


# Test the pushed Docker image locally
echo "Testing the Docker image locally..."
TEST_CONTAINER_NAME="test_herolib_container"

docker pull despiegk/herolib:single-layer
if [[ $? -ne 0 ]]; then
  echo "Failed to pull the Docker image from Docker Hub. Exiting."
  exit 1
fi

docker run --name "$TEST_CONTAINER_NAME" -d despiegk/herolib:single-layer
if [[ $? -ne 0 ]]; then
  echo "Failed to run the Docker image as a container. Exiting."
  exit 1
fi

docker ps | grep "$TEST_CONTAINER_NAME"
if [[ $? -eq 0 ]]; then
  echo "Container $TEST_CONTAINER_NAME is running successfully."
else
  echo "Container $TEST_CONTAINER_NAME is not running. Check the logs for details."
fi