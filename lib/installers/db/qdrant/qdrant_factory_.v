module qdrant

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	qdrant_global  map[string]&QDrant
	qdrant_default string
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

pub fn get(args_ ArgsGet) !&QDrant {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := QDrant{}
	if args.name !in qdrant_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('qdrant', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return qdrant_global[args.name] or {
		println(qdrant_global)
		// bug if we get here because should be in globals
		panic('could not get config for qdrant with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o QDrant) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('qdrant', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('qdrant', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('qdrant', args.name)!
	if args.name in qdrant_global {
		// del qdrant_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o QDrant) ! {
	mut o2 := obj_init(o)!
	qdrant_global[o.name] = &o2
	qdrant_default = o.name
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

	mut install_actions := plbook.find(filter: 'qdrant.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}

	mut other_actions := plbook.find(filter: 'qdrant.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action qdrant.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action qdrant.install')
				install()!
			}
		}
		if other_action.name in ['start', 'stop', 'restart'] {
			mut p := other_action.params
			name := p.get('name')!
			mut qdrant_obj := get(name: name)!
			console.print_debug('action object:\n${qdrant_obj}')
			if other_action.name == 'start' {
				console.print_debug('install action qdrant.${other_action.name}')
				qdrant_obj.start()!
			}

			if other_action.name == 'stop' {
				console.print_debug('install action qdrant.${other_action.name}')
				qdrant_obj.stop()!
			}
			if other_action.name == 'restart' {
				console.print_debug('install action qdrant.${other_action.name}')
				qdrant_obj.restart()!
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
pub fn (mut self QDrant) reload() ! {
	switch(self.name)
	self = obj_init(self)!
}

pub fn (mut self QDrant) start() ! {
	switch(self.name)
	if self.running()! {
		return
	}

	console.print_header('qdrant start')

	if !installed()! {
		install()!
	}

	configure()!

	start_pre()!

	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!

		console.print_debug('starting qdrant with ${zprocess.startuptype}...')

		sm.new(zprocess)!

		sm.start(zprocess.name)!
	}

	start_post()!

	for _ in 0 .. 50 {
		if self.running()! {
			return
		}
		time.sleep(100 * time.millisecond)
	}
	return error('qdrant did not install properly.')
}

pub fn (mut self QDrant) install_start(args InstallArgs) ! {
	switch(self.name)
	self.install(args)!
	self.start()!
}

pub fn (mut self QDrant) stop() ! {
	switch(self.name)
	stop_pre()!
	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!
		sm.stop(zprocess.name)!
	}
	stop_post()!
}

pub fn (mut self QDrant) restart() ! {
	switch(self.name)
	self.stop()!
	self.start()!
}

pub fn (mut self QDrant) running() !bool {
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

pub fn (mut self QDrant) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self QDrant) build() ! {
	switch(self.name)
	build()!
}

pub fn (mut self QDrant) destroy() ! {
	switch(self.name)
	self.stop() or {}
	destroy()!
}

// switch instance to be used for qdrant
pub fn switch(name string) {
	qdrant_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
