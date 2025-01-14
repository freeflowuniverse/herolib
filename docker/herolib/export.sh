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

docker export herolib | gzip > ${HOME}/Downloads/herolib.tar.gz

docker kill herolib