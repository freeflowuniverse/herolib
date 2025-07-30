module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.web.site

pub fn play(mut plbook PlayBook) ! {
	// 1. Process generic site configuration first.
	// This populates the global `site.websites` map.
	site.play(mut plbook)!

	// 2. Process docusaurus factory definition.
	if plbook.exists_once(filter: 'docusaurus.define') {
		mut action := plbook.get(filter: 'docusaurus.define')!
		mut p := action.params
		new(
			name: p.get_default('name', 'default')!
			path_build: p.get_default('path_build', '')!
			path_publish: p.get_default('path_publish', '')!
			reset: p.get_default_false('reset')
			template_update: p.get_default_false('template_update')
			install: p.get_default_false('install')
		)!
	}

	// 3. Process `docusaurus.add` actions to create sites.
	for action in plbook.find(filter: 'docusaurus.add')! {
		mut p := action.params
		site_name := p.get('site') or { return error('In docusaurus.add, param "site" is required.') }
		path := p.get('path') or { return error('In docusaurus.add, param "path" to the site source code is required.') }
		
		mut factory := default()!

		// Get the configured site from the site module
		mut generic_site := site.get(name: site_name)!

		// Add the site to the docusaurus factory
		factory.add(
			site: generic_site
			path: path
		)!
	}

	// 4. Process actions like 'dev', 'build', etc.
	for action in plbook.find(filter: 'docusaurus.dev')! {
		mut p := action.params
		site_name := p.get('site')!
		mut factory := default()!
		mut dsite := factory.site_get(site_name)!
		dsite.dev(
			host: p.get_default('host', 'localhost')!
			port: p.get_int_default('port', 3000)!
		)!
	}

	for action in plbook.find(filter: 'docusaurus.build')! {
		mut p := action.params
		site_name := p.get('site')!
		mut factory := default()!
		mut dsite := factory.site_get(site_name)!
		dsite.build()!
	}
}