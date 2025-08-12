module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.web.site

pub fn play(mut plbook PlayBook) ! {

	if !plbook.exists(filter: 'docusaurus.') {
		return
	}

	// 1. Process generic site configuration first.
	// This populates the global `site.websites` map.
	site.play(mut plbook)!

	mut a := plbook.ensure_once(filter: 'docusaurus.define')!

	// check if docusaurus.define exists, if not, we create a default factory
	mut p2 := a.params
	mut f := factory_set(
		path_build:      p2.get_default('path_build', '')!
		path_publish:    p2.get_default('path_publish', '')!
		reset:           p2.get_default_false('reset')
		template_update: p2.get_default_false('template_update')
		install:         p2.get_default_false('install')
	)!
	a.done = true

	// 3. Process `docusaurus.add` actions to create sites.
	for mut action in plbook.find(filter: 'docusaurus.add')! {
		mut p := action.params
		site_name := p.get('sitename') or {
			return error('In docusaurus.add, param "sitename" is required.')
		}

		dsite_add(
			sitename:     site_name
			path:         p.get_default('path', '')!
			git_url:      p.get_default('git_url','')!
			git_reset:    p.get_default_false('git_reset')
			git_root:     p.get_default('git_root','')!
			git_pull:     p.get_default_false('git_pull')
			path_publish: p.get_default('path_publish', f.path_publish.path)!
		)!
		action.done = true
	}

	mut actions_dev := plbook.find(filter: 'docusaurus.dev')!
	if actions_dev.len > 1 {
		return error('Multiple "docusaurus.dev" actions found. Only one is allowed.')
	}
	for mut action in actions_dev {
		mut p := action.params
		site_name := p.get('site')!
		mut dsite := dsite_get(site_name)!
		dsite.dev(
			host:          p.get_default('host', 'localhost')!
			port:          p.get_int_default('port', 3000)!
			open:          p.get_default_false('open')
			watch_changes: p.get_default_false('watch_changes')
		)!
		action.done = true
	}

	mut actions_build := plbook.find(filter: 'docusaurus.build')!
	if actions_build.len > 1 {
		return error('Multiple "docusaurus.build" actions found. Only one is allowed.')
	}
	for mut action in actions_build {
		mut p := action.params
		site_name := p.get('site')!
		mut dsite := dsite_get(site_name)!
		dsite.build()!
		action.done = true
	}

	plbook.ensure_processed(filter: 'docusaurus.')!
}
