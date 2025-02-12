module rust

import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit

__global (
	rust_global  map[string]&RustInstaller
	rust_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

pub fn get(args_ ArgsGet) !&RustInstaller {
	return &RustInstaller{}
}

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?playbook.PlayBook
	reset      bool
}

pub fn play(args_ PlayArgs) ! {
	mut args := args_

	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

	mut other_actions := plbook.find(filter: 'rust.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action rust.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action rust.install')
				install()!
			}
		}
	}
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

pub fn (mut self RustInstaller) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self RustInstaller) destroy() ! {
	switch(self.name)
	destroy()!
}

// switch instance to be used for rust
pub fn switch(name string) {
	rust_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
