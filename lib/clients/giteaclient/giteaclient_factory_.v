module giteaclient

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console

__global (
	giteaclient_global  map[string]&GiteaClient
	giteaclient_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name  string = "default"
	fromdb bool //will load from filesystem
	create bool //default will not create if not exist
}

pub fn new(args ArgsGet) !&GiteaClient {
	mut obj := GiteaClient{
			name: args.name
		}
	set(obj)!
	return &obj
}

pub fn get(args ArgsGet) !&GiteaClient {
	mut context := base.context()!
	giteaclient_default = args.name
	if args.fromdb || args.name !in giteaclient_global {
		if context.hero_config_exists('giteaclient', args.name) {
			heroscript := context.hero_config_get('giteaclient', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}else{
			if args.create {
				new(args)!				
			}else{
				return error("GiteaClient with name '${args.name}' does not exist")
			}
		}
		return get(name: args.name)! //no longer from db nor create		
	}
	return giteaclient_global[args.name] or {
		return error('could not get config for giteaclient with name:${args.name}')
	}
}

// register the config for the future
pub fn set(o GiteaClient) ! {
	set_in_mem(o)!
	giteaclient_default = o.name
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('giteaclient', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args ArgsGet) !bool {
	mut context := base.context()!
	return context.hero_config_exists('giteaclient', args.name)
}

pub fn delete(args ArgsGet) ! {
	mut context := base.context()!
	giteaclient_global.delete(args.name)
	context.hero_config_delete('giteaclient', args.name)!	
}

@[params]
pub struct ArgsList {
pub mut:
	fromdb bool //will load from filesystem
}

// if fromdb set: load from filesystem, and not from mem, will also reset what is in mem
pub fn list(args ArgsList) ![]&GiteaClient {	
	mut res := []&GiteaClient{}
	mut context := base.context()!
	if args.fromdb {
		// reset what is in mem
		giteaclient_global = map[string]&GiteaClient{}
		giteaclient_default = ''
	}
	if args.fromdb {		
		for name in context.hero_config_list('giteaclient')!{
			mut hscript := context.hero_config_get('giteaclient', name)!
			mut obj := heroscript_loads(hscript)!
			set_in_mem(obj)!
			res << &obj
		}
		return res
	} else {
		// load from memory
		for _, client in giteaclient_global {
			res << client
		}
	}
	return res
}

// only sets in mem, does not set as config
fn set_in_mem(o GiteaClient) ! {
	mut o2 := obj_init(o)!
	giteaclient_global[o.name] = &o2
	giteaclient_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'giteaclient.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for giteaclient
pub fn switch(name string) {
	giteaclient_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
