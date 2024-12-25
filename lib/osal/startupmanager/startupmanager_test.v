module startupmanager

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.screen
import freeflowuniverse.herolib.osal.systemd

const process_name = 'testprocess'

pub fn testsuite_begin() ! {
	mut sm := get()!
	if sm.exists(process_name)! {
		sm.stop(process_name)!
	}
}

pub fn testsuite_end() ! {
	mut sm := get()!
	if sm.exists(process_name)! {
		sm.stop(process_name)!
	}
}

// remove from the startup manager
pub fn test_status() ! {
	mut sm := get()!
	if sm.exists(process_name)! {
		sm.stop(process_name)!
		sm.start(process_name)!
		status := sm.status(process_name)!
		assert status == .inactive
	} else {
		sm.new(name: process_name, cmd: 'sleep 100')!
		sm.start(process_name)!
		status := sm.status(process_name)!
		assert status == .active
	}
	sm.stop(process_name)!
}
