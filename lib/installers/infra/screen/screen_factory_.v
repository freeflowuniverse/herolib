module screen

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit

__global (
	screen_global  map[string]&Screen
	screen_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

pub fn get(args_ ArgsGet) !&Screen {
	return &Screen{}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

fn startupmanager_get(cat zinit.StartupManagerType) !startupmanager.StartupManager {
	// unknown
	// screen
	// zinit
	// tmux
	// systemd
	match cat {
		.zinit {
			console.print_debug('startupmanager: zinit')
			return startupmanager.get(cat: .zinit)!
		}
		.systemd {
			console.print_debug('startupmanager: systemd')
			return startupmanager.get(cat: .systemd)!
		}
		else {
			console.print_debug('startupmanager: auto')
			return startupmanager.get()!
		}
	}
}

@[params]
pub struct InstallArgs {
pub mut:
	reset bool
}

pub fn (mut self Screen) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self Screen) destroy() ! {
	switch(self.name)
	destroy()!
}

// switch instance to be used for screen
pub fn switch(name string) {
	screen_default = name
}
