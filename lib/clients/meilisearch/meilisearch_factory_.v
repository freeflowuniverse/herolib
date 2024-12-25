module meilisearch

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

__global (
	meilisearch_global  map[string]&MeilisearchClient
	meilisearch_default string
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
		model.name = meilisearch_default
	}
	if model.name == '' {
		model.name = 'default'
	}
	return model
}

pub fn get(args_ ArgsGet) !&MeilisearchClient {
	mut model := args_get(args_)
	if model.name !in meilisearch_global {
		if model.name == 'default' {
			if !config_exists(model) {
				if default {
					config_save(model)!
				}
			}
			config_load(model)!
		}
	}
	return meilisearch_global[model.name] or {
		println(meilisearch_global)
		panic('could not get config for meilisearch with name:${model.name}')
	}
}

fn config_exists(args_ ArgsGet) bool {
	mut model := args_get(args_)
	mut context := base.context() or { panic('bug') }
	return context.hero_config_exists('meilisearch', model.name)
}

fn config_load(args_ ArgsGet) ! {
	mut model := args_get(args_)
	mut context := base.context()!
	mut heroscript := context.hero_config_get('meilisearch', model.name)!
	play(heroscript: heroscript)!
}

fn config_save(args_ ArgsGet) ! {
	mut model := args_get(args_)
	mut context := base.context()!
	context.hero_config_set('meilisearch', model.name, heroscript_default()!)!
}

fn set(o MeilisearchClient) ! {
	mut o2 := obj_init(o)!
	meilisearch_global[o.name] = &o2
	meilisearch_default = o.name
}

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	plbook     ?playbook.PlayBook
	reset      bool
}

pub fn play(args_ PlayArgs) ! {
	mut model := args_

	if model.heroscript == '' {
		model.heroscript = heroscript_default()!
	}
	mut plbook := model.plbook or { playbook.new(text: model.heroscript)! }

	mut install_actions := plbook.find(filter: 'meilisearch.configure')!
	if install_actions.len > 0 {
		for install_action in install_actions {
			mut p := install_action.params
			mycfg := cfg_play(p)!
			console.print_debug('install action meilisearch.configure\n${mycfg}')
			set(mycfg)!
		}
	}
}

// switch instance to be used for meilisearch
pub fn switch(name string) {
	meilisearch_default = name
}
