module docusaurus

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console

@[params]
pub struct PlayArgs {
pub mut:
	heroscript      string
	heroscript_path string
	plbook          ?PlayBook
	reset           bool
}

pub fn play(args_ PlayArgs) ! {
	mut args := args_
	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}

	mut ds := new()!

	if plbook.exists_once(filter: 'docusaurus.define') {
		mut action := plbook.action_get(actor: 'docusaurus', name: 'define')!

		mut p := action.params
		path_publish := p.get_default('path_publish', '')!
		path_build := p.get_default('path_build', '')!
		production := p.get_default_false('production')
		update := p.get_default_false('update')
		// don't do heroscript here because this could already be done before
		ds = new(
			path_publish: path_publish
			path_build:   path_build
			production:   production
			update:       update
		)!
	}

	actions := plbook.find(filter: 'docusaurus.add')!
	for action in actions {
		mut p := action.params
		name := p.get_default('name', 'main')!
		path := p.get_default('path', '')!
		git_url := p.get_default('git_url', '')!
		git_reset := p.get_default_false('git_reset')
		git_pull := p.get_default_false('git_pull')

		mut site := ds.get(
			name:          name
			nameshort:     p.get_default('nameshort', name)!
			path:          path
			git_url:       git_url
			git_reset:     git_reset
			git_root:      p.get_default('git_root', '')!
			git_pull:      git_pull
			path_publish:  p.get_default('path_publish', '')!
			production:    p.get_default_false('production')
			// watch_changes: p.get_default_true('watch_changes')
			update:        p.get_default_false('update')
			open:          p.get_default_false('open')
			init:          p.get_default_false('init')
		)!

		if plbook.exists_once(filter: 'docusaurus.dev') {
			site.dev()!
		}
	}
}
