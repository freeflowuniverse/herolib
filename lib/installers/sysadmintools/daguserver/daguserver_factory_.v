module daguserver

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	daguserver_global  map[string]&DaguInstaller
	daguserver_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

fn args_get(args_ ArgsGet) ArgsGet {
	mut args := args_
	if args.name == '' {
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&DaguInstaller {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := DaguInstaller{}
	if args.name !in daguserver_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('daguserver', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return daguserver_global[args.name] or {
		// bug if we get here because should be in globals
		panic('could not get config for daguserver with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o DaguInstaller) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('daguserver', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('daguserver', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('daguserver', args.name)!
	if args.name in daguserver_global {
		// del daguserver_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o DaguInstaller) ! {
	mut o2 := obj_init(o)!
	daguserver_global[o.name] = &o2
	daguserver_default = o.name
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

	mut install_actions := plbook.find(filter: 'daguserver.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}

	mut other_actions := plbook.find(filter: 'daguserver.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action daguserver.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action daguserver.install')
				install()!
			}
		}
		if other_action.name in ['start', 'stop', 'restart'] {
			mut p := other_action.params
			name := p.get('name')!
			mut daguserver_obj := get(name: name)!
			console.print_debug('action object:\n${daguserver_obj}')
			if other_action.name == 'start' {
				console.print_debug('install action daguserver.${other_action.name}')
				daguserver_obj.start()!
			}

			if other_action.name == 'stop' {
				console.print_debug('install action daguserver.${other_action.name}')
				daguserver_obj.stop()!
			}
			if other_action.name == 'restart' {
				console.print_debug('install action daguserver.${other_action.name}')
				daguserver_obj.restart()!
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

// load from disk and make sure is properly intialized
pub fn (mut self DaguInstaller) reload() ! {
	switch(self.name)
	self = obj_init(self)!
}

pub fn (mut self DaguInstaller) start() ! {
	switch(self.name)
	if self.running()! {
		return
	}

	console.print_header('daguserver start')

	if !installed()! {
		install()!
	}

	configure()!

	start_pre()!

	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!

		console.print_debug('starting daguserver with ${zprocess.startuptype}...')

		sm.new(zprocess)!

		sm.start(zprocess.name)!
	}

	start_post()!

	for _ in 0 .. 50 {
		if self.running()! {
			console.print_header('daguserver started')
			return
		}
		time.sleep(100 * time.millisecond)
	}
	return error('daguserver did not install properly.')
}

pub fn (mut self DaguInstaller) install_start(args InstallArgs) ! {
	switch(self.name)
	self.install(args)!
	self.start()!
}

pub fn (mut self DaguInstaller) stop() ! {
	switch(self.name)
	stop_pre()!
	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!
		sm.stop(zprocess.name)!
	}
	stop_post()!
}

pub fn (mut self DaguInstaller) restart() ! {
	switch(self.name)
	self.stop()!
	self.start()!
}

pub fn (mut self DaguInstaller) running() !bool {
	switch(self.name)

	// walk over the generic processes, if not running return
	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!
		r := sm.running(zprocess.name)!
		if r == false {
			return false
		}
	}
	return running()!
}

@[params]
pub struct InstallArgs {
pub mut:
	reset bool
}

pub fn (mut self DaguInstaller) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self DaguInstaller) destroy() ! {
	switch(self.name)
	self.stop() or {}
	destroy()!
}

// switch instance to be used for daguserver
pub fn switch(name string) {
	daguserver_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
