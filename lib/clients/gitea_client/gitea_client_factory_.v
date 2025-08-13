module gitea_client

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console

__global (
	gitea_client_global  map[string]&GiteaClient
	gitea_client_default string
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

pub fn get(args_ ArgsGet) !&GiteaClient {
	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := GiteaClient{
		name: args.name
	}
	if args.name !in gitea_client_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('gitea_client', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return gitea_client_global[args.name] or {
		println(gitea_client_global)
		// bug if we get here because should be in globals
		panic('could not get config for gitea_client with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o GiteaClient) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('gitea_client', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('gitea_client', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('gitea_client', args.name)!
	if args.name in gitea_client_global {
		// del gitea_client_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o GiteaClient) ! {
	mut o2 := obj_init(o)!
	gitea_client_global[o.name] = &o2
	gitea_client_default = o.name
}

pub fn play(mut plbook PlayBook) ! {
	mut install_actions := plbook.find(filter: 'gitea_client.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for gitea_client
pub fn switch(name string) {
	gitea_client_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
