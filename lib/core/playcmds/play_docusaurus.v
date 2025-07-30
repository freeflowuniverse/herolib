module playcmds



import freeflowuniverse.herolib.core.playbook { PlayBook }
// import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.web.docusaurus

fn play(args_ PlayArgs) !PlayBook {
	mut args := args_
	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}

	mut ds := docusaurus.new()!

	mut action0 := plbook.action_get(actor: 'docusaurus', name: 'define')!

	mut p0 := action0.params
	path_publish := p0.get_default('path_publish', '')!
	path_build := p0.get_default('path_build', '')!		// don't do heroscript here because this could already be done before
	ds = docusaurus.new(
		path_publish: path_publish
		path_build:   path_build
		install: plbook.exists(filter: 'docusaurus.reset') || plbook.exists(filter: 'docusaurus.update') 
		reset: plbook.exists(filter: 'docusaurus.reset')
		template_update: plbook.exists(filter: 'docusaurus.reset') || plbook.exists(filter: 'docusaurus.update') 
	)!

	actions := plbook.find(filter: 'docusaurus.generate')!
	for action in actions {
		mut p := action.params

		mut site := ds.add(
			name:         p.get('name') or {return error("can't find name in params for docusaurus.add.\n${args}")}
			nameshort:    p.get_default('nameshort', p.get('name')!)!
			path:         p.get_default('path', '')!
			git_url:      p.get_default('git_url', '')!
			git_reset:    p.get_default_false('git_reset')
			git_root:     p.get_default('git_root', '')!
			git_pull:     p.get_default_false('git_pull')
		)!

	}

	return plbook

}
