module linux

// import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.core.texttools
// import freeflowuniverse.herolib.screen
import os
import time
// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.core as osal

@[heap]
pub struct LinuxFactory {
pub mut:
	username string
}

@[params]
pub struct LinuxNewArgs {
pub:
	username string
}

// return screen instance
pub fn new(args LinuxNewArgs) !LinuxFactory {
	mut t := LinuxFactory{
		username: args.username
	}
	return t
}
