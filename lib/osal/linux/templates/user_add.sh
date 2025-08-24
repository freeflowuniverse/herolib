#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Must be run as root"
  exit 1
fi

# --- ask for username ---
read -rp "Enter username to create: " NEWUSER

# --- ask for SSH public key ---
read -rp "Enter SSH public key (or path to pubkey file): " PUBKEYINPUT
if [ -f "$PUBKEYINPUT" ]; then
  PUBKEY="$(cat "$PUBKEYINPUT")"
else
  PUBKEY="$PUBKEYINPUT"
fi

# --- ensure user exists ---
if id "$NEWUSER" >/dev/null 2>&1; then
  echo "✅ User $NEWUSER already exists"
else
  echo "➕ Creating user $NEWUSER"
  useradd -m -s /bin/bash "$NEWUSER"
fi

USERHOME=$(eval echo "~$NEWUSER")

# --- setup SSH authorized_keys ---
mkdir -p "$USERHOME/.ssh"
chmod 700 "$USERHOME/.ssh"
echo "$PUBKEY" > "$USERHOME/.ssh/authorized_keys"
chmod 600 "$USERHOME/.ssh/authorized_keys"
chown -R "$NEWUSER":"$NEWUSER" "$USERHOME/.ssh"
echo "✅ SSH key installed for $NEWUSER"

# --- ensure ourworld group exists ---
if getent group ourworld >/dev/null 2>&1; then
  echo "✅ Group 'ourworld' exists"
else
  echo "➕ Creating group 'ourworld'"
  groupadd ourworld
fi

# --- add user to group ---
if id -nG "$NEWUSER" | grep -qw ourworld; then
  echo "✅ $NEWUSER already in 'ourworld'"
else
  usermod -aG ourworld "$NEWUSER"
  echo "✅ Added $NEWUSER to 'ourworld' group"
fi

# --- setup /code ---
mkdir -p /code
chown root:ourworld /code
chmod 2775 /code   # rwx for user+group, SGID bit so new files inherit group
echo "✅ /code prepared (group=ourworld, rwx for group, SGID bit set)"

# --- create login helper script for ssh-agent ---
PROFILE_SCRIPT="$USERHOME/.profile_sshagent"
cat > "$PROFILE_SCRIPT" <<'EOF'
# Auto-start ssh-agent if not running
SSH_AGENT_PID_FILE="$HOME/.ssh/agent.pid"
SSH_AUTH_SOCK_FILE="$HOME/.ssh/agent.sock"

# Function to start ssh-agent
start_ssh_agent() {
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Start ssh-agent and save connection info
    ssh-agent -s > "$SSH_AGENT_PID_FILE"
    source "$SSH_AGENT_PID_FILE"
    
    # Save socket path for future sessions
    echo "$SSH_AUTH_SOCK" > "$SSH_AUTH_SOCK_FILE"
    
    # Load all private keys found in ~/.ssh
    if [ -d "$HOME/.ssh" ]; then
        for KEY in "$HOME"/.ssh/*; do
            if [ -f "$KEY" ] && [ ! "${KEY##*.}" = "pub" ] && grep -q "PRIVATE KEY" "$KEY" 2>/dev/null; then
                ssh-add "$KEY" >/dev/null 2>&1 && echo "🔑 Loaded key: $(basename $KEY)"
            fi
        done
    fi
}

# Check if ssh-agent is running
if [ -f "$SSH_AGENT_PID_FILE" ]; then
    source "$SSH_AGENT_PID_FILE" >/dev/null 2>&1
    # Test if agent is responsive
    if ! ssh-add -l >/dev/null 2>&1; then
        start_ssh_agent
    else
        # Agent is running, restore socket path
        if [ -f "$SSH_AUTH_SOCK_FILE" ]; then
            export SSH_AUTH_SOCK=$(cat "$SSH_AUTH_SOCK_FILE")
        fi
    fi
else
    start_ssh_agent
fi

# For interactive shells
if [[ $- == *i* ]]; then
    echo "🔑 SSH Agent ready at $SSH_AUTH_SOCK"
    # Show loaded keys
    KEY_COUNT=$(ssh-add -l 2>/dev/null | wc -l)
    if [ "$KEY_COUNT" -gt 0 ]; then
        echo "🔑 $KEY_COUNT SSH key(s) loaded"
    fi
fi

EOF

chown "$NEWUSER":"$NEWUSER" "$PROFILE_SCRIPT"
chmod 644 "$PROFILE_SCRIPT"

# --- source it on login ---
if ! grep -q ".profile_sshagent" "$USERHOME/.bashrc"; then
  echo "[ -f ~/.profile_sshagent ] && source ~/.profile_sshagent" >> "$USERHOME/.bashrc"
fi

echo "🎉 Setup complete for user $NEWUSER"