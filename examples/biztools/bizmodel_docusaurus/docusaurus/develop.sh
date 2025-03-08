#!/bin/bash

set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}"

echo "Docs directory: $script_dir"

cd "${HOME}/hero/var/docusaurus"

export PATH=/tmp/docusaurus_build/node_modules/.bin:${HOME}/.bun/bin/:$PATH

. ${HOME}/.zprofile 

bun run start -p 3100
