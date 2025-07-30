module docusaurus

import freeflowuniverse.herolib.osal.screen
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.site
import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import time

@[heap]
pub struct DocSite {
pub mut:
	name         string
	path_src     pathlib.Path
	path_publish pathlib.Path
	errors       []SiteError
	config       Configuration      // Docusaurus-specific config, transformed from site.SiteConfig
	site         &site.Site         @[skip; str: skip]
	factory      &DocusaurusFactory @[skip; str: skip] // Reference to the parent
	// OPEN & WATCH ARGS are now passed directly to dev_watch
}


pub fn (mut s DocSite) build() ! {
	s.generate()!
	osal.exec(
		cmd: '
			cd ${s.factory.path_build.path}
			bun run build
			',
		retry: 0
	)!
}

pub fn (mut s DocSite) build_dev_publish() ! {
	s.generate()!
	osal.exec(
		cmd: '
			cd ${s.factory.path_build.path}
			exit 1
			',
		retry: 0
	)!
}

pub fn (mut s DocSite) build_publish() ! {
	s.generate()!
	osal.exec(
		cmd: '
			cd ${s.factory.path_build.path}
			exit 1
			',
		retry: 0
	)!
}

@[params]
pub struct DevArgs {
pub mut:
	host          string = 'localhost'
	port          int    = 3000
	open          bool   // open browser
	watch_changes bool   // watch for file changes
}

pub fn (mut s DocSite) open(host string, port int) ! {
	// Print instructions for user
	console.print_item('open browser: http://${host}:${port}')
	osal.exec(cmd: 'open http://${host}:${port}')!
}

pub fn (mut s DocSite) dev(args DevArgs) ! {
	s.generate()!
	
	if args.watch_changes {
		s.dev_watch(args)!
	} else {
		if args.open {
			s.open(args.host, args.port)!
		}
		osal.exec(
			cmd: '
				cd ${s.factory.path_build.path}
				bun run start -p ${args.port} -h ${args.host}
				',
			retry: 0
		)!
	}
}

pub fn (mut s DocSite) dev_watch(args DevArgs) ! {
	s.generate()!

	// Create screen session for docusaurus development server
	mut screen_name := 'docusaurus_${s.name}'
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
	console.print_item('To view the server output:: cd ${s.factory.path_build.path}')
	scr.cmd_send('cd ${s.factory.path_build.path}')!

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
	spawn watch_docs(s, s.path_src.path, s.factory.path_build.path)
	println('')

	if args.open {
		s.open(args.host, args.port)!
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

pub fn (mut doc_site DocSite) error(args ErrorArgs) {
	// path2 := pathlib.get(args.path)
	e := SiteError{
		path: args.path
		msg:  args.msg
		cat:  args.cat
	}
	site.errors << e
	console.print_stderr(args.msg)
}
