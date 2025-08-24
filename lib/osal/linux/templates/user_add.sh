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

# --- create login helper script for gpg-agent ---
PROFILE_SCRIPT="$USERHOME/.profile_gpgagent"
cat > "$PROFILE_SCRIPT" <<'EOF'
# Auto-start gpg-agent with SSH support if not running
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

# Always overwrite gpg-agent.conf with required config
cat > "$HOME/.gnupg/gpg-agent.conf" <<CONF
enable-ssh-support
default-cache-ttl 7200
max-cache-ttl 7200
CONF

# Kill old agent if any (so config is applied)
gpgconf --kill gpg-agent 2>/dev/null || true

# Launch gpg-agent
gpgconf --launch gpg-agent

# Export socket path so ssh-add works
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# Load all private keys found in ~/.ssh
if [ -d "$HOME/.ssh" ]; then
  for KEY in "$HOME"/.ssh/*; do
    if [ -f "$KEY" ] && grep -q "PRIVATE KEY" "$KEY" 2>/dev/null; then
      ssh-add "$KEY" >/dev/null 2>&1 && echo "🔑 Loaded key: $KEY"
    fi
  done
fi

# For interactive shells
if [[ $- == *i* ]]; then
  echo "🔑 GPG Agent ready at \$SSH_AUTH_SOCK"
fi

EOF

chown "$NEWUSER":"$NEWUSER" "$PROFILE_SCRIPT"
chmod 644 "$PROFILE_SCRIPT"

# --- source it on login ---
if ! grep -q ".profile_gpgagent" "$USERHOME/.bashrc"; then
  echo "[ -f ~/.profile_gpgagent ] && source ~/.profile_gpgagent" >> "$USERHOME/.bashrc"
fi

echo "🎉 Setup complete for user $NEWUSER"
