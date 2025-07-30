module mycelium

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	mycelium_global  map[string]&Mycelium
	mycelium_default string
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

pub fn get(args_ ArgsGet) !&Mycelium {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := Mycelium{
		name: args.name
	}
	if args.name !in mycelium_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('mycelium', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return mycelium_global[args.name] or {
		println(mycelium_global)
		// bug if we get here because should be in globals
		panic('could not get config for mycelium with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o Mycelium) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('mycelium', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('mycelium', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('mycelium', args.name)!
	if args.name in mycelium_global {
		// del mycelium_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o Mycelium) ! {
	mut o2 := obj_init(o)!
	mycelium_global[o.name] = &o2
	mycelium_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'mycelium.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for mycelium
pub fn switch(name string) {
	mycelium_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
