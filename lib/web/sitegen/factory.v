module sitegen

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.data.doctree
import os

pub struct SiteFactory {
pub mut:
	sites map[string]&Site
	path  pathlib.Path
	tree &doctree.Tree
}

@[params]
pub struct SiteNewArgs {
pub mut:
	path string
}


// new creates a new siteconfig and stores it in redis, or gets an existing one
pub fn new(tree &doctree.Tree, args SiteNewArgs) !SiteFactory {
	mut path := args.path
	if path == '' {
		path = '${os.home_dir()}/hero/var/sitegen'
	}
	mut factory := SiteFactory{
		path: pathlib.get_dir(path: path, create: true)!
		tree: tree
	}
	return factory
}

pub fn (mut f SiteFactory) site_get(name string) !&Site {
	mut s := f.sites[name] or { 
		mut mysite:=&Site{
			path: f.path.dir_get_new(name)!
			name: name
			tree: f.tree
		}
		mysite
	}
	return s
}
