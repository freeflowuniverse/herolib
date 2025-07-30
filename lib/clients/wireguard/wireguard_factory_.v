module wireguard

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console

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
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&WireGuard {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := WireGuard{
		name: args.name
	}
	if args.name !in wireguard_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('wireguard', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return wireguard_global[args.name] or {
		println(wireguard_global)
		// bug if we get here because should be in globals
		panic('could not get config for wireguard with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o WireGuard) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('wireguard', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('wireguard', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('wireguard', args.name)!
	if args.name in wireguard_global {
		// del wireguard_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o WireGuard) ! {
	mut o2 := obj_init(o)!
	wireguard_global[o.name] = &o2
	wireguard_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'wireguard.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for wireguard
pub fn switch(name string) {
	wireguard_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
