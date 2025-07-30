module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.ui.console

__global (
	docusaurus_factories map[string]&DocusaurusFactory
)

@[heap]
pub struct DocusaurusFactory {
pub mut:
	name         string
	sites        map[string]&DocSite @[skip; str: skip]
	path_build   pathlib.Path
	path_publish pathlib.Path
}

@[params]
pub struct FactoryArgs {
pub mut:
	name            string = 'default'
	path_publish    string
	path_build      string
	install         bool // install required modules
	reset           bool // reset the full system
	template_update bool // update docusaurus template
}

pub fn new(args FactoryArgs) !&DocusaurusFactory {
	name := texttools.name_fix(args.name)
	if name in docusaurus_factories {
		console.print_debug('Docusaurus factory ${name} already exists, returning existing.')
		return docusaurus_factories[name]
	}

	console.print_debug('Create docusaurus factory ${name}')

	mut path_build_ := args.path_build
	if path_build_ == '' {
		path_build_ = '${os.home_dir()}/hero/var/docusaurus/build'
	}
	mut path_publish_ := args.path_publish
	if path_publish_ == '' {
		path_publish_ = '${os.home_dir()}/hero/var/docusaurus/publish'
	}

	// Create the factory instance
	mut f := &DocusaurusFactory{
		name:         name
		path_build:   pathlib.get_dir(path: path_build_, create: true)!
		path_publish: pathlib.get_dir(path: path_publish_, create: true)!
	}

	f.install(
		install: args.install
		template_update: args.template_update
		reset: args.reset
	)!

	docusaurus_factories[name] = f
	return f
}

pub fn get(name_ string) !&DocusaurusFactory {
	name := texttools.name_fix(name_)
	return docusaurus_factories[name] or {
		return error('docusaurus factory with name "${name}" does not exist')
	}
}

pub fn default() !&DocusaurusFactory {
	if docusaurus_factories.len == 0 {
		return new(FactoryArgs{})!
	}
	if 'default' in docusaurus_factories {
		return get('default')!
	}
	// return the first one if default is not there
	for _, factory in docusaurus_factories {
		return factory
	}
	return error('no docusaurus factories found')
}

// get site from the docusaurus factory
pub fn (mut self DocusaurusFactory) site_get(name string) !&DocSite {
	name_ := texttools.name_fix(name)
	return self.sites[name_] or { return error('site not found: ${name} in docusaurus factory.') }
}