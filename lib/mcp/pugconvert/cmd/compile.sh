#!/bin/bash
set -ex

# Change to the directory containing this script
cd "$(dirname "$0")"

# Compile the V program
v -n -w -gc none  -cc tcc -d use_openssl -enable-globals main.v

# Ensure the binary is executable
chmod +x main
mv main ~/hero/bin/pugconvert

echo "Compilation successful. Binary 'main' is ready."
