#!/usr/bin/env -S v -n -w -gc none  -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.docusaurus

docusaurus.new(
	heroscript: '

	!!docusaurus.define
		path_build: "/tmp/docusaurus_build"
		path_publish: "/tmp/docusaurus_publish"

	!!docusaurus.add name:"tfgrid_docs" 
		git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech"
		// git_root:"/tmp/code"
		// git_reset:1
		// git_pull:1

	!!docusaurus.dev

	'
)!
