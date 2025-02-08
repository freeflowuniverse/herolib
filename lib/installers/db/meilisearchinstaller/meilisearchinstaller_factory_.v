module meilisearchinstaller

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.sysadmin.startupmanager
import freeflowuniverse.herolib.osal.zinit
import time

__global (
	meilisearchinstaller_global  map[string]&MeilisearchServer
	meilisearchinstaller_default string
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
		model.name = meilisearchinstaller_default
	}
	if model.name == '' {
		model.name = 'default'
	}
	return model
}

pub fn get(args_ ArgsGet) !&MeilisearchServer {
	mut args := args_get(args_)
	if args.name !in meilisearchinstaller_global {
		if args.name == 'default' {
			if !config_exists(args) {
				if default {
					mut context := base.context() or { panic('bug') }
					context.hero_config_set('meilisearchinstaller', model.name, heroscript_default()!)!
				}
			}
			load(args)!
		}
	}
	return meilisearchinstaller_global[args.name] or {
		println(meilisearchinstaller_global)
		panic('could not get config for ${args.name} with name:${model.name}')
	}
}

// set the model in mem and the config on the filesystem
pub fn set(o MeilisearchServer) ! {
	mut o2 := obj_init(o)!
	meilisearchinstaller_global[o.name] = &o2
	meilisearchinstaller_default = o.name
}

// check we find the config on the filesystem
pub fn exists(args_ ArgsGet) bool {
	mut model := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('meilisearchinstaller', model.name)
}

// load the config error if it doesn't exist
pub fn load(args_ ArgsGet) ! {
	mut model := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('meilisearchinstaller', model.name)!
	play(heroscript: heroscript)!
}

// save the config to the filesystem in the context
pub fn save(o MeilisearchServer) ! {
	mut context := base.context()!
	heroscript := encoderhero.encode[MeilisearchServer](o)!
	context.hero_config_set('meilisearchinstaller', model.name, heroscript)!
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

	mut configure_actions := plbook.find(filter: 'meilisearchinstaller.configure')!
	if configure_actions.len > 0 {
		for config_action in configure_actions {
			mut p := config_action.params
			mycfg := cfg_play(p)!
			console.print_debug('install action meilisearchinstaller.configure\n${mycfg}')
			set(mycfg)!
			save(mycfg)!
		}
	}

	mut other_actions := plbook.find(filter: 'meilisearchinstaller.')!
	for other_action in other_actions {
		if other_action.name in ['destroy', 'install', 'build'] {
			mut p := other_action.params
			reset := p.get_default_false('reset')
			if other_action.name == 'destroy' || reset {
				console.print_debug('install action meilisearchinstaller.destroy')
				destroy_()!
			}
			if other_action.name == 'install' {
				console.print_debug('install action meilisearchinstaller.install')
				install_()!
			}
		}
		if other_action.name in ['start', 'stop', 'restart'] {
			mut p := other_action.params
			name := p.get('name')!
			mut meilisearchinstaller_obj := get(name: name)!
			console.print_debug('action object:\n${meilisearchinstaller_obj}')
			if other_action.name == 'start' {
				console.print_debug('install action meilisearchinstaller.${other_action.name}')
				meilisearchinstaller_obj.start()!
			}

			if other_action.name == 'stop' {
				console.print_debug('install action meilisearchinstaller.${other_action.name}')
				meilisearchinstaller_obj.stop()!
			}
			if other_action.name == 'restart' {
				console.print_debug('install action meilisearchinstaller.${other_action.name}')
				meilisearchinstaller_obj.restart()!
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////# LIVE CYCLE MANAGEMENT FOR INSTALLERS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// load from disk and make sure is properly intialized
pub fn (mut self MeilisearchServer) reload() ! {
	switch(self.name)
	self = obj_init(self)!
}

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

pub fn (mut self MeilisearchServer) start() ! {
	switch(self.name)
	if self.running()! {
		return
	}

	console.print_header('meilisearchinstaller start')

	if !installed_()! {
		install_()!
	}

	configure()!

	start_pre()!

	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!

		console.print_debug('starting meilisearchinstaller with ${zprocess.startuptype}...')

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
	return error('meilisearchinstaller did not install properly.')
}

pub fn (mut self MeilisearchServer) install_start(model InstallArgs) ! {
	switch(self.name)
	self.install(model)!
	self.start()!
}

pub fn (mut self MeilisearchServer) stop() ! {
	switch(self.name)
	stop_pre()!
	for zprocess in startupcmd()! {
		mut sm := startupmanager_get(zprocess.startuptype)!
		sm.stop(zprocess.name)!
	}
	stop_post()!
}

pub fn (mut self MeilisearchServer) restart() ! {
	switch(self.name)
	self.stop()!
	self.start()!
}

pub fn (mut self MeilisearchServer) running() !bool {
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

// switch instance to be used for meilisearchinstaller
pub fn switch(name string) {
	meilisearchinstaller_default = name
}

pub fn (mut self MeilisearchServer) install(args InstallArgs) ! {
	switch(self.name)
	if args.reset {
		destroy_()!
	}
	if !(installed_()!) {
		install_()!
	}
}

pub fn (mut self MeilisearchServer) build() ! {
	switch(self.name)
	build_()!
}

pub fn (mut self MeilisearchServer) destroy() ! {
	switch(self.name)
	self.stop() or {}
	destroy_()!
}
