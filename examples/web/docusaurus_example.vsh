#!/usr/bin/env -S v -n -w -gc none  -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.playcmds

playcmds.run(
	heroscript: '
	!!docusaurus.define
		path_build: "/tmp/docusaurus_build"
		path_publish: "/tmp/docusaurus_publish"
		reset: 1
		install: 1
		template_update: 1

	!!docusaurus.add sitename:"tfgrid_tech"
		git_url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech"
		git_root:"/tmp/code"
		git_reset:1
		git_pull:1
		play:true

	!!docusaurus.build

	!!docusaurus.dev site:"tfgrid_tech" open:true watch_changes:true
'
)!
