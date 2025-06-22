module docusaurus

import freeflowuniverse.herolib.osal.screen
import os
import freeflowuniverse.herolib.core.pathlib
// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.develop.gittools
// import json
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.ui.console
import time

@[heap]
pub struct DocSite {
pub mut:
	name       string
	url        string
	path_src   pathlib.Path
	path_build pathlib.Path
	// path_publish pathlib.Path
	args    DSiteGetArgs
	errors  []SiteError
	config  Configuration
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

pub fn (mut s DocSite) build_publish() ! {
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bash build_publish.sh
			'
		retry: 0
	)!
}

@[params]
pub struct DevArgs {
pub mut:
	host string = 'localhost'
	port int    = 3000
}

pub fn (mut s DocSite) open(args DevArgs) ! {
	// Print instructions for user
	console.print_item('open browser: https://${args.host}:${args.port}')
	osal.exec(cmd: 'open https://${args.host}:${args.port}')!
}

pub fn (mut s DocSite) dev(args DevArgs) ! {
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
	console.print_item('To view the server output:: cd ${s.path_build.path}')
	scr.cmd_send('cd ${s.path_build.path}')!

	// Start script recording in the screen session for log streaming
	log_file := '/tmp/docusaurus_${screen_name}.log'
	script_cmd := 'script -f ${log_file}'
	scr.cmd_send(script_cmd)!

	// Small delay to ensure script is ready
	time.sleep(500 * time.millisecond)

	// Start bun in the scripted session
	bun_cmd := 'bun start -p ${args.port} -h ${args.host}'
	scr.cmd_send(bun_cmd)!

	// Stream the log output to current terminal
	console.print_header(' Docusaurus Development Server')
	console.print_item('Streaming server output... Press Ctrl+C to detach and leave server running')
	console.print_item('Server will be available at: http://${args.host}:${args.port}')
	console.print_item('To reattach later: screen -r ${screen_name}')
	println('')

	// Stream logs until user interrupts
	s.stream_logs(log_file, screen_name)!

	// After user interrupts, show final instructions
	console.print_header(' Server Running in Background')
	console.print_item('✓ Development server is running in background')
	console.print_item('Server URL: http://${args.host}:${args.port}')
	console.print_item('To reattach: screen -r ${screen_name}')
	console.print_item('To stop server: screen -S ${screen_name} -X kill')
	console.print_item('The site content is on: ${s.path_src.path}/docs')

	// Start the watcher in a separate thread
	// mut tf:=spawn watch_docs(docs_path, s.path_src.path, s.path_build.path)
	// tf.wait()!
	println('\n')

	if s.args.open {
		s.open()!
	}

	if s.args.watch_changes {
		docs_path := '${s.path_src.path}/docs'
		watch_docs(docs_path, s.path_src.path, s.path_build.path)!
	}
}

// Stream logs from script file to current terminal until user interrupts
fn (mut s DocSite) stream_logs(log_file string, screen_name string) ! {
	// Wait a moment for the log file to be created
	mut attempts := 0
	for !os.exists(log_file) && attempts < 10 {
		time.sleep(200 * time.millisecond)
		attempts++
	}

	if !os.exists(log_file) {
		console.print_stderr('Warning: Log file not created, falling back to screen attach')
		console.print_item('Attaching to screen session... Press Ctrl+A then D to detach')
		// Fallback to direct screen attach
		osal.execute_interactive('screen -r ${screen_name}')!
		return
	}

	// Use tail -f to stream the log file
	// The -f flag follows the file as it grows
	tail_cmd := 'tail -f ${log_file}'

	// Execute tail in interactive mode - this will stream until Ctrl+C
	osal.execute_interactive(tail_cmd) or {
		// If tail fails, try alternative approach
		console.print_stderr('Log streaming failed, attaching to screen session...')
		osal.execute_interactive('screen -r ${screen_name}')!
		return
	}

	// Clean up the log file after streaming
	os.rm(log_file) or {}
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

fn check_item(item string) ! {
	item2 := item.trim_space().trim('/').trim_space().all_after_last('/')
	if ['internal', 'infodev', 'info', 'dev', 'friends', 'dd', 'web'].contains(item2) {
		return error('destination path is wrong, cannot be: ${item}')
	}
}

fn (mut site DocSite) check() ! {
	for item in site.config.main.build_dest {
		check_item(item)!
	}
	for item in site.config.main.build_dest_dev {
		check_item(item)!
	}
}

fn (mut site DocSite) template_install() ! {
	mut gs := gittools.new()!

	site.factory.template_install(template_update: false, install: true, delete: false)!

	cfg := site.config

	mut myhome := '\$\{HOME\}' // for usage in bash

	profile_include := osal.profile_path_source()!.replace(os.home_dir(), myhome)

	mydir := site.path_build.path.replace(os.home_dir(), myhome)

	for item in ['src', 'static'] {
		mut aa := site.path_src.dir_get(item) or { continue }
		aa.copy(dest: '${site.factory.path_build.path}/${item}', delete: false)!
	}

	develop := $tmpl('templates/develop.sh')
	build := $tmpl('templates/build.sh')
	// build_dev_publish := $tmpl('templates/build_dev_publish.sh')
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

	// TODO: implement
	// mut build_dev_publish_ := site.path_build.file_get_new('build_dev_publish.sh')!
	// build_dev_publish_.template_write(build_dev_publish, true)!
	// build_dev_publish_.chmod(0o700)!

	develop_templ := $tmpl('templates/develop_src.sh')
	mut develop2_ := site.path_src.file_get_new('develop.sh')!
	develop2_.template_write(develop_templ, true)!
	develop2_.chmod(0o700)!

	build_templ := $tmpl('templates/build_src.sh')
	mut build2_ := site.path_src.file_get_new('build.sh')!
	build2_.template_write(build_templ, true)!
	build2_.chmod(0o700)!
}
