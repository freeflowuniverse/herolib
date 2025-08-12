module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.core as osal

@[params]
pub struct AddArgs {
pub mut:
	sitename     string // needs to exist in web.site module
	path         string // site of the docusaurus site with the config as is needed to populate the docusaurus site
	git_url      string
	git_reset    bool
	git_root     string
	git_pull     bool
	path_publish string
}

pub fn dsite_add(args_ AddArgs) !&DocSite {
	mut args := args_
	args.sitename = texttools.name_fix(args_.sitename)

	console.print_header('Add Docusaurus Site: ${args.sitename}')

	if args.sitename in docusaurus_sites {
		return error('Docusaurus site ${args.sitename} already exists, no need to add again.')
	}

	mut path := gittools.path(
		path:       args.path
		git_url:    args.git_url
		git_reset:  args.git_reset
		git_root:   args.git_root
		git_pull:   args.git_pull
		currentdir: false
	)!
	args.path = path.path
	if !path.is_dir() {
		return error('path is not a directory')
	}

	if !os.exists('${args.path}/cfg') {
		return error('config directory for docusaurus does not exist in ${args.path}/cfg.\n${args}')
	}

	configpath := '${args.path}/cfg'
	if !os.exists(configpath) {
		return error("can't find config file for docusaurus in ${configpath}")
	}

	osal.rm('${args.path}/cfg/main.json')!
	osal.rm('${args.path}/cfg/footer.json')!
	osal.rm('${args.path}/cfg/navbar.json')!
	osal.rm('${args.path}/build.sh')!
	osal.rm('${args.path}/develop.sh')!
	osal.rm('${args.path}/sync.sh')!
	osal.rm('${args.path}/.DS_Store')!

	mut f := factory_get()!

	if args.path_publish == '' {
		args.path_publish = '${f.path_publish.path}/${args.sitename}'
	}
	path_build_ := '${f.path_build.path}/${args.sitename}'

	// Get the site object after processing, this is the website which is a generic definition of a site
	mut website := site.get(name: args.sitename)!

	// Create the DocSite instance
	mut dsite := &DocSite{
		name:         args.sitename
		path_src:     pathlib.get_dir(path: args.path, create: false)!
		path_publish: pathlib.get_dir(path: args.path_publish, create: true)!
		path_build:   pathlib.get_dir(path: path_build_, create: true)!
		config:       new_configuration(website.siteconfig)!
		website:      website
	}

	docusaurus_sites[args.sitename] = dsite
	return dsite
}

pub fn dsite_get(name_ string) !&DocSite {
	name := texttools.name_fix(name_)
	return docusaurus_sites[name] or {
		return error('docusaurus site with name "${name}" does not exist')
	}
}

pub fn dsite_exists(name_ string) !bool {
	name := texttools.name_fix(name_)
	d := docusaurus_sites[name] or { return false }
	return true
}
