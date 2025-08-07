module playcmds

import freeflowuniverse.herolib.develop.gittools
import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.core.texttools

// !!context.configure
//     name:'test'
//     coderoot:...
//     interactive:true

fn play_core(mut plbook PlayBook) ! {
	// for mut action in plbook.find(filter: 'context.configure')! {
	// 	mut p := action.params
	// 	mut session := plbook.session

	// 	if p.exists('interactive') {
	// 		session.interactive = p.get_default_false('interactive')
	// 	}

	// 	if p.exists('coderoot') {
	// 		panic('implement')
	// 		// mut coderoot := p.get_path_create('coderoot')!
	// 		// mut gs := gittools.get()!
	// 	}
	// 	action.done = true
	// }

	// Track included paths to prevent infinite recursion
	mut included_paths := map[string]bool{}

	for action_ in plbook.find(filter: 'play.*')! {
		if action_.name == 'include' {
			console.print_debug('play run:${action_}')
			mut action := *action_
			mut playrunpath := action.params.get_default('path', '')!
			if playrunpath.len == 0 {
				action.name = 'pull'
				playrunpath = gittools.get_repo_path(
					path:      action.params.get_default('path', '')!
					git_url:   action.params.get_default('git_url', '')!
					git_reset: action.params.get_default_false('git_reset')
					git_pull:  action.params.get_default_false('git_pull')
				)!
			}
			if playrunpath.len == 0 {
				return error("can't run a heroscript didn't find url or path.")
			}

			// Check for cycle detection
			if playrunpath in included_paths {
				console.print_debug('Skipping already included path: ${playrunpath}')
				continue
			}

			console.print_debug('play run path:${playrunpath}')
			included_paths[playrunpath] = true
			plbook.add(path: playrunpath)!
		}
		if action_.name == 'echo' {
			content := action_.params.get_default('content', "didn't find content")!
			console.print_header(content)
		}
	}

	for mut action in plbook.find(filter: 'session.')! {
		mut p := action.params
		mut session := plbook.session

		//!!session.env_set key:'JWT_SHARED_KEY' val:'...'
		if action.name == 'env_set' {
			mut key := p.get('key')!
			mut val := p.get('val') or { p.get('value')! }
			session.env_set(key, val)!
		}

		if action.name == 'env_set_once' {
			mut key := p.get('key')!
			mut val := p.get('val') or { p.get('value')! }
			// Use env_set instead of env_set_once to avoid duplicate errors
			session.env_set(key, val)!
		}

		action.done = true
	}
	mut session := plbook.session

	sitename := session.env_get('SITENAME') or { '' }

	// Apply template replacement from session environment variables
	if session.env.len > 0 {
		// Create a map with name_fix applied to keys for template replacement
		mut env_fixed := map[string]string{}
		for key, value in session.env {
			env_fixed[texttools.name_fix(key)] = value
		}

		for mut action in plbook.actions {
			if !action.done {
				action.params.replace(env_fixed)
			}
		}
	}

	for mut action in plbook.find(filter: 'core.coderoot_set')! {
		mut p := action.params
		if p.exists('coderoot') {
			coderoot := p.get_path_create('coderoot')!
			if session.context.config.coderoot != coderoot {
				session.context.config.coderoot = coderoot
				session.context.save()!
			}
		} else {
			return error('coderoot needs to be specified')
		}
		action.done = true
	}

	for mut action in plbook.find(filter: 'core.params_context_set')! {
		mut p := action.params
		mut context_params := session.context.params()!
		for param in p.params {
			context_params.set(param.key, param.value)
		}
		session.context.save()!
		action.done = true
	}

	for mut action in plbook.find(filter: 'core.params_session_set')! {
		mut p := action.params
		for param in p.params {
			session.params.set(param.key, param.value)
		}
		session.save()!
		action.done = true
	}
}
