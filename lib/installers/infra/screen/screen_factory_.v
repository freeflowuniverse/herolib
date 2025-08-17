module screen

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import json
import freeflowuniverse.herolib.osal.startupmanager

__global (
	screen_global  map[string]&Screen
	screen_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string = 'default'
}

pub fn new(args ArgsGet) !&Screen {
	return &Screen{}
}

pub fn get(args ArgsGet) !&Screen {
	return new(args)!
}

pub fn play(mut plbook PlayBook) ! {
	if !plbook.exists(filter: 'screen.') {
		return
	}
	mut install_actions := plbook.find(filter: 'screen.configure')!
	if install_actions.len > 0 {
		return error("can't configure screen, because no configuration allowed for this installer.")
	}
	mut other_actions := plbook.find(filter: 'screen.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action screen.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action screen.install')
				install()!
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

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
