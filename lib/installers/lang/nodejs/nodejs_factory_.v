module nodejs

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import json
import freeflowuniverse.herolib.osal.startupmanager

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string = 'default'
}

pub fn new(args ArgsGet) !&NodeJS {
	return &NodeJS{}
}

pub fn get(args ArgsGet) !&NodeJS {
	return new(args)!
}

pub fn play(mut plbook PlayBook) ! {
	if !plbook.exists(filter: 'nodejs.') {
		return
	}
	mut install_actions := plbook.find(filter: 'nodejs.configure')!
	if install_actions.len > 0 {
		return error("can't configure nodejs, because no configuration allowed for this installer.")
	}
	mut other_actions := plbook.find(filter: 'nodejs.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action nodejs.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action nodejs.install')
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

pub fn (mut self NodeJS) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self NodeJS) destroy() ! {
	switch(self.name)
	destroy()!
}

// switch instance to be used for nodejs
pub fn switch(name string) {
}
