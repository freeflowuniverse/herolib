module docusaurus

import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.ui.console

@[params]
pub struct DSiteGetArgs {
pub mut:
	name          string
	nameshort     string
	path          string
	url           string
	publish_path  string
	build_path    string
	production    bool
	watch_changes bool = true
	update        bool
	init 	      bool //means create new one if needed
	deploykey     string
	config ?Config
}

pub fn (mut f DocusaurusFactory) get(args_ DSiteGetArgs) !&DocSite {
	console.print_header(' Docusaurus: ${args_.name}')
	mut args := args_

	if args.build_path.len == 0 {
		args.build_path = '${f.path_build.path}'
	}
	// if args.publish_path.len == 0 {
	// 	args.publish_path = '${f.path_publish.path}/${args.name}'

	// coderoot:"${os.home_dir()}/hero/var/publishcode"
	mut gs := gittools.new(ssh_key_path: args.deploykey)!

	if args.url.len > 0 {
		args.path = gs.get_path(url: args.url)!
	}

	if args.path.trim_space() == "" {
		args.path = os.getwd()
	}	
	args.path = args.path.replace('~', os.home_dir())

	mut r := gs.get_repo(
		url:  'https://github.com/freeflowuniverse/docusaurus_template.git'
	)!
	mut template_path := r.patho()!

	// First, check if the new site args provides a configuration that can be written instead of template cfg dir
	if cfg := args.config {
		cfg.write('${args.path}/cfg')!
	} else {
		// Then ensure cfg directory exists in src,
		if !os.exists('${args.path}/cfg') {	
			if args.init{
				// else copy config from template
				mut template_cfg := template_path.dir_get('cfg')!
				template_cfg.copy(dest: '${args.path}/cfg')!
			}else{
				return error("Can't find cfg dir in chosen docusaurus location: ${args.path}")
			}
		}
	}

	if !os.exists('${args.path}/docs') {
		if args.init{
			mut template_cfg := template_path.dir_get('docs')!
			template_cfg.copy(dest: '${args.path}/docs')!
		} else{
			return error("Can't find docs dir in chosen docusaurus location: ${args.path}")
		}		
	}

	mut myconfig := load_config('${args.path}/cfg')!

	if myconfig.main.name.len == 0 {
		myconfig.main.name = myconfig.main.base_url.trim_space().trim('/').trim_space()
	}

	if args.name == '' {
		args.name = myconfig.main.name
	}

	if args.nameshort.len == 0 {
		args.nameshort = args.name
	}
	args.nameshort = texttools.name_fix(args.nameshort)

	mut ds := DocSite{
		name:       args.name
		url:        args.url
		path_src:   pathlib.get_dir(path: args.path, create: false)!
		path_build: f.path_build
		// path_publish: pathlib.get_dir(path: args.publish_path, create: true)!
		args:   args
		config: myconfig
		factory: &f
	}

	ds.check()!

	f.sites << &ds

	return &ds
}
