module gitea

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	gitea_global  map[string]&GiteaServer
	gitea_default string
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

pub fn get(args_ ArgsGet) !&GiteaServer {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := GiteaServer{}
	if args.name !in gitea_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('gitea', args.name)!
			mut obj2 := heroscript_loads(heroscript)!
			set_in_mem(obj2)!
		}
	}
	return gitea_global[args.name] or {
		println(gitea_global)
		// bug if we get here because should be in globals
		panic('could not get config for gitea with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o GiteaServer) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('gitea', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('gitea', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('gitea', args.name)!
	if args.name in gitea_global {
		// del gitea_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o GiteaServer) ! {
	mut o2 := obj_init(o)!
	gitea_global[o.name] = &o2
	gitea_default = o.name
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

	mut install_actions := plbook.find(filter: 'gitea.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj := heroscript_loads(heroscript)!
			set(obj)!
		}
	}

	mut other_actions := plbook.find(filter: 'gitea.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action gitea.destroy')
				destroy()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action gitea.install')
				install()!
			}
		}
		if other_action.name in ['start', 'stop', 'restart'] {
			mut p := other_action.params
			name := p.get('name')!
			mut gitea_obj := get(name: name)!
			console.print_debug('action object:\n${gitea_obj}')
			if other_action.name == 'start' {
				console.print_debug('install action gitea.${other_action.name}')
				gitea_obj.start()!
			}

			if other_action.name == 'stop' {
				console.print_debug('install action gitea.${other_action.name}')
				gitea_obj.stop()!
			}
			if other_action.name == 'restart' {
				console.print_debug('install action gitea.${other_action.name}')
				gitea_obj.restart()!
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
pub fn (mut self GiteaServer) reload() ! {
	switch(self.name)
	self = obj_init(self)!
}

pub fn (mut self GiteaServer) start() ! {
	switch(self.name)
	if self.running()! {
		return
	}

	console.print_header('gitea start')

	if !installed()! {
		install()!
	}

	configure()!

	start_pre()!

	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!

		console.print_debug('starting gitea with ${zprocess.startuptype}...')

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
	return error('gitea did not install properly.')
}

pub fn (mut self GiteaServer) install_start(args InstallArgs) ! {
	switch(self.name)
	self.install(args)!
	self.start()!
}

pub fn (mut self GiteaServer) stop() ! {
	switch(self.name)
	stop_pre()!
	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!
		sm.stop(zprocess.name)!
	}
	stop_post()!
}

pub fn (mut self GiteaServer) restart() ! {
	switch(self.name)
	self.stop()!
	self.start()!
}

pub fn (mut self GiteaServer) running() !bool {
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

pub fn (mut self GiteaServer) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset || (!installed()!) {
		install()!
	}
}

pub fn (mut self GiteaServer) build() ! {
	switch(self.name)
	build()!
}

pub fn (mut self GiteaServer) destroy() ! {
	switch(self.name)
	self.stop() or {}
	destroy()!
}

// switch instance to be used for gitea
pub fn switch(name string) {
	gitea_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
