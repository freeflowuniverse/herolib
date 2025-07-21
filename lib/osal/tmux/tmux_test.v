module tmux

import freeflowuniverse.herolib.osal.core as osal
// import freeflowuniverse.herolib.installers.tmux
import os
import freeflowuniverse.herolib.ui.console

const testpath = os.dir(@FILE) + '/testdata'

// make sure tmux isn't running prior to test
fn testsuite_begin() {
	mut tmux := new(sessionid: '1234')!
	if tmux.is_running()! {
		tmux.stop()!
	}
}

// make sure tmux isn't running after test
fn testsuite_end() {
	mut tmux := new(sessionid: '1234')!

	if tmux.is_running()! {
		tmux.stop()!
	}
}

fn test_start() ! {
	mut tmux := new(sessionid: '1234')!
	// test server is running after start()
	tmux.start() or { panic('cannot start tmux: ${err}') }
	mut tmux_ls := osal.execute_silent('tmux ls') or { panic('Cannot execute tmux ls: ${err}') }
	// test started tmux contains windows
	assert tmux_ls.contains('init: 1 windows')
	tmux.stop() or { panic('cannot stop tmux: ${err}') }
}

fn test_stop() ! {
	mut tmux := new(sessionid: '1234')!

	// test server is running after start()
	tmux.start() or { panic('cannot start tmux: ${err}') }
	assert tmux.is_running()!
	tmux.stop() or { panic('cannot stop tmux: ${err}') }
	assert !tmux.is_running()!
}

fn test_windows_get() ! {
	mut tmux := new(sessionid: '1234')!

	// test windows_get when only starting window is running
	tmux.start()!
	mut windows := tmux.windows_get()
	assert windows.len == 1

	// test getting newly created window
	// tmux.window_new(WindowArgs{ name: 'testwindow' })!
	// windows = tmux.windows_get()
	// mut is_name_exist := false
	// mut is_active_window := false

	// unsafe {
	// 	for window in windows {
	// 		if window.name == 'testwindow' {
	// 			is_name_exist = true
	// 			is_active_window = window.active
	// 		}
	// 	}
	// }
	// assert is_name_exist == true
	// assert is_active_window == true
	// tmux.stop()!
}

// TODO: fix test
fn test_scan() ! {
	console.print_debug('-----Testing scan------')
	mut tmux := new(sessionid: '1234')!
	tmux.start()!

	// check bash window is initialized
	mut new_windows := tmux.windows_get()
	// assert new_windows.len == 1
	// assert new_windows[0].name == 'bash'

	// test scan, should return no windows
	// test scan with window in tmux but not in tmux struct
	// mocking a failed command to see if scan identifies
	// tmux.sessions['init'].windows['test'] = &Window{
	// 	session: tmux.sessions['init']
	// 	name:    'test'
	// }
	// new_windows = tmux.windows_get()
	// panic('new windows ${new_windows.keys()}')
	// unsafe {
	// 	assert new_windows.keys().len == 1
	// }
	// new_windows = tmux.scan()!
	// tmux.stop()!
}

// //TODO: fix test
// fn test_scan_add() ! {
// 	console.print_debug("-----Testing scan_add------")

// 	
// 	mut tmux := Tmux { node: node_ssh }
// 	windows := tmux.scan_add("line")!
// }

// remaining tests are run synchronously to avoid conflicts
fn test_tmux_window() {
	res := os.execute('${os.quoted_path(@VEXE)} test ${testpath}/tmux_window_test.v')
	// assert res.exit_code == 1
	// assert res.output.contains('other_test.v does not exist')
}

fn test_tmux_scan() {
	res := os.execute('${os.quoted_path(@VEXE)} test ${testpath}/tmux_window_test.v')
	// assert res.exit_code == 1
	// assert res.output.contains('other_test.v does not exist')
}
