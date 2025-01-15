module tfgrid3deployer

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook

__global (
	tfgrid3deployer_global  map[string]&TFGridDeployer
	tfgrid3deployer_default string
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
		args.name = tfgrid3deployer_default
	}
	if args.name == '' {
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&TFGridDeployer {
	mut args := args_get(args_)
	if args.name !in tfgrid3deployer_global {
		if args.name == 'default' {
			if !config_exists(args) {
				if default {
					config_save(args)!
				}
			}
			config_load(args)!
		}
	}
	return tfgrid3deployer_global[args.name] or {
		println(tfgrid3deployer_global)
		panic('could not get config for tfgrid3deployer with name:${args.name}')
	}
}

fn config_exists(args_ ArgsGet) bool {
	mut args := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('tfgrid3deployer', args.name)
}

fn config_load(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('tfgrid3deployer', args.name)!
	play(heroscript: heroscript)!
}

fn config_save(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('tfgrid3deployer', args.name, heroscript_default()!)!
}

fn set(o TFGridDeployer) ! {
	mut o2 := obj_init(o)!
	tfgrid3deployer_global[o.name] = &o2
	tfgrid3deployer_default = o.name
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

	if args.heroscript == '' {
		args.heroscript = heroscript_default()!
	}
	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

	mut install_actions := plbook.find(filter: 'tfgrid3deployer.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			cfg_play(p)!
		}
	}
}

// switch instance to be used for tfgrid3deployer
pub fn switch(name string) {
	tfgrid3deployer_default = name
}
