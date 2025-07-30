module mycelium_rpc

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	mycelium_rpc_global  map[string]&MyceliumRPC
	mycelium_rpc_default string
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

pub fn get(args_ ArgsGet) !&MyceliumRPC {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := MyceliumRPC{
		name: args.name
	}
	if args.name !in mycelium_rpc_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('mycelium_rpc', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return mycelium_rpc_global[args.name] or {
		println(mycelium_rpc_global)
		// bug if we get here because should be in globals
		panic('could not get config for mycelium_rpc with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o MyceliumRPC) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('mycelium_rpc', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('mycelium_rpc', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('mycelium_rpc', args.name)!
	if args.name in mycelium_rpc_global {
		// del mycelium_rpc_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o MyceliumRPC) ! {
	mut o2 := obj_init(o)!
	mycelium_rpc_global[o.name] = &o2
	mycelium_rpc_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'mycelium_rpc.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for mycelium_rpc
pub fn switch(name string) {
	mycelium_rpc_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
