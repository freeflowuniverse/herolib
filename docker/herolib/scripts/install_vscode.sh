#!/bin/bash -e

# Set version and file variables
OPENVSCODE_SERVER_VERSION="1.97.0"
TMP_DIR="/tmp"
FILENAME="openvscode.tar.gz"
FILE_PATH="$TMP_DIR/$FILENAME"
INSTALL_DIR="/opt/openvscode"
BIN_PATH="/usr/local/bin/openvscode-server"
TMUX_SESSION="openvscode-server"

# Function to detect architecture
get_architecture() {
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)
            echo "x64"
            ;;
        aarch64)
            echo "arm64"
            ;;
        *)
            echo "Unsupported architecture: $ARCH" >&2
            exit 1
            ;;
    esac
}

# Check if OpenVSCode Server is already installed
if [ -d "$INSTALL_DIR" ] && [ -x "$BIN_PATH" ]; then
    echo "OpenVSCode Server is already installed at $INSTALL_DIR. Skipping download and installation."
else
    # Determine architecture-specific URL
    ARCH=$(get_architecture)
    if [ "$ARCH" == "x64" ]; then
        DOWNLOAD_URL="https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-insiders-v${OPENVSCODE_SERVER_VERSION}/openvscode-server-insiders-v${OPENVSCODE_SERVER_VERSION}-linux-x64.tar.gz"
    elif [ "$ARCH" == "arm64" ]; then
        DOWNLOAD_URL="https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-insiders-v${OPENVSCODE_SERVER_VERSION}/openvscode-server-insiders-v${OPENVSCODE_SERVER_VERSION}-linux-arm64.tar.gz"
    fi

    # Navigate to temporary directory
    cd "$TMP_DIR"

    # Remove existing file if it exists
    if [ -f "$FILE_PATH" ]; then
        rm -f "$FILE_PATH"
    fi

    # Download file using curl
    curl -L "$DOWNLOAD_URL" -o "$FILE_PATH"

    # Verify file size is greater than 40 MB (40 * 1024 * 1024 bytes)
    FILE_SIZE=$(stat -c%s "$FILE_PATH")
    if [ "$FILE_SIZE" -le $((40 * 1024 * 1024)) ]; then
        echo "Error: Downloaded file size is less than 40 MB." >&2
        exit 1
    fi

    # Extract the tar.gz file
    EXTRACT_DIR="openvscode-server-insiders-v${OPENVSCODE_SERVER_VERSION}-linux-${ARCH}"
    tar -xzf "$FILE_PATH"

    # Move the extracted directory to the install location
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi
    mv "$EXTRACT_DIR" "$INSTALL_DIR"

    # Create a symlink for easy access
    ln -sf "$INSTALL_DIR/bin/openvscode-server" "$BIN_PATH"

    # Verify installation
    if ! command -v openvscode-server >/dev/null 2>&1; then
        echo "Error: Failed to create symlink for openvscode-server." >&2
        exit 1
    fi

    # Install default plugins
    PLUGINS=("ms-python.python" "esbenp.prettier-vscode" "saoudrizwan.claude-dev" "yzhang.markdown-all-in-one" "ms-vscode-remote.remote-ssh" "ms-vscode.remote-explorer" "charliermarsh.ruff" "qwtel.sqlite-viewer" "vosca.vscode-v-analyzer" "tomoki1207.pdf")
    for PLUGIN in "${PLUGINS[@]}"; do
        "$INSTALL_DIR/bin/openvscode-server" --install-extension "$PLUGIN"
    done

    echo "Default plugins installed: ${PLUGINS[*]}"

    # Clean up temporary directory
    if [ -d "$TMP_DIR" ]; then
        find "$TMP_DIR" -maxdepth 1 -type f -name "openvscode*" -exec rm -f {} \;
    fi
fi

# Start OpenVSCode Server in a tmux session
if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    tmux kill-session -t "$TMUX_SESSION"
fi
tmux new-session -d -s "$TMUX_SESSION" "$INSTALL_DIR/bin/openvscode-server"

echo "OpenVSCode Server is running in a tmux session named '$TMUX_SESSION'."
