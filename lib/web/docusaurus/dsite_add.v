module docusaurus

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.ui.console

@[params]
pub struct AddArgs {
pub:
	site &site.Site
	path string // Source path for additional assets (static/, local docs/)
}

pub fn (mut f DocusaurusFactory) add(args AddArgs) !&DocSite {
	name := args.site.siteconfig.name
	console.print_header('Docusaurus: add site: ${name}')

	if name in f.sites {
		return f.sites[name]
	}

	// The `path` arg points to the source repo/directory for this site,
	// containing things like `static/` or a base `docs/` folder.
	src_path := pathlib.get_dir(path: args.path, create: false) or {
		return error("Source path '${args.path}' for site '${name}' not found or not a directory.")
	}

	// Transform the generic site config to a docusaurus-specific one
	docusaurus_config := config_from_site(args.site.siteconfig)!

	// The path to publish this specific site to
	mut path_publish := pathlib.get_dir(path: '${f.path_publish.path}/${name}', create: true)!

	mut ds := &DocSite{
		name:         name
		path_src:     src_path
		path_publish: path_publish
		site:         args.site
		config:       docusaurus_config
		factory:      f
	}
	ds.check()!

	f.sites[name] = ds

	return ds
}
