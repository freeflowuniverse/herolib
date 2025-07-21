module doctree

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

	mut doctrees := map[string]&Tree{}

	collection_actions := plbook.find(filter: 'doctree.scan')!
	for action in collection_actions {
		mut p := action.params
		name := p.get_default('name', 'main')!
		mut doctree := doctrees[name] or {
			mut newdtr := new(name: name)!
			doctrees[name] = newdtr
			newdtr
		}
		path := p.get_default('path', '')!
		git_url := p.get_default('git_url', '')!
		git_reset := p.get_default_false('git_reset')
		git_pull := p.get_default_false('git_pull')
		doctree.scan(path: path, git_url: git_url, git_reset: git_reset, git_pull: git_pull)!

		tree_set(doctree)
	}

	export_actions := plbook.find(filter: 'doctree.export')!
	if export_actions.len == 0 {
		name0 := 'main'
		mut doctree0 := doctrees[name0] or { panic("can't find doctree with name ${name0}") }
		doctree0.export()!
	}
	if export_actions.len > 0 {
		if collection_actions.len == 0 {
			println(plbook)
			return error('No collections configured, use !!doctree.collection..., otherwise cannot export')
		}
	}

	for action in export_actions {
		mut p := action.params
		name := p.get_default('name', 'main')!
		destination := p.get('destination')!
		reset := p.get_default_false('reset')
		exclude_errors := p.get_default_true('exclude_errors')
		mut doctree := doctrees[name] or { return error("can't find doctree with name ${name}") }
		doctree.export(
			destination:    destination
			reset:          reset
			exclude_errors: exclude_errors
		)!
	}

	// println(tree_list())	
	// println(tree_get("main")!)
	// panic("sd")
}
