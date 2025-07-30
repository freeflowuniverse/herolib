module runpod

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	runpod_global  map[string]&RunPod
	runpod_default string
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
		args.name = runpod_default
	}
	if args.name == '' {
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&RunPod {
	mut args := args_get(args_)
	if args.name !in runpod_global {
		if args.name == 'default' {
			if !config_exists(args) {
				if default {
					config_save(args)!
				}
			}
			config_load(args)!
		}
	}
	return runpod_global[args.name] or {
		println(runpod_global)
		panic('could not get config for runpod with name:${args.name}')
	}
}

fn config_exists(args_ ArgsGet) bool {
	mut args := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('runpod', args.name)
}

fn config_load(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('runpod', args.name)!
	play(heroscript: heroscript)!
}

fn config_save(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('runpod', args.name, heroscript_default()!)!
}

fn set(o RunPod) ! {
	mut o2 := obj_init(o)!
	runpod_global[o.name] = &o2
	runpod_default = o.name
}


pub fn play(mut plbook PlayBook) ! {

	mut install_actions := plbook.find(filter: 'runpod.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			cfg_play(p)!
		}
	}
}

// switch instance to be used for runpod
pub fn switch(name string) {
	runpod_default = name
}
