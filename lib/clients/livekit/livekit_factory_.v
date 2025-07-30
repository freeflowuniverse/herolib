module livekit

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	livekit_global  map[string]&LivekitClient
	livekit_default string
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

pub fn get(args_ ArgsGet) !&LivekitClient {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := LivekitClient{
		name: args.name
	}
	if args.name !in livekit_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('livekit', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return livekit_global[args.name] or {
		println(livekit_global)
		// bug if we get here because should be in globals
		panic('could not get config for livekit with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o LivekitClient) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('livekit', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('livekit', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('livekit', args.name)!
	if args.name in livekit_global {
		// del livekit_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o LivekitClient) ! {
	mut o2 := obj_init(o)!
	livekit_global[o.name] = &o2
	livekit_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'livekit.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for livekit
pub fn switch(name string) {
	livekit_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
