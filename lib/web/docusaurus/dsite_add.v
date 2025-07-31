module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.core as osal
// import freeflowuniverse.herolib.data.doctree

pub fn (mut f DocusaurusFactory) add(args_ DSiteGetArgs) !&DocSite {
	console.print_header(' Docusaurus: ${args_.name}')
	mut args := args_

	mut path := gittools.path(
		path:       args.path
		git_url:    args.git_url
		git_reset:  args.git_reset
		git_root:   args.git_root
		git_pull:   args.git_pull
		currentdir: true
	)!
	args.path = path.path
	if !path.is_dir() {
		return error('path is not a directory')
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

	mut myconfig := config_load(configpath)!

	if myconfig.main.name.len == 0 {
		myconfig.main.name = myconfig.main.base_url.trim_space().trim('/').trim_space()
	}

	if args.name == '' {
		args.name = myconfig.main.name
	}

	if args.nameshort.len == 0 {
		args.nameshort = args.name
	}

	args.name = texttools.name_fix(args.name)
	args.nameshort = texttools.name_fix(args.nameshort)

	if args.path_publish == '' {
		args.path_publish = '${f.path_publish}/${args.name}'
	}

	// this will get us the siteconfig run through plbook
	mut mysite := site.new(name: args.name)!
	mut mysiteconfig := mysite.siteconfig

	// NOT NEEDED IS DONE FROM HEROSCRIPT BEFORE
	// //now run the plbook to get all relevant for the site, {SITENAME} has been set in the context.session
	// doctree.play(
	// 	heroscript_path: configpath
	// 	reset:           args.update
	// )!

	mut ds := DocSite{
		name:         args.name
		path_src:     pathlib.get_dir(path: args.path, create: false)!
		path_publish: pathlib.get_dir(path: args.path_publish)!
		args:         args
		config:       myconfig
		siteconfig:   mysiteconfig // comes from the heroconfig
		factory:      &f
	}
	ds.check()!

	f.sites[args.name] = &ds

	return &ds
}
