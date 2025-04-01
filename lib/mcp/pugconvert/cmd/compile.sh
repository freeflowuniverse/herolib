#!/bin/bash
set -ex

# Change to the directory containing this script
cd "$(dirname "$0")"

# Compile the V program
v -n -w -gc none  -cc tcc -d use_openssl -enable-globals .

# Ensure the binary is executable
chmod +x main
rm main pugconvert

echo "Compilation successful. Binary 'main' is ready."
