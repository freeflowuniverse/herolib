module rclone

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook

__global (
	rclone_global  map[string]&RCloneClient
	rclone_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string = 'default'
}

fn args_get(args_ ArgsGet) ArgsGet {
	mut args := args_
	if args.name == '' {
		args.name = rclone_default
	}
	if args.name == '' {
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&RCloneClient {
	mut args := args_get(args_)
	if args.name !in rclone_global {
		if !config_exists() {
			if default {
				config_save()!
			}
		}
		config_load()!
	}
	return rclone_global[args.name] or {
		println(rclone_global)
		panic('bug in get from factory: ')
	}
}

fn config_exists(args_ ArgsGet) bool {
	mut args := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('rclone', args.name)
}

fn config_load(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('rclone', args.name)!
	play(heroscript: heroscript)!
}

fn config_save(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('rclone', args.name, heroscript_default()!)!
}

fn set(o RCloneClient) ! {
	mut o2 := obj_init(o)!
	rclone_global['default'] = &o2
}

@[params]
pub struct PlayArgs {
pub mut:
	name       string = 'default'
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?playbook.PlayBook
	reset      bool

	start     bool
	stop      bool
	restart   bool
	delete    bool
	configure bool // make sure there is at least one installed
}

pub fn play(args_ PlayArgs) ! {
	mut args := args_

	if args.heroscript == '' {
		args.heroscript = heroscript_default()!
	}
	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

	mut install_actions := plbook.find(filter: 'rclone.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			cfg_play(p)!
		}
	}
}

// switch instance to be used for rclone
pub fn switch(name string) {
	rclone_default = name
}
