module gittools

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.develop.gittools

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

	// Initialize GitStructure
	mut gs := gittools.new()!

	// Handle !!git.clone action
	clone_actions := plbook.find(filter: 'git.clone')!
	for action in clone_actions {
		mut p := action.params
		url := p.get('url')!
		coderoot := p.get_default('coderoot', '')!
		sshkey := p.get_default('sshkey', '')!
		light := p.get_default_true('light')
		recursive := p.get_default_false('recursive')

		mut clone_args := gittools.GitCloneArgs{
			url: url
			sshkey: sshkey
			recursive: recursive
		}
		if coderoot.len > 0 {
			gs = gittools.new(coderoot: coderoot, light: light)!
		} else {
			gs.config_!.light = light // Update light setting on existing gs
		}
		gs.clone(clone_args)!
	}

	// Handle !!git.repo_action
	repo_actions := plbook.find(filter: 'git.repo_action')!
	for action in repo_actions {
		mut p := action.params
		name := p.get('name')!
		account := p.get('account')!
		provider := p.get('provider')!
		action_type := p.get('action')!
		message := p.get_default('message', '')!
		branchname := p.get_default('branchname', '')!
		tagname := p.get_default('tagname', '')!
		submodules := p.get_default_false('submodules')

		mut repo := gs.get_repo(name: name, account: account, provider: provider)!

		match action_type {
			'pull' {
				repo.pull(submodules: submodules)!
			}
			'commit' {
				repo.commit(message)!
			}
			'push' {
				repo.push()!
			}
			'reset' {
				repo.reset()!
			}
			'branch_create' {
				repo.branch_create(branchname)!
			}
			'branch_switch' {
				repo.branch_switch(branchname)!
			}
			'tag_create' {
				repo.tag_create(tagname)!
			}
			'tag_switch' {
				repo.tag_switch(tagname)!
			}
			'delete' {
				repo.delete()!
			}
			else {
				return error('Unknown git.repo_action: ${action_type}')
			}
		}
	}

	// Handle !!git.list
	list_actions := plbook.find(filter: 'git.list')!
	for action in list_actions {
		mut p := action.params
		filter_str := p.get_default('filter', '')!
		name := p.get_default('name', '')!
		account := p.get_default('account', '')!
		provider := p.get_default('provider', '')!
		status_update := p.get_default_false('status_update')

		gs.repos_print(
			filter: filter_str
			name: name
			account: account
			provider: provider
			status_update: status_update
		)!
	}

	// Handle !!git.reload_cache
	reload_cache_actions := plbook.find(filter: 'git.reload_cache')!
	for action in reload_cache_actions {
		mut p := action.params
		coderoot := p.get_default('coderoot', '')!
		if coderoot.len > 0 {
			gs = gittools.new(coderoot: coderoot)!
		}
		gs.load(true)! // Force reload
	}
}