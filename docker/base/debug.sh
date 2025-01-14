#!/bin/bash -ex

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Remove any existing container named 'debug' (ignore errors)
docker rm -f herolib > /dev/null 2>&1

# Run the Docker container
docker run --name herolib -it \
  --entrypoint="/bin/bash" \
  -v "${SCRIPT_DIR}/scripts:/scripts" \
  -v "$HOME/code:/root/code" \
  -p 4100:8100 \
  -p 4101:8101 \
  -p 4102:8102 \
  -p 4379:6379 \
  -p 4000:3000 \
  herolib

