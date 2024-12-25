module tmux

import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.installers.tmux
import freeflowuniverse.herolib.ui.console

// uses single tmux instance for all tests
__global (
	tmux Tmux
)

fn init() {
	tmux = get_remote('185.69.166.152')!

	// reset tmux for tests
	if tmux.is_running() {
		tmux.stop() or { panic('Cannot stop tmux') }
	}
}

fn testsuite_end() {
	if tmux.is_running() {
		tmux.stop()!
	}
}

fn test_window_new() {
	tmux.start() or { panic("can't start tmux: ${err}") }

	// test window new with only name arg
	window_args := WindowArgs{
		name: 'TestWindow'
	}

	assert !tmux.sessions.keys().contains('main')

	mut window := tmux.window_new(window_args) or { panic("Can't create new window: ${err}") }
	assert tmux.sessions.keys().contains('main')
	window.delete() or { panic('Cant delete window') }
}

// // tests creating duplicate windows
// fn test_window_new0() {

// 	
// 	installer := tmux.get_install(

// 	mut tmux := Tmux {
// 		node: node_ssh
// 	}

// 	window_args := WindowArgs {
// 		name: 'TestWindow0'
// 	}

// 	// console.print_debug(tmux)
// 	mut window := tmux.window_new(window_args) or {
// 		panic("Can't create new window: $err")
// 	}
// 	assert tmux.sessions.keys().contains('main')
// 	mut window_dup := tmux.window_new(window_args) or {
// 		panic("Can't create new window: $err")
// 	}
// 	console.print_debug(node_ssh.exec('tmux ls') or { panic("fail:$err")})
// 	window.delete() or { panic("Cant delete window") }
// 	// console.print_debug(tmux)
// }
