module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib

@[heap]
pub struct DocusaurusFactory {
pub mut:
	sites      []&DocSite @[skip; str: skip]
	path_build pathlib.Path
	path_publish pathlib.Path
	args   DocusaurusArgs
	config Configuration // Stores configuration from HeroScript if provided
}

@[params]
pub struct DocusaurusArgs {
pub mut:
	path_publish string
	path_build string
	production bool
	update     bool
	heroscript      string
	heroscript_path string
}

pub fn new(args_ DocusaurusArgs) !&DocusaurusFactory {
	mut args := args_
	if args.path_build == '' {
		args.path_build = '${os.home_dir()}/hero/var/docusaurus/build'
	}
	if args.path_publish == ""{
		args.path_publish = "${os.home_dir()}/hero/var/docusaurus/publish"
	}

	// Create the factory instance
	mut f := &DocusaurusFactory{
		args:       args_
		path_build: pathlib.get_dir(path: args.path_build, create: true)!
		path_publish: pathlib.get_dir(path: args_.path_publish, create: true)!
	}

	f.template_install(install: args.update, template_update: args.update)!

	if args.heroscript != '' {
		play(heroscript: args.heroscript, heroscript_path: args.heroscript_path)!
	}

	return f
}
