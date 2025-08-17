#!/bin/bash

set -e  # Exit on any error

cd "$(dirname "$0")"

source env.sh

python main.py