module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.web.site

pub fn play(mut plbook PlayBook) ! {
	// 1. Process generic site configuration first.
	// This populates the global `site.websites` map.
	site.play(mut plbook)!


	// 3. Process `docusaurus.add` actions to create sites.
	for action in plbook.find(filter: 'docusaurus.add')! {
		mut p := action.params
		site_name := p.get('site') or { return error('In docusaurus.add, param "site" is required.') }
		path := p.get('path') or { return error('In docusaurus.add, param "path" to the site source code is required.') }
		
		mut generic_site := site.get(name: site_name)!

		add(
			site: generic_site
			path_src: path
			path_build: p.get_default('path_build', '')!
			path_publish: p.get_default('path_publish', '')!
			reset: p.get_default_false('reset')
			template_update: p.get_default_false('template_update')
			install: p.get_default_false('install')
		)!
	}

	// 4. Process actions like 'dev', 'build', etc.
	for action in plbook.find(filter: 'docusaurus.dev')! {
		mut p := action.params
		site_name := p.get('site')!
		mut dsite := get(site_name)!
		dsite.dev(
			host: p.get_default('host', 'localhost')!
			port: p.get_int_default('port', 3000)!
			open: p.get_default_false('open')
			watch_changes: p.get_default_false('watch_changes')
		)!
	}

	for action in plbook.find(filter: 'docusaurus.build')! {
		mut p := action.params
		site_name := p.get('site')!
		mut dsite := get(site_name)!
		dsite.build()!
	}
}