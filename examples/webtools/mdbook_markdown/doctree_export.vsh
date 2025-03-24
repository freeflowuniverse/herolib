#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.doctree

mut tree := doctree.new(name: 'test')!

// path      string
// heal      bool = true // healing means we fix images
// git_url   string
// git_reset bool
// git_root  string
// git_pull  bool
// load      bool = true // means we scan automatically the added collection
for project in 'projectinca, legal, why'.split(',').map(it.trim_space()) {
	tree.scan(
		git_url:  'https://git.ourworld.tf/tfgrid/info_tfgrid/src/branch/development/collections/${project}'
		git_pull: false
	)!
}


tree.export(
	destination:    '/tmp/mdexport'
	reset:          true
	//keep_structure: true
	exclude_errors: false
)!
