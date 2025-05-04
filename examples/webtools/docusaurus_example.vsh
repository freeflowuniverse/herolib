#!/usr/bin/env -S v -n -w -gc none  -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.docusaurus

// Create a new docusaurus factory
mut docs := docusaurus.new(
	build_path: '/tmp/docusaurus_build'
)!
