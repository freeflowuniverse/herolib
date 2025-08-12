module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook, Action }
import freeflowuniverse.herolib.web.site

pub fn play(mut plbook PlayBook) ! {
	if !plbook.exists(filter: 'docusaurus.') {
		return
	}

	// 1. Process generic site configuration first.
	// This populates the global `site.websites` map.
	site.play(mut plbook)!

	mut action_define := plbook.ensure_once(filter: 'docusaurus.define')!

	// 3. Process `docusaurus.add` actions to create sites.
	mut param_define := action_define.params

	mut f := factory_set(
		path_build:      param_define.get_default('path_build', '')!
		path_publish:    param_define.get_default('path_publish', '')!
		reset:           param_define.get_default_false('reset')
		template_update: param_define.get_default_false('template_update')
		install:        param_define.get_default_false('install')
	)!

	site_name := param_define.get('name') or {
		return error('In docusaurus.add, param "name" is required.')
	}

	dsite_define(site_name)!
	action_define.done = true
	mut dsite := dsite_get(site_name)!

	//imports
	mut actions_import := plbook.find(filter: 'docusaurus.import')!
	for mut action in actions_import {
		mut p := action.params
		dsite.importparams << ImportParams{
			path:         p.get_default('path', '')!
			git_url:      p.get_default('git_url', '')!
			git_reset:    p.get_default_false('git_reset')
			git_pull:     p.get_default_false('git_pull')
			dest: p.get_default('dest', '')!
		}
		action.done = true
	}	

	mut actions_dev := plbook.find(filter: 'docusaurus.dev')!
	if actions_dev.len > 1 {
		return error('Multiple "docusaurus.dev" actions found. Only one is allowed.')
	}
	for mut action in actions_dev {
		mut p := action.params
		dsite.dev(
			host:          p.get_default('host', 'localhost')!
			port:          p.get_int_default('port', 3000)!
			open:          p.get_default_false('open')
		)!
		action.done = true
	}

	mut actions_build := plbook.find(filter: 'docusaurus.build')!
	if actions_build.len > 1 {
		return error('Multiple "docusaurus.build" actions found. Only one is allowed.')
	}
	for mut action in actions_build {
		mut p := action.params
		dsite.build()!
		action.done = true
	}

	plbook.ensure_processed(filter: 'docusaurus.')!
}
