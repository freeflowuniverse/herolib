module wireguard

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook

__global (
	wireguard_global  map[string]&WireGuard
	wireguard_default string
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
		args.name = wireguard_default
	}
	if args.name == '' {
		args.name = 'wireguard'
	}
	return args
}

pub fn get(args_ ArgsGet) !&WireGuard {
	mut args := args_get(args_)
	if args.name !in wireguard_global {
		if args.name == 'wireguard' {
			if !config_exists(args) {
				if default {
					println('When saving')
					config_save(args)!
				}
			}
			config_load(args)!
		}
	}
	return wireguard_global[args.name] or {
		println(wireguard_global)
		panic('could not get config for wireguard with name:${args.name}')
	}
}

fn config_exists(args_ ArgsGet) bool {
	mut args := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('wireguard', args.name)
}

fn config_load(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('wireguard', args.name)!
	play(heroscript: heroscript)!
}

fn config_save(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('wireguard', args.name, heroscript_default()!)!
}

fn set(o WireGuard) ! {
	mut o2 := obj_init(o)!
	wireguard_global[o.name] = &o2
	wireguard_default = o.name
}


pub fn play(mut plbook PlayBook) ! {

	mut install_actions := plbook.find(filter: 'wireguard.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			cfg_play(p)!
		}
	}
}

// switch instance to be used for wireguard
pub fn switch(name string) {
	wireguard_default = name
}
