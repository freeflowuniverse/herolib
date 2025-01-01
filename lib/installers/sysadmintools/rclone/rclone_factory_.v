module rclone

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	rclone_global  map[string]&RClone
	rclone_default string
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
		model.name = rclone_default
	}
	if model.name == '' {
		model.name = 'default'
	}
	return model
}

pub fn get(args_ ArgsGet) !&RClone {
	mut args := args_get(args_)
	if args.name !in rclone_global {
		if args.name == 'default' {
			if !config_exists(args) {
				if default {
					mut context := base.context() or { panic('bug') }
					context.hero_config_set('rclone', model.name, heroscript_default()!)!
				}
			}
			load(args)!
		}
	}
	return rclone_global[args.name] or {
		println(rclone_global)
		panic('could not get config for ${args.name} with name:${model.name}')
	}
}

// set the model in mem and the config on the filesystem
pub fn set(o RClone) ! {
	mut o2 := obj_init(o)!
	rclone_global[o.name] = &o2
	rclone_default = o.name
}

// check we find the config on the filesystem
pub fn exists(args_ ArgsGet) bool {
	mut model := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('rclone', model.name)
}

// load the config error if it doesn't exist
pub fn load(args_ ArgsGet) ! {
	mut model := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('rclone', model.name)!
	play(heroscript: heroscript)!
}

// save the config to the filesystem in the context
pub fn save(o RClone) ! {
	mut context := base.context()!
	heroscript := encoderhero.encode[RClone](o)!
	context.hero_config_set('rclone', model.name, heroscript)!
}

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?playbook.PlayBook
	reset      bool
}

pub fn play(args_ PlayArgs) ! {
	mut model := args_

	if model.heroscript == '' {
		model.heroscript = heroscript_default()!
	}
	mut plbook := model.plbook or { playbook.new(text: model.heroscript)! }

	mut configure_actions := plbook.find(filter: 'rclone.configure')!
	if configure_actions.len > 0 {
		for config_action in configure_actions {
			mut p := config_action.params
			mycfg := cfg_play(p)!
			console.print_debug('install action rclone.configure\n${mycfg}')
			set(mycfg)!
			save(mycfg)!
		}
	}

	mut other_actions := plbook.find(filter: 'rclone.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action rclone.destroy')
				destroy_()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action rclone.install')
				install_()!
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// load from disk and make sure is properly intialized
pub fn (mut self RClone) reload() ! {
	switch(self.name)
	self = obj_init(self)!
}

@[params]
pub struct InstallArgs {
pub mut:
	reset bool
}

// switch instance to be used for rclone
pub fn switch(name string) {
	rclone_default = name
}

pub fn (mut self RClone) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset {
		destroy_()!
	}
	if !(installed_()!) {
		install_()!
	}
}

pub fn (mut self RClone) destroy() ! {
	switch(self.name)
	destroy_()!
}
