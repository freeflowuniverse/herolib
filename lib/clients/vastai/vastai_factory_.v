module vastai

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	vastai_global  map[string]&VastAI
	vastai_default string
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
		args.name = vastai_default
	}
	if args.name == '' {
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&VastAI {
	mut args := args_get(args_)
	if args.name !in vastai_global {
		if args.name == 'default' {
			if !config_exists(args) {
				if default {
					config_save(args)!
				}
			}
			config_load(args)!
		}
	}
	return vastai_global[args.name] or {
		println(vastai_global)
		panic('could not get config for vastai with name:${args.name}')
	}
}

fn config_exists(args_ ArgsGet) bool {
	mut args := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('vastai', args.name)
}

fn config_load(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('vastai', args.name)!
	play(heroscript: heroscript)!
}

fn config_save(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('vastai', args.name, heroscript_default()!)!
}

fn set(o VastAI) ! {
	mut o2 := obj_init(o)!
	vastai_global[o.name] = &o2
	vastai_default = o.name
}


pub fn play(mut plbook PlayBook) ! {

	mut install_actions := plbook.find(filter: 'vastai.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			cfg_play(p)!
		}
	}
}

// switch instance to be used for vastai
pub fn switch(name string) {
	vastai_default = name
}
