#!/bin/bash -e

# redis-server --daemonize yes

# TMUX_SESSION="vscode"
# # Start OpenVSCode Server in a tmux session
# if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
#     tmux kill-session -t "$TMUX_SESSION"
# fi
# tmux new-session -d -s "$TMUX_SESSION" "/usr/local/bin/openvscode-server --host 0.0.0.0 --without-connection-token"

# service ssh start

exec /bin/bash
