#!/bin/bash
# Script to echo input from stdin to stdout immediately without waiting for end of line

# Use 'cat' to echo everything immediately
# The '-' argument tells cat to read from stdin
cat -

# Alternative method using dd if cat is not available:
# dd bs=1 status=none
