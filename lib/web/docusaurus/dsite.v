module docusaurus

import freeflowuniverse.herolib.osal.screen
import os
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.web.site as sitemodule
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import time

@[heap]
pub struct DocSite {
pub mut:
	name         string
	url          string
	path_src     pathlib.Path
	path_publish pathlib.Path
	path_build   pathlib.Path
	errors       []SiteError
	config       Configuration
	website      sitemodule.Site
}

pub fn (mut s DocSite) build() ! {
	s.generate()!
	osal.exec(
		cmd:   '
			cd ${s.path_build.path}
			bun run build
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) build_dev_publish() ! {
	s.generate()!
	osal.exec(
		cmd:   '
			cd ${s.path_build.path}
			bun run build
			'
		retry: 0
	)!
}

pub fn (mut s DocSite) build_publish() ! {
	s.generate()!
	osal.exec(
		cmd:   '
			cd ${s.path_build.path}
			bun run build
			'
		retry: 0
	)!
}

@[params]
pub struct DevArgs {
pub mut:
	host          string = 'localhost'
	port          int    = 3000
	open          bool   = true  // whether to open the browser automatically
	watch_changes bool   = false // whether to watch for changes in docs and rebuild automatically
}

pub fn (mut s DocSite) open(args DevArgs) ! {
	// Print instructions for user
	console.print_item('open browser: https://${args.host}:${args.port}')
	osal.exec(cmd: 'open https://${args.host}:${args.port}')!
}

pub fn (mut s DocSite) dev(args DevArgs) ! {
	s.generate()!
	osal.exec(
		cmd:   '	
			cd ${s.path_build.path}
			bun run start -p ${args.port} -h ${args.host}
			'
		retry: 0
	)!
	s.open()!
}

pub fn (mut s DocSite) dev_watch(args DevArgs) ! {
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

	if args.open {
		s.open()!
	}

	if args.watch_changes {
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
