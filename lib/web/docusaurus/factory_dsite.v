module docusaurus

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.ui.console

@[params]
pub struct AddArgs {
pub mut:
	sitename string // needs to exist in web.site module
}

pub fn dsite_define(sitename string) ! {
	console.print_header('Add Docusaurus Site: ${sitename}')

	mut f := factory_get()!

	path_publish := '${f.path_publish.path}/${sitename}'
	path_build_ := '${f.path_build.path}/${sitename}'

	// Get the site object after processing, this is the website which is a generic definition of a site
	mut website := site.get(name: sitename)!

	// Create the DocSite instance
	mut dsite := &DocSite{
		name:         sitename
		path_publish: pathlib.get_dir(path: path_publish, create: true)!
		path_build:   pathlib.get_dir(path: path_build_, create: true)!
		config:       new_configuration(website.siteconfig)!
		website:      website
	}

	docusaurus_sites[sitename] = dsite
}

pub fn dsite_get(name_ string) !&DocSite {
	name := texttools.name_fix(name_)
	return docusaurus_sites[name] or {
		return error('docusaurus site with name "${name}" does not exist')
	}
}

pub fn dsite_exists(name_ string) !bool {
	name := texttools.name_fix(name_)
	_ := docusaurus_sites[name] or { return false }
	return true
}

// dsite_names returns the list of defined docusaurus site names.
pub fn dsite_names() []string {
	mut names := []string{}
	for k, _ in docusaurus_sites {
		names << k
	}
	return names
}

// dsite_get_only returns the only defined site, or an error if there are none or more than one.
pub fn dsite_get_only() !&DocSite {
	if docusaurus_sites.len != 1 {
		return error('expected exactly one docusaurus site to be defined, found ${docusaurus_sites.len}')
	}
	for _, v in docusaurus_sites {
		return v
	}
	return error('no docusaurus site found')
}
