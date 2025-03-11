module jina

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	jina_global  map[string]&Jina
	jina_default string
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

pub fn get(args_ ArgsGet) !&Jina {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := Jina{}
	if args.name !in jina_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('jina', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return jina_global[args.name] or {
		println(jina_global)
		// bug if we get here because should be in globals
		panic('could not get config for jina with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o Jina) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('jina', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('jina', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('jina', args.name)!
	if args.name in jina_global {
		// del jina_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o Jina) ! {
	mut o2 := obj_init(o)!
	jina_global[o.name] = &o2
	jina_default = o.name
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

	mut install_actions := plbook.find(filter: 'jina.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for jina
pub fn switch(name string) {
	jina_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
