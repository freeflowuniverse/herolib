module bun

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	bun_global  map[string]&Bun
	bun_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

pub fn get(args_ ArgsGet) !&Bun {
	return &Bun{}
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

pub fn (mut self Bun) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self Bun) destroy() ! {
	switch(self.name)
	destroy()!
}

// switch instance to be used for bun
pub fn switch(name string) {
	bun_default = name
}
