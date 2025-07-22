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

	if plbook.if_once(filter: 'docusaurus.define') or {return error("docusarus.define should be there 0 or 1 time.\n${args}")!} {
		mut action := plbook.action_get(actor: 'docusaurus', name: 'define')!

		mut p := action.params
		path_publish := p.get_default('path_publish', '')!
		path_build := p.get_default('path_build', '')!		// don't do heroscript here because this could already be done before
		ds = new(
			path_publish: path_publish
			path_build:   path_build
			install: plbook.exists(filter: 'docusaurus.reset') || plbook.exists(filter: 'docusaurus.update') 
			reset: plbook.exists(filter: 'docusaurus.reset')
			template_update: plbook.exists(filter: 'docusaurus.reset') || plbook.exists(filter: 'docusaurus.update') 
		)!
	}

	actions := plbook.find(filter: 'docusaurus.generate')!
	for action in actions {
		mut p := action.params

		mut site := ds.get(
			name:         p.get('name') or {return error("can't find name in params for docusaurus.add.\n${args}")!}
			nameshort:    p.get_default('nameshort', name)!
			path:         p.get_default('path', '')!
			git_url:      p.get_default('git_url', '')!
			git_reset:    p.get_default_false('git_reset')
			git_root:     p.get_default('git_root', '')!
			git_pull:     p.get_default_false('git_pull')
		)!

	}

}
