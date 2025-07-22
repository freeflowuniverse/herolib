module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools

@[heap]
pub struct DocusaurusFactory {
pub mut:
	sites        map[string]&DocSite @[skip; str: skip]
	path_build   pathlib.Path
	path_publish pathlib.Path
	args         DocusaurusArgs
	config       Configuration // Stores configuration from HeroScript if provided
}

@[params]
pub struct DocusaurusArgs {
pub mut:
	path_publish    string
	path_build      string
	install         bool   //install required modules
	reset           bool   //reset the full system
	template_update bool	//update docusaurus template
	heroscript      string
	heroscript_path string
}

pub fn new(args_ DocusaurusArgs) !&DocusaurusFactory {
	mut args := args_
	if args.path_build == '' {
		args.path_build = '${os.home_dir()}/hero/var/docusaurus/build'
	}
	if args.path_publish == '' {
		args.path_publish = '${os.home_dir()}/hero/var/docusaurus/publish'
	}

	// Create the factory instance
	mut f := &DocusaurusFactory{
		args:         args_
		path_build:   pathlib.get_dir(path: args.path_build, create: true)!
		path_publish: pathlib.get_dir(path: args_.path_publish, create: true)!
	}

	f.install(install: args.install, template_update: args.template_update, reset: args.reset)!

	if args.heroscript != '' {
		play(heroscript: args.heroscript, heroscript_path: args.heroscript_path)!
	}

	return f
}


// get site from the docusaurus factory
pub fn (mut self DocusaurusFactory) site_get(name string) ! {
	name_:=texttools.name_fix(name: name)!
	return self.sites[name_] or {return error('site not found: ${name} in docusaurus factory.')!}
}