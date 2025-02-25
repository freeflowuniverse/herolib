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
	args   DSiteGetArgs
	errors []SiteError
	config Config
	factory &DocusaurusFactory @[skip; str: skip] // Reference to the parent
}


pub fn (mut s DocSite) build() ! {
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bash build.sh
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) build_dev_publish() ! {
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bash build_dev_publish.sh
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) build_publish()! {
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bash build_publish.sh
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) dev()! {
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

	if s.args.watch_changes {
		docs_path := '${s.path_src.path}/docs'
		watch_docs(docs_path, s.path_src.path, s.path_build.path)!
	}

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

fn check_item(item string)!{
	item2:=item.trim_space().trim("/").trim_space().all_after_last("/") 
	if ["internal","infodev","info","dev","friends","dd","web"].contains(item2){
		return error("destination path is wrong, cannot be: ${item}")
	}

}

fn (mut site DocSite) check() ! {
	for item in site.config.main.build_dest{
		check_item(item)!
	}
	for item in site.config.main.build_dest_dev{
		check_item(item)!
	}	
}

pub fn (mut site DocSite) generate() ! {
	console.print_header(' site generate: ${site.name} on ${site.path_build.path}')
	console.print_header(' site source on ${site.path_src.path}')
	site.check()!
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

	site.factory.template_install(template_update:false, install:false, delete:false)!

	cfg := site.config

	mut myhome:="\$\{HOME\}" //for usage in bash

	profile_include := osal.profile_path_source()!.replace(os.home_dir(),myhome)

	mydir:=site.path_build.path.replace(os.home_dir(),myhome)

	for item in ['src', 'static'] {
		mut aa := site.path_src.dir_get(item) or {continue}
		aa.copy(dest: '${site.factory.path_build.path}/${item}', delete:false)!
		
	}
	

	develop := $tmpl('templates/develop.sh')
	build := $tmpl('templates/build.sh')
	build_dev_publish := $tmpl('templates/build_dev_publish.sh')
	build_publish := $tmpl('templates/build_publish.sh')

	mut develop_ := site.path_build.file_get_new('develop.sh')!
	develop_.template_write(develop, true)!
	develop_.chmod(0o700)!

	mut build_ := site.path_build.file_get_new('build.sh')!
	build_.template_write(build, true)!
	build_.chmod(0o700)!

	mut build_publish_ := site.path_build.file_get_new('build_publish.sh')!
	build_publish_.template_write(build_publish, true)!
	build_publish_.chmod(0o700)!

	mut build_dev_publish_ := site.path_build.file_get_new('build_dev_publish.sh')!
	build_dev_publish_.template_write(build_dev_publish, true)!
	build_dev_publish_.chmod(0o700)!
	
	develop_templ := $tmpl('templates/develop_src.sh')	
	mut develop2_ := site.path_src.file_get_new('develop.sh')!
	develop2_.template_write(develop_templ, true)!
	develop2_.chmod(0o700)!
	
	build_templ := $tmpl('templates/build_src.sh')
	mut build2_ := site.path_src.file_get_new('build.sh')!
	build2_.template_write(build, true)!
	build2_.chmod(0o700)!

}
