module deployer

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.installers.threefold.griddriver

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
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&TFGridDeployer {
	mut installer := griddriver.get()!
	installer.install()!

	mut context := base.context()!
	mut args := args_get(args_)
	mut obj := TFGridDeployer{}
	if args.name !in tfgrid3deployer_global {
		if !exists(args)! {
			set(obj)!
		} else {
			heroscript := context.hero_config_get('deployer', args.name)!
			mut obj_ := heroscript_loads(heroscript)!
			set_in_mem(obj_)!
		}
	}
	return tfgrid3deployer_global[args.name] or {
		println(tfgrid3deployer_global)
		// bug if we get here because should be in globals
		panic('could not get config for deployer with name, is bug:${args.name}')
	}
}

// register the config for the future
pub fn set(o TFGridDeployer) ! {
	set_in_mem(o)!
	mut context := base.context()!
	heroscript := heroscript_dumps(o)!
	context.hero_config_set('deployer', o.name, heroscript)!
}

// does the config exists?
pub fn exists(args_ ArgsGet) !bool {
	mut context := base.context()!
	mut args := args_get(args_)
	return context.hero_config_exists('deployer', args.name)
}

pub fn delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('deployer', args.name)!
	if args.name in tfgrid3deployer_global {
		// del tfgrid3deployer_global[args.name]
	}
}

// only sets in mem, does not set as config
fn set_in_mem(o TFGridDeployer) ! {
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

pub fn play(mut plbook PlayBook) ! {
	mut args := args_

	mut plbook := args.plbook or { playbook.new(text: args.heroscript)! }

	mut install_actions := plbook.find(filter: 'deployer.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			heroscript := install_action.heroscript()
			mut obj2 := heroscript_loads(heroscript)!
			set(obj2)!
		}
	}
}

// switch instance to be used for deployer
pub fn switch(name string) {
	tfgrid3deployer_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
