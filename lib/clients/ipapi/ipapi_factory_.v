module ipapi

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console

__global (
	ipapi_global  map[string]&IPApi
	ipapi_default string
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

pub fn get(args_ ArgsGet) !&IPApi {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := IPApi{
		name: args.name
	}
	if args.name !in ipapi_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('ipapi', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return ipapi_global[args.name] or {
		println(ipapi_global)
		// bug if we get here because should be in globals
		panic('could not get config for ipapi with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o IPApi) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('ipapi', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('ipapi', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('ipapi', args.name)!
	if args.name in ipapi_global {
		// del ipapi_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o IPApi) ! {
	mut o2 := obj_init(o)!
	ipapi_global[o.name] = &o2
	ipapi_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'ipapi.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for ipapi
pub fn switch(name string) {
	ipapi_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
