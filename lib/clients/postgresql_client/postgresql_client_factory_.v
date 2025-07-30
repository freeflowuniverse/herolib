module postgresql_client

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core
import freeflowuniverse.herolib.data.encoderhero

__global (
	postgresql_client_global  map[string]&PostgresClient
	postgresql_client_default string
)

/////////FACTORY

@[params]
pub struct ArgsGet {
pub mut:
	name string
}

fn args_get(args_ ArgsGet) ArgsGet {
	mut model := args_
	if model.name == '' {
		model.name = postgresql_client_default
	}
	if model.name == '' {
		model.name = 'default'
	}
	return model
}

pub fn get(args_ ArgsGet) !&PostgresClient {
	mut args := args_get(args_)
	if args.name !in postgresql_client_global {
		if args.name == 'default' {
			if !exists(args)! {
				if default {
					mut context := base.context() or { panic('bug') }
					context.hero_config_set('postgresql_client', args.name, heroscript_default()!)!
				}
			}
			load(args)!
		}
	}
	return postgresql_client_global[args.name] or {
		println(postgresql_client_global)
		panic('could not get config for ${args.name}.')
	}
}

// set the model in mem and the config on the filesystem
pub fn set(o PostgresClient) ! {
	mut o2 := obj_init(o)!
	postgresql_client_global[o.name] = &o2
	postgresql_client_default = o.name
}

// check we find the config on the filesystem
pub fn exists(args_ ArgsGet) !bool {
	mut model := args_get(args_)
	mut context := base.context()!
	return context.hero_config_exists('postgresql_client', model.name)
}

// load the config error if it doesn't exist
pub fn load(args_ ArgsGet) ! {
	mut model := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('postgresql_client', model.name)!
	play(heroscript: heroscript)!
}

// save the config to the filesystem in the context
pub fn save(o PostgresClient) ! {
	mut context := base.context()!
	heroscript := encoderhero.encode[PostgresClient](o)!
	context.hero_config_set('postgresql_client', o.name, heroscript)!
}


pub fn play(mut plbook PlayBook) ! {

	mut configure_actions := plbook.find(filter: 'postgresql_client.configure')!
	if configure_actions.len > 0 {
		for config_action in configure_actions {
			mut p := config_action.params
			mycfg := cfg_play(p)!
			console.print_debug('install action postgresql_client.configure\n${mycfg}')
			set(mycfg)!
			save(mycfg)!
		}
	}
}
