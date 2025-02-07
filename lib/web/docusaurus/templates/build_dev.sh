#!/bin/bash

set -e

script_dir="??(cd "??(dirname "??{BASH_SOURCE[0]}")" && pwd)"
cd "??{script_dir}"


echo "Docs directory: ??script_dir"

cd ${site.path_build.path}

export PATH=/tmp/docusaurus_build/node_modules/.bin:??PATH

rm -rf ${site.path_build.path}/build/

bun docusaurus build

rsync -rv --delete ${site.path_build.path}/build/ ${cfg.main.build_dest_dev.trim_right("/")}/${cfg.main.name.trim_right("/")}/
