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
	println('Before the args get')
	mut args := args_get(args_)
	println('Before the bigger if')
	if args.name !in wireguard_global {
		println('Before the if connd')
		if args.name == 'wireguard' {
			println('Before saving')
			if !config_exists(args) {
				if default {
					println('When saving')
					config_save(args)!
				}
			}
			println('When loading')
			config_load(args)!
		}
		println('After all')
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

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?playbook.PlayBook
	reset      bool
}

pub fn play(args_ PlayArgs) ! {
	mut args := args_

	if args.heroscript == '' {
		args.heroscript = heroscript_default()!
	}
	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

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
