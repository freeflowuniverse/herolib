module tailwind

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import freeflowuniverse.herolib.ui.console
import time

__global (
	tailwind_global  map[string]&Tailwind
	tailwind_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string = 'default'
}

pub fn get(args_ ArgsGet) !&Tailwind {
	return &Tailwind{}
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

pub fn (mut self Tailwind) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed_()!) {
		install_()!
	}
}

pub fn (mut self Tailwind) destroy() ! {
	switch(self.name)

	destroy_()!
}

// switch instance to be used for tailwind
pub fn switch(name string) {
	tailwind_default = name
}
