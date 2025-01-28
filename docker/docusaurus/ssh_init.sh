#!/bin/bash -e

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Define variables
CONTAINER_NAME="herolib"
CONTAINER_SSH_DIR="/root/.ssh"
AUTHORIZED_KEYS="authorized_keys"
TEMP_AUTH_KEYS="/tmp/authorized_keys"

# Step 1: Create a temporary file to store public keys
> $TEMP_AUTH_KEYS  # Clear the file if it exists

# Step 2: Add public keys from ~/.ssh/ if they exist
if ls ~/.ssh/*.pub 1>/dev/null 2>&1; then
    cat ~/.ssh/*.pub >> $TEMP_AUTH_KEYS
fi

# Step 3: Check if ssh-agent is running and get public keys from it
if pgrep ssh-agent >/dev/null; then
    echo "ssh-agent is running. Fetching keys..."
    ssh-add -L >> $TEMP_AUTH_KEYS 2>/dev/null
else
    echo "ssh-agent is not running or no keys loaded."
fi

# Step 4: Ensure the temporary file is not empty
if [ ! -s $TEMP_AUTH_KEYS ]; then
    echo "No public keys found. Exiting."
    exit 1
fi

# Step 5: Ensure the container's SSH directory exists
docker exec -it $CONTAINER_NAME mkdir -p $CONTAINER_SSH_DIR
docker exec -it $CONTAINER_NAME chmod 700 $CONTAINER_SSH_DIR

# Step 6: Copy the public keys into the container's authorized_keys file
docker cp $TEMP_AUTH_KEYS $CONTAINER_NAME:$CONTAINER_SSH_DIR/$AUTHORIZED_KEYS

# Step 7: Set proper permissions for authorized_keys
docker exec -it $CONTAINER_NAME chmod 600 $CONTAINER_SSH_DIR/$AUTHORIZED_KEYS

# Step 8: Install and start the SSH server inside the container
docker exec -it $CONTAINER_NAME bash -c "
  apt-get update &&
  apt-get install -y openssh-server &&
  mkdir -p /var/run/sshd &&
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config &&
  echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config &&
  chown -R root:root  /root/.ssh &&
  chmod -R 700 /root/.ssh/ &&
  chmod 600 /root/.ssh/authorized_keys &&  
  service ssh start
"

# Step 9: Clean up temporary file on the host
rm $TEMP_AUTH_KEYS

echo "SSH keys added and SSH server configured. You can now SSH into the container."

ssh root@localhost -p 4022
