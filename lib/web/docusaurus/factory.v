module docusaurus

import os
// import freeflowuniverse.herolib.data.doctree.collection
import freeflowuniverse.herolib.core.pathlib
// import freeflowuniverse.herolib.ui.console
// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.ui.console

@[heap]
pub struct DocusaurusFactory {
pub mut:
	sites      []&DocSite @[skip; str: skip]
	path_build pathlib.Path
	// path_publish pathlib.Path
	args DocusaurusArgs
	config Config // Stores configuration from HeroScript if provided
}

@[params]
pub struct DocusaurusArgs {
pub mut:
	// publish_path string
	build_path string
	production bool
	update     bool
	heroscript string
	heroscript_path string
}

pub fn new(args_ DocusaurusArgs) !&DocusaurusFactory {
	mut args := args_
	if args.build_path == '' {
		args.build_path = '${os.home_dir()}/hero/var/docusaurus'
	}
	// if args.publish_path == ""{
	// 	args.publish_path = "${os.home_dir()}/hero/var/docusaurus/publish"
	// }
	
	// Create the factory instance
	mut ds := &DocusaurusFactory{
		args:       args_
		path_build: pathlib.get_dir(path: args.build_path, create: true)!
		// path_publish: pathlib.get_dir(path: args_.publish_path, create: true)!
	}

	// Process HeroScript
	mut heroscript_text := args.heroscript
	mut heroscript_path := args.heroscript_path
	
	// If no heroscript is explicitly provided, check current directory
	if heroscript_text == '' && heroscript_path == '' {
		// First check if there's a .heroscript file in the current directory
		current_dir := os.getwd()
		cfg_dir := os.join_path(current_dir, 'cfg')		
		if os.exists(cfg_dir) {
			heroscript_path = cfg_dir
		}
	}
	
	// Process any HeroScript that was found
	if heroscript_text != '' || heroscript_path != '' {
		ds.config = play(
			heroscript: heroscript_text
			heroscript_path: heroscript_path
		)!
	}

	ds.template_install(install: true, template_update: args.update, delete: true)!

	return ds
}
