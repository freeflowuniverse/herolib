module playcmds

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.ui.console

pub fn play_git(args_ PlayArgs) ! {
	mut args := args_
	mut plbook := args.plbook or {
		playbook.new(text: args.heroscript, path: args.heroscript_path)!
	}

	// Handle !!git.define action first to configure GitStructure
	define_actions := plbook.find(filter: 'git.define')!
	mut gs := if define_actions.len > 0 {
		mut p := define_actions[0].params
		coderoot := p.get_default('coderoot', '')!
		light := p.get_default_true('light')
		log := p.get_default_true('log')
		debug := p.get_default_false('debug')
		offline := p.get_default_false('offline')
		ssh_key_path := p.get_default('ssh_key_path', '')!
		reload := p.get_default_false('reload')

		gittools.new( // Changed to gittools.new
			coderoot:     coderoot
			light:        light
			log:          log
			debug:        debug
			offline:      offline
			ssh_key_path: ssh_key_path
			reload:       reload
		)!
	} else {
		// Initialize GitStructure with defaults
		gittools.get(gittools.GitStructureArgGet{})! // Changed to gittools.get with default args
	}

	// Handle !!git.clone action
	clone_actions := plbook.find(filter: 'git.clone')!
	for action in clone_actions {
		mut p := action.params
		url := p.get('url')!
		coderoot := p.get_default('coderoot', '')!
		sshkey := p.get_default('sshkey', '')!
		light := p.get_default_true('light')
		recursive := p.get_default_false('recursive')

		mut clone_args := gittools.GitCloneArgs{ // Changed to gittools.GitCloneArgs
			url:       url
			sshkey:    sshkey
			recursive: recursive
			light:     light
		}
		if coderoot.len > 0 {
			gs = gittools.new(coderoot: coderoot)! // Changed to gittools.new
		}
		gs.clone(clone_args)!
	}

	// Handle !!git.repo_action
	repo_actions := plbook.find(filter: 'git.repo_action')!
	for action in repo_actions {
		mut p := action.params
		filter_str := p.get_default('filter', '')!
		name := p.get_default('name', '')!
		account := p.get_default('account', '')!
		provider := p.get_default('provider', '')!
		action_type := p.get('action')!
		message := p.get_default('message', '')!
		branchname := p.get_default('branchname', '')!
		tagname := p.get_default('tagname', '')!
		submodules := p.get_default_false('submodules')
		error_ignore := p.get_default_false('error_ignore')

		mut repos := gs.get_repos(
			filter:   filter_str
			name:     name
			account:  account
			provider: provider
		)!

		if repos.len == 0 {
			if !error_ignore {
				return error('No repositories found for git.repo_action with filter: ${filter_str}, name: ${name}, account: ${account}, provider: ${provider}')
			}
			console.print_stderr('No repositories found for git.repo_action with filter: ${filter_str}, name: ${name}, account: ${account}, provider: ${provider}. Ignoring due to error_ignore: true.')
			continue
		}

		for mut repo in repos {
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
					if !error_ignore {
						return error('Unknown git.repo_action: ${action_type}')
					}
					console.print_stderr('Unknown git.repo_action: ${action_type}. Ignoring due to error_ignore: true.')
				}
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
			filter:        filter_str
			name:          name
			account:       account
			provider:      provider
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
