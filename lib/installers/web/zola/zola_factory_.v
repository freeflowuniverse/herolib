module zola

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	zola_global  map[string]&ZolaInstaller
	zola_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

fn args_get(args_ ArgsGet) ArgsGet {
	mut model := args_
	if model.name == '' {
		model.name = zola_default
	}
	if model.name == '' {
		model.name = 'default'
	}
	return model
}

pub fn get(args_ ArgsGet) !&ZolaInstaller {
	mut args := args_get(args_)
	if args.name !in zola_global {
		if args.name == 'default' {
			if !config_exists(args) {
				if default {
					mut context := base.context() or { panic('bug') }
					context.hero_config_set('zola', model.name, heroscript_default()!)!
				}
			}
			load(args)!
		}
	}
	return zola_global[args.name] or {
		println(zola_global)
		panic('could not get config for ${args.name} with name:${model.name}')
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

// switch instance to be used for zola
pub fn switch(name string) {
	zola_default = name
}

pub fn (mut self ZolaInstaller) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset {
		destroy_()!
	}
	if !(installed_()!) {
		install_()!
	}
}

pub fn (mut self ZolaInstaller) build() ! {
	switch(self.name)
	build_()!
}

pub fn (mut self ZolaInstaller) destroy() ! {
	switch(self.name)
	destroy_()!
}
