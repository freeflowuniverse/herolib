module qdrant

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	qdrant_global  map[string]&QDrantClient
	qdrant_default string
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

pub fn get(args_ ArgsGet) !&QDrantClient {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := QDrantClient{}
	if args.name !in qdrant_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('qdrant', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return qdrant_global[args.name] or {
		println(qdrant_global)
		// bug if we get here because should be in globals
		panic('could not get config for qdrant with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o QDrantClient) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('qdrant', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('qdrant', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('qdrant', args.name)!
	if args.name in qdrant_global {
		// del qdrant_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o QDrantClient) ! {
	mut o2 := obj_init(o)!
	qdrant_global[o.name] = &o2
	qdrant_default = o.name
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

	mut install_actions := plbook.find(filter: 'qdrant.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for qdrant
pub fn switch(name string) {
	qdrant_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
