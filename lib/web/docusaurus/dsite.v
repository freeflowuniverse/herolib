module docusaurus

import freeflowuniverse.herolib.osal.screen
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.develop.gittools
import json
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console

@[heap]
pub struct DocSite {
pub mut:
	name       string
	url        string
	path_src   pathlib.Path
	path_build pathlib.Path
	// path_publish pathlib.Path
	args   DSiteNewArgs
	errors []SiteError
	config Config
}

@[params]
pub struct DSiteNewArgs {
pub mut:
	name      string
	nameshort string
	path      string
	url       string
	// publish_path string
	build_path    string
	production    bool
	watch_changes bool = true
	update        bool
}

pub fn (mut f DocusaurusFactory) build_dev(args_ DSiteNewArgs) !&DocSite {
	mut s := f.add(args_)!
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bash build_dev.sh
			'
		retry: 0
	)!
	return s
}

pub fn (mut f DocusaurusFactory) build(args_ DSiteNewArgs) !&DocSite {
	mut s := f.add(args_)!
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bash build.sh
			'
		retry: 0
	)!
	return s
}

pub fn (mut f DocusaurusFactory) dev(args_ DSiteNewArgs) !&DocSite {
	mut s := f.add(args_)!

	s.clean()!
	s.generate()!

	// Create screen session for docusaurus development server
	mut screen_name := 'docusaurus'
	mut sf := screen.new()!

	// Add and start a new screen session
	mut scr := sf.add(
		name:   screen_name
		cmd:    '/bin/bash'
		start:  true
		attach: false
		reset:  true
	)!

	// Send commands to the screen session
	scr.cmd_send('cd ${s.path_build.path}')!
	scr.cmd_send('bash develop.sh')!

	// Print instructions for user
	console.print_header(' Docusaurus Development Server')
	console.print_item('Development server is running in a screen session.')
	console.print_item('To view the server output:')
	console.print_item('  1. Attach to screen: screen -r ${screen_name}')
	console.print_item('  2. To detach from screen: Press Ctrl+A then D')
	console.print_item('  3. To list all screens: screen -ls')
	console.print_item('The site content is on::')
	console.print_item('  1. location of documents: ${s.path_src.path}/docs')
	if osal.cmd_exists('code') {
		console.print_item('  2. We opened above dir in vscode.')
		osal.exec(cmd: 'code ${s.path_src.path}/docs')!
	}

	// Start the watcher in a separate thread
	// mut tf:=spawn watch_docs(docs_path, s.path_src.path, s.path_build.path)
	// tf.wait()!
	println('\n')

	if args_.watch_changes {
		docs_path := '${s.path_src.path}/docs'
		watch_docs(docs_path, s.path_src.path, s.path_build.path)!
	}

	return s
}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

pub fn (mut f DocusaurusFactory) add(args_ DSiteNewArgs) !&DocSite {
	console.print_header(' Docusaurus: ${args_.name}')
	mut args := args_

	if args.build_path.len == 0 {
		args.build_path = '${f.path_build.path}'
	}
	// if args.publish_path.len == 0 {
	// 	args.publish_path = '${f.path_publish.path}/${args.name}'

	if args.url.len > 0 {
		mut gs := gittools.new()!
		args.path = gs.get_path(url: args.url)!
	}

	if args.path.len == 0 {
		return error("Can't get path from docusaurus site, its not specified.")
	}

	mut gs := gittools.new()!
	mut r := gs.get_repo(
		url:  'https://github.com/freeflowuniverse/docusaurus_template.git'
		pull: args.update
	)!
	mut template_path := r.patho()!

	// First ensure cfg directory exists in src, if not copy from template
	if !os.exists('${args.path}/cfg') {
		mut template_cfg := template_path.dir_get('cfg')!
		template_cfg.copy(dest: '${args.path}/cfg')!
	}

	if !os.exists('${args.path}/docs') {
		mut template_cfg := template_path.dir_get('docs')!
		template_cfg.copy(dest: '${args.path}/docs')!
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
	}

	f.sites << &ds

	return &ds
}

@[params]
pub struct ErrorArgs {
pub mut:
	path string
	msg  string
	cat  ErrorCat
}

pub fn (mut site DocSite) error(args ErrorArgs) {
	// path2 := pathlib.get(args.path)
	e := SiteError{
		path: args.path
		msg:  args.msg
		cat:  args.cat
	}
	site.errors << e
	console.print_stderr(args.msg)
}

pub fn (mut site DocSite) generate() ! {
	console.print_header(' site generate: ${site.name} on ${site.path_build.path}')
	site.template_install()!
	// osal.exec(
	// 	cmd: '	
	// 		cd ${site.path_build.path}
	// 		#Docusaurus build --dest-dir ${site.path_publish.path}
	// 		'
	// 	retry: 0
	// )!

	// Now copy all directories that exist in src to build
	for item in ['src', 'static', 'cfg'] {
		if os.exists('${site.path_src.path}/${item}') {
			mut aa := site.path_src.dir_get(item)!
			aa.copy(dest: '${site.path_build.path}/${item}')!
		}
	}
	for item in ['docs'] {
		if os.exists('${site.path_src.path}/${item}') {
			mut aa := site.path_src.dir_get(item)!
			aa.copy(dest: '${site.path_build.path}/${item}', delete: true)!
		}
	}
}

fn (mut site DocSite) template_install() ! {
	mut gs := gittools.new()!

	mut r := gs.get_repo(url: 'https://github.com/freeflowuniverse/docusaurus_template.git')!
	mut template_path := r.patho()!

	// always start from template first
	for item in ['src', 'static', 'cfg'] {
		mut aa := template_path.dir_get(item)!
		aa.copy(dest: '${site.path_build.path}/${item}', delete: true)!
	}

	for item in ['package.json', 'sidebars.ts', 'tsconfig.json', 'docusaurus.config.ts'] {
		src_path := os.join_path(template_path.path, item)
		dest_path := os.join_path(site.path_build.path, item)
		os.cp(src_path, dest_path) or {
			return error('Failed to copy ${item} to build path: ${err}')
		}
	}

	for item in ['.gitignore'] {
		src_path := os.join_path(template_path.path, item)
		dest_path := os.join_path(site.path_src.path, item)
		os.cp(src_path, dest_path) or {
			return error('Failed to copy ${item} to source path: ${err}')
		}
	}

	cfg := site.config

	profile_include := osal.profile_path_source()!

	develop := $tmpl('templates/develop.sh')
	build := $tmpl('templates/build.sh')
	build_dev := $tmpl('templates/build_dev.sh')

	mut develop_ := site.path_build.file_get_new('develop.sh')!
	develop_.template_write(develop, true)!
	develop_.chmod(0o700)!

	mut build_ := site.path_build.file_get_new('build.sh')!
	build_.template_write(build, true)!
	build_.chmod(0o700)!

	mut build_dev_ := site.path_build.file_get_new('build_dev.sh')!
	build_dev_.template_write(build_dev, true)!
	build_dev_.chmod(0o700)!

	mut develop2_ := site.path_src.file_get_new('develop.sh')!
	develop2_.template_write(develop, true)!
	develop2_.chmod(0o700)!

	mut build2_ := site.path_src.file_get_new('build.sh')!
	build2_.template_write(build, true)!
	build2_.chmod(0o700)!

	mut build_dev2_ := site.path_src.file_get_new('build_dev.sh')!
	build_dev2_.template_write(build_dev, true)!
	build_dev2_.chmod(0o700)!
}
