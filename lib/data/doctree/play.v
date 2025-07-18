module doctree

import freeflowuniverse.herolib.core.playbook { PlayBook }

@[params]
pub struct PlayArgs {
pub mut:
	heroscript string // if filled in then plbook will be made out of it
	heroscript_path string
	plbook     ?PlayBook
	reset      bool
}


pub fn play(args_ PlayArgs) ! {

	mut args := args_
	mut plbook := args.plbook or { playbook.new(text: args.heroscript,path:args.heroscript_path)! }

	mut doctrees := map[string]&Tree{}

	collection_actions := plbook.find(filter: 'doctree.collection')!
	for action in collection_actions {
		mut p := action.params		
		name := p.get('name')!
		mut doctree := doctrees[name] or { 
			mut newdtr:= doctree.new(name: name)!
			doctrees[name] = newdtr
			newdtr
		}
		path:= p.get_default('path',"")!
		git_url:= p.get_default('git_url',"")!
		git_reset:= p.get_default_false('git_reset')
		git_pull:= p.get_default_false('git_pull')
		doctree.scan(path: path, git_url: git_url, git_reset: git_reset, git_pull: git_pull)!

	}	

	export_actions := plbook.find(filter: 'doctree.export')!
	for action in export_actions {
		mut p := action.params		
		name := p.get('name')!
		destination := p.get('destination')!
		reset:= p.get_default_false('reset')
		exclude_errors:= p.get_default_false('exclude_errors')
		mut doctree := doctrees[name] or { 
			mut newdtr:= doctree.new(name: name)!
			doctrees[name] = newdtr
			newdtr
		}	
		doctree.export(
			destination:    destination
			reset:          reset
			exclude_errors: exclude_errors
		)!
	}
}