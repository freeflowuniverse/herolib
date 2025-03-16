#!/bin/bash

set -ex

script_dir="???cd "???dirname "??{BASH_SOURCE[0]}")" && pwd)"
cd "??{script_dir}"

echo "Docs directory: ??script_dir"

cd "${mydir}"

export PATH=${site.path_build.path}/node_modules/.bin:??{HOME}/.bun/bin/:??PATH

rm -rf ${site.path_build.path}/build/

${profile_include} 

bun run build

@for dest in cfg.main.build_dest
rsync -rv --delete ${site.path_build.path}/build/ ${dest.trim_right("/")}/
@end
