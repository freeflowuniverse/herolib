module mailclient

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	mailclient_global  map[string]&MailClient
	mailclient_default string
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
		args.name = mailclient_default
	}
	if args.name == '' {
		args.name = 'default'
	}
	return args
}

pub fn get(args_ ArgsGet) !&MailClient {
	mut args := args_get(args_)
	if args.name !in mailclient_global {
		if !config_exists(args) {
			config_save(args)!
		}
		config_load(args)!
	}
	return mailclient_global[args.name] or {
		println(mailclient_global)
		// bug if we get here because should be in globals
		panic('could not get config for mailclient with name, is bug:${args.name}')
	}
}

pub fn config_exists(args_ ArgsGet) bool {
	mut args := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('mailclient', args.name)
}

pub fn config_load(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('mailclient', args.name)!
	play(heroscript: heroscript)!
}

pub fn config_save(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('mailclient', args.name, heroscript_default(instance: args.name)!)!
}

pub fn config_delete(args_ ArgsGet) ! {
	mut args := args_get(args_)
	mut context := base.context()!
	context.hero_config_delete('mailclient', args.name)!
}

fn set(o MailClient) ! {
	mut o2 := obj_init(o)!
	mailclient_global[o.name] = &o2
	mailclient_default = o.name
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

	mut install_actions := plbook.find(filter: 'mailclient.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			cfg_play(p)!
		}
	}
}

// switch instance to be used for mailclient
pub fn switch(name string) {
	mailclient_default = name
}

// helpers

@[params]
pub struct DefaultConfigArgs {
	instance string = 'default'
}
