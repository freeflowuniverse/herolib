module runpod

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
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
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&RunPod {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := RunPod{
		name: args.name
	}
	if args.name !in runpod_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('runpod', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return runpod_global[args.name] or {
		println(runpod_global)
		// bug if we get here because should be in globals
		panic('could not get config for runpod with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o RunPod) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('runpod', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('runpod', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('runpod', args.name)!
	if args.name in runpod_global {
		// del runpod_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o RunPod) ! {
	mut o2 := obj_init(o)!
	runpod_global[o.name] = &o2
	runpod_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'runpod.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for runpod
pub fn switch(name string) {
	runpod_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
