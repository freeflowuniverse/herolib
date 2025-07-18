module doctree

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console


@[params]
pub struct PlayArgs {
pub mut:
	heroscript string
	heroscript_path string
	plbook     ?PlayBook
	reset      bool
}


pub fn play(args_ PlayArgs) ! {

	mut args := args_
	mut plbook := args.plbook or { playbook.new(text: args.heroscript,path:args.heroscript_path)! }

	mut ds := docusaurus.new()!

	actions_define := plbook.find(filter: 'docusaurus.define')!
	if actions_define.len >1 {
		return error("found multiple docusaurus.play actions, only one is allowed")
	}
	for action in actions_define{
		mut p := action.params		
		path_publish := p.get_default('path_publish',"")!	
		path_build := p.get_default('path_build',"")!
		production := p.get_default_false('production')
		update := p.get_default_false('update')
		ds = docusaurus.new(
			path_publish: path_publish
			path_build: path_build
			production: production
			update: update
		)!
	}

	actions := plbook.find(filter: 'docusaurus.add')!
	for action in actions {
		mut p := action.params		
		name := p.get_default('name',"main")!
		path := p.get_default('path',"")!
		git_url := p.get_default('git_url',"")!
		git_reset:= p.get_default_false('git_reset')
		git_pull:= p.get_default_false('git_pull')

		mut site:=ds.get(url:url,path:path,name:"atest")!


	}	

}