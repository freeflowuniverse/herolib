#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}"

echo "Docs directory: $script_dir"

cd "${HOME}/hero/var/docusaurus"

export PATH=/tmp/docusaurus_build/node_modules/.bin:${HOME}/.bun/bin/:$PATH

rm -rf /Users/despiegk/hero/var/docusaurus/build/

. ${HOME}/.zprofile 

bun docusaurus build

mkdir -p /Users/despiegk/code/github/freeflowuniverse/herolib/examples/biztools/bizmodel/example/docusaurus
echo SYNC TO /Users/despiegk/code/github/freeflowuniverse/herolib/examples/biztools/bizmodel/example/docusaurus
rsync -rv --delete /Users/despiegk/hero/var/docusaurus/build/ /Users/despiegk/code/github/freeflowuniverse/herolib/examples/biztools/bizmodel/example/docusaurus/
