module tmux

import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console
import time

// uses single tmux instance for all tests

fn testsuite_begin() {
	muttmux := new() or { panic('Cannot create tmux: ${err}') }

	// reset tmux for tests
	is_running := is_running() or { panic('cannot check if tmux is running: ${err}') }
	if is_running {
		stop() or { panic('Cannot stop tmux: ${err}') }
	}
}

fn testsuite_end() {
	is_running := is_running() or { panic('cannot check if tmux is running: ${err}') }
	if is_running {
		stop() or { panic('Cannot stop tmux: ${err}') }
	}
}

fn test_window_new() ! {
	mut tmux := new()!
	tmux.start()!

	// Create session first
	mut session := tmux.session_create(name: 'main')!

	// Test window creation
	mut window := session.window_new(
		name:  'TestWindow'
		cmd:   'bash'
		reset: true
	)!

	assert window.name == 'testwindow' // name_fix converts to lowercase
	assert session.window_exist(name: 'testwindow')

	tmux.stop()!
}

// tests creating duplicate windows
fn test_window_new0() {
	installer := get_install()!

	mut tmux := Tmux{
		node: node_ssh
	}

	window_args := WindowArgs{
		name: 'TestWindow0'
	}

	// console.print_debug(tmux)
	mut window := tmux.window_new(window_args) or { panic("Can't create new window: ${err}") }
	assert tmux.sessions.keys().contains('main')
	mut window_dup := tmux.window_new(window_args) or { panic("Can't create new window: ${err}") }
	console.print_debug(node_ssh.exec('tmux ls') or { panic('fail:${err}') })
	window.delete() or { panic('Cant delete window') }
	// console.print_debug(tmux)
}
