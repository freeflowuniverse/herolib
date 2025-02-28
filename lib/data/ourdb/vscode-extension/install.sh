#!/bin/bash

# Script to install the OurDB Viewer extension to VSCode

# Determine OS and set extension directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    EXTENSION_DIR="$HOME/.vscode/extensions/local-herolib.ourdb-viewer-0.0.1"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    EXTENSION_DIR="$HOME/.vscode/extensions/local-herolib.ourdb-viewer-0.0.1"
else
    # Windows with Git Bash or similar
    EXTENSION_DIR="$HOME/.vscode/extensions/local-herolib.ourdb-viewer-0.0.1"
    # For Windows CMD/PowerShell, would be:
    # EXTENSION_DIR="%USERPROFILE%\.vscode\extensions\local-herolib.ourdb-viewer-0.0.1"
fi

# Create extension directory
mkdir -p "$EXTENSION_DIR"

# Copy extension files
cp -f "$(dirname "$0")/extension.js" "$EXTENSION_DIR/"
cp -f "$(dirname "$0")/package.json" "$EXTENSION_DIR/"
cp -f "$(dirname "$0")/README.md" "$EXTENSION_DIR/"

echo "OurDB Viewer extension installed to: $EXTENSION_DIR"
echo "Please restart VSCode for the changes to take effect."
echo "After restarting, you should be able to open .ourdb files."
