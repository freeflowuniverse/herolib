module mycelium_installer

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	mycelium_installer_global  map[string]&MyceliumInstaller
	mycelium_installer_default string
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

pub fn get(args_ ArgsGet) !&MyceliumInstaller {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := MyceliumInstaller{}
	if args.name !in mycelium_installer_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('mycelium_installer', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return mycelium_installer_global[args.name] or {
		println(mycelium_installer_global)
		// bug if we get here because should be in globals
		panic('could not get config for mycelium_installer with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o MyceliumInstaller) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('mycelium_installer', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('mycelium_installer', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('mycelium_installer', args.name)!
	if args.name in mycelium_installer_global {
		// del mycelium_installer_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o MyceliumInstaller) ! {
	mut o2 := obj_init(o)!
	mycelium_installer_global[o.name] = &o2
	mycelium_installer_default = o.name
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

	mut install_actions := plbook.find(filter: 'mycelium_installer.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}

	mut other_actions := plbook.find(filter: 'mycelium_installer.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action mycelium_installer.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action mycelium_installer.install')
				install()!
			}
		}
		if other_action.name in ['start', 'stop', 'restart'] {
			mut p := other_action.params
			name := p.get('name')!
			mut mycelium_installer_obj := get(name: name)!
			console.print_debug('action object:\n${mycelium_installer_obj}')
			if other_action.name == 'start' {
				console.print_debug('install action mycelium_installer.${other_action.name}')
				mycelium_installer_obj.start()!
			}

			if other_action.name == 'stop' {
				console.print_debug('install action mycelium_installer.${other_action.name}')
				mycelium_installer_obj.stop()!
			}
			if other_action.name == 'restart' {
				console.print_debug('install action mycelium_installer.${other_action.name}')
				mycelium_installer_obj.restart()!
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
pub fn (mut self MyceliumInstaller) reload() ! {
	switch(self.name)
	self = obj_init(self)!
}

pub fn (mut self MyceliumInstaller) start() ! {
	switch(self.name)
	if self.running()! {
		return
	}

	console.print_header('mycelium_installer start')

	if !installed()! {
		install()!
	}

	configure()!

	start_pre()!

	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!

		console.print_debug('starting mycelium_installer with ${zprocess.startuptype}...')

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
	return error('mycelium_installer did not install properly.')
}

pub fn (mut self MyceliumInstaller) install_start(args InstallArgs) ! {
	switch(self.name)
	self.install(args)!
	self.start()!
}

pub fn (mut self MyceliumInstaller) stop() ! {
	switch(self.name)
	stop_pre()!
	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!
		sm.stop(zprocess.name)!
	}
	stop_post()!
}

pub fn (mut self MyceliumInstaller) restart() ! {
	switch(self.name)
	self.stop()!
	self.start()!
}

pub fn (mut self MyceliumInstaller) running() !bool {
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

pub fn (mut self MyceliumInstaller) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self MyceliumInstaller) build() ! {
	switch(self.name)
	build()!
}

pub fn (mut self MyceliumInstaller) destroy() ! {
	switch(self.name)
	self.stop() or {}
	destroy()!
}

// switch instance to be used for mycelium_installer
pub fn switch(name string) {
	mycelium_installer_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
