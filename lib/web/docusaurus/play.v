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

	// check if docusaurus.define exists, if not, we create a default factory
	mut f := DocSiteFactory{}
	if plbook.exists_once(filter: 'docusaurus.define') {
		mut a := plbook.get(filter: 'docusaurus.define') or {
			panic('docusaurus.define action not found, this should not happen.')
		}
		mut p := a.params
		f = factory_set(
			path_build:      p.get_default('path_build', '')!
			path_publish:    p.get_default('path_publish', '')!
			reset:           p.get_default_false('reset')
			template_update: p.get_default_false('template_update')
			install:         p.get_default_false('install')
		)!
		a.done = true
	} else {
		f = factory_get()!
	}

	// 3. Process `docusaurus.add` actions to create sites.
	for mut action in plbook.find(filter: 'docusaurus.add')! {
		mut p := action.params
		site_name := p.get('sitename') or {
			return error('In docusaurus.add, param "sitename" is required.')
		}

		dsite_add(
			sitename:     site_name
			path:         p.get('path')!
			git_url:      p.get('git_url')!
			git_reset:    p.get_default_false('git_reset')
			git_root:     p.get('git_root')!
			git_pull:     p.get_default_false('git_pull')
			path_publish: p.get_default('path_publish', f.path_publish.path)!
			play:         false // need to make sure we don't play again
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
}
