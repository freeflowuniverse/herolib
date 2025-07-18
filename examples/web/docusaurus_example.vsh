#!/usr/bin/env -S v -n -w -gc none  -cg -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.web.docusaurus
import os

// Create a new docusaurus factory
mut ds := docusaurus.new(
	path_build: '/tmp/docusaurus_build'
	path_publish: '/tmp/docusaurus_publish'
)!

// mut site:=ds.get(path:"${os.home_dir()}/code/git.threefold.info/tfgrid/docs_tfgrid4/ebooks/tech",name:"atest")!
mut site:=ds.get(url:"https://git.threefold.info/tfgrid/docs_tfgrid4/src/branch/main/ebooks/tech",name:"atest")!

// println(site)

//next generates but doesn't do anything beyond
// site.generate()!

site.dev()!
