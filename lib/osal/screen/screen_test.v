module screen

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal
import os
import time

pub fn testsuite_begin() ! {
	mut screen_factory := new(reset: true)!
}

pub fn test_screen_status() ! {
	mut screen_factory := new()!
	mut screen := screen_factory.add(name: 'testservice', cmd: 'redis-server --port 1234')!
	status := screen.status()!
	assert status == .active
}
