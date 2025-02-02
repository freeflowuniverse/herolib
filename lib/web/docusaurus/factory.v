module docusaurus


import os
// import freeflowuniverse.herolib.data.doctree.collection
import freeflowuniverse.herolib.core.pathlib
// import freeflowuniverse.herolib.ui.console
// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.develop.gittools

@[heap]
pub struct DocusaurusFactory {
pub mut:
	sites        []&DocSite @[skip; str: skip]
	path_build   pathlib.Path
	// path_publish pathlib.Path
	args         DocusaurusArgs
}

@[params]
pub struct DocusaurusArgs {
pub mut:
	// publish_path string
	build_path   string
	production   bool

}
pub fn new(args_ DocusaurusArgs) !&DocusaurusFactory {
	mut args:=args_
	if args.build_path == ""{
		args.build_path = "${os.home_dir()}/hero/var/docusaurus"
	}
	// if args.publish_path == ""{
	// 	args.publish_path = "${os.home_dir()}/hero/var/docusaurus/publish"
	// }	
	mut ds := &DocusaurusFactory{
		args:         args_
		path_build:   pathlib.get_dir(path: args.build_path, create: true)!
		// path_publish: pathlib.get_dir(path: args_.publish_path, create: true)!
	}

	ds.template_install()!

	return ds

}
