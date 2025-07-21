#!/bin/bash

set -e

script_dir="???cd "???dirname "??{BASH_SOURCE[0]}")" && pwd)"
cd "??{script_dir}"

echo "Docs directory: ??script_dir"

cd "${mydir}"

export PATH=${site.path_build.path}/node_modules/.bin:??{HOME}/.bun/bin/:??PATH

${profile_include} 

bun dev
