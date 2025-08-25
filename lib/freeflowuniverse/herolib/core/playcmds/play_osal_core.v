module playcmds

import freeflowuniverse.herolib.core.playbook { PlayBook }
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.ui.console

pub fn play_osal_core(mut plbook PlayBook) ! {
	if !plbook.exists(filter: 'osal.') {
		return
	}

	play_done(mut plbook)!
	play_env(mut plbook)!
	play_exec(mut plbook)!
	play_package(mut plbook)!
}

fn play_done(mut plbook PlayBook) ! {
	// Handle !!osal.done_set actions
	mut done_set_actions := plbook.find(filter: 'osal.done_set')!
	for mut action in done_set_actions {
		mut p := action.params
		key := p.get('key')!
		value := p.get('value')!
		
		console.print_header('Setting done key: ${key} = ${value}')
		osal.done_set(key, value)!
		action.done = true
	}

	// Handle !!osal.done_delete actions
	mut done_delete_actions := plbook.find(filter: 'osal.done_delete')!
	for mut action in done_delete_actions {
		mut p := action.params
		key := p.get('key')!
		
		console.print_header('Deleting done key: ${key}')
		osal.done_delete(key)!
		action.done = true
	}

	// Handle !!osal.done_reset actions
	mut done_reset_actions := plbook.find(filter: 'osal.done_reset')!
	for mut action in done_reset_actions {
		console.print_header('Resetting all done keys')
		osal.done_reset()!
		action.done = true
	}

	// Handle !!osal.done_print actions
	mut done_print_actions := plbook.find(filter: 'osal.done_print')!
	for mut action in done_print_actions {
		console.print_header('Printing all done keys')
		osal.done_print()!
		action.done = true
	}
}

fn play_env(mut plbook PlayBook) ! {
	// Handle !!osal.env_set actions
	mut env_set_actions := plbook.find(filter: 'osal.env_set')!
	for mut action in env_set_actions {
		mut p := action.params
		key := p.get('key')!
		value := p.get('value')!
		overwrite := p.get_default_true('overwrite')
		
		console.print_header('Setting environment variable: ${key}')
		osal.env_set(key: key, value: value, overwrite: overwrite)
		action.done = true
	}

	// Handle !!osal.env_unset actions
	mut env_unset_actions := plbook.find(filter: 'osal.env_unset')!
	for mut action in env_unset_actions {
		mut p := action.params
		key := p.get('key')!
		
		console.print_header('Unsetting environment variable: ${key}')
		osal.env_unset(key)
		action.done = true
	}

	// Handle !!osal.env_unset_all actions
	mut env_unset_all_actions := plbook.find(filter: 'osal.env_unset_all')!
	for mut action in env_unset_all_actions {
		console.print_header('Unsetting all environment variables')
		osal.env_unset_all()
		action.done = true
	}

	// Handle !!osal.env_set_all actions
	mut env_set_all_actions := plbook.find(filter: 'osal.env_set_all')!
	for mut action in env_set_all_actions {
		mut p := action.params
		clear_before_set := p.get_default_false('clear_before_set')
		overwrite_if_exists := p.get_default_true('overwrite_if_exists')
		
		// Parse environment variables from parameters
		mut env_map := map[string]string{}
		param_map := p.get_map()
		for key, value in param_map {
			if key !in ['clear_before_set', 'overwrite_if_exists'] {
				env_map[key] = value
			}
		}
		
		console.print_header('Setting multiple environment variables')
		osal.env_set_all(
			env: env_map
			clear_before_set: clear_before_set
			overwrite_if_exists: overwrite_if_exists
		)
		action.done = true
	}

	// Handle !!osal.load_env_file actions
	mut load_env_file_actions := plbook.find(filter: 'osal.load_env_file')!
	for mut action in load_env_file_actions {
		mut p := action.params
		file_path := p.get('file_path')!
		
		console.print_header('Loading environment from file: ${file_path}')
		osal.load_env_file(file_path)!
		action.done = true
	}
}

fn play_exec(mut plbook PlayBook) ! {
	// Handle !!osal.exec actions
	mut exec_actions := plbook.find(filter: 'osal.exec')!
	for mut action in exec_actions {
		mut p := action.params
		cmd := p.get('cmd')!
		
		console.print_header('Executing command: ${cmd}')
		
		mut job := osal.exec(
			name: p.get_default('name', '')!
			cmd: cmd
			description: p.get_default('description', '')!
			timeout: p.get_int_default('timeout', 3600)!
			stdout: p.get_default_true('stdout')
			stdout_log: p.get_default_true('stdout_log')
			raise_error: p.get_default_true('raise_error')
			ignore_error: p.get_default_false('ignore_error')
			work_folder: p.get_default('work_folder', '')!
			scriptkeep: p.get_default_false('scriptkeep')
			debug: p.get_default_false('debug')
			shell: p.get_default_false('shell')
			retry: p.get_int_default('retry', 0)!
			interactive: p.get_default_true('interactive')
			async: p.get_default_false('async')
		)!
		
		// Store job output in done if specified
		if output_key := p.get_default('output_key', '') {
			if output_key != '' {
				osal.done_set(output_key, job.output)!
			}
		}
		
		action.done = true
	}

	// Handle !!osal.exec_silent actions
	mut exec_silent_actions := plbook.find(filter: 'osal.exec_silent')!
	for mut action in exec_silent_actions {
		mut p := action.params
		cmd := p.get('cmd')!
		
		console.print_header('Executing command silently: ${cmd}')
		output := osal.execute_silent(cmd)!
		
		// Store output in done if specified
		if output_key := p.get_default('output_key', '') {
			if output_key != '' {
				osal.done_set(output_key, output)!
			}
		}
		
		action.done = true
	}

	// Handle !!osal.exec_debug actions
	mut exec_debug_actions := plbook.find(filter: 'osal.exec_debug')!
	for mut action in exec_debug_actions {
		mut p := action.params
		cmd := p.get('cmd')!
		
		console.print_header('Executing command with debug: ${cmd}')
		output := osal.execute_debug(cmd)!
		
		// Store output in done if specified
		if output_key := p.get_default('output_key', '') {
			if output_key != '' {
				osal.done_set(output_key, output)!
			}
		}
		
		action.done = true
	}

	// Handle !!osal.exec_stdout actions
	mut exec_stdout_actions := plbook.find(filter: 'osal.exec_stdout')!
	for mut action in exec_stdout_actions {
		mut p := action.params
		cmd := p.get('cmd')!
		
		console.print_header('Executing command to stdout: ${cmd}')
		output := osal.execute_stdout(cmd)!
		
		// Store output in done if specified
		if output_key := p.get_default('output_key', '') {
			if output_key != '' {
				osal.done_set(output_key, output)!
			}
		}
		
		action.done = true
	}

	// Handle !!osal.exec_interactive actions
	mut exec_interactive_actions := plbook.find(filter: 'osal.exec_interactive')!
	for mut action in exec_interactive_actions {
		mut p := action.params
		cmd := p.get('cmd')!
		
		console.print_header('Executing command interactively: ${cmd}')
		osal.execute_interactive(cmd)!
		action.done = true
	}
}

fn play_package(mut plbook PlayBook) ! {
	// Handle !!osal.package_refresh actions
	mut package_refresh_actions := plbook.find(filter: 'osal.package_refresh')!
	for mut action in package_refresh_actions {
		console.print_header('Refreshing package lists')
		osal.package_refresh()!
		action.done = true
	}

	// Handle !!osal.package_install actions
	mut package_install_actions := plbook.find(filter: 'osal.package_install')!
	for mut action in package_install_actions {
		mut p := action.params
		
		// Get package name(s) - can be a single package or comma-separated list
		mut packages := []string{}
		if p.exists('name') {
			packages << p.get('name')!
		}
		if p.exists('names') {
			packages = p.get_list('names')!
		}
		// Also check for positional arguments
		for i in 0 .. 10 {
			if arg := p.get_arg_default(i, '') {
				if arg != '' {
					packages << arg
				}
			} else {
				break
			}
		}
		
		if packages.len == 0 {
			return error('No packages specified for installation')
		}
		
		package_name := packages.join(' ')
		console.print_header('Installing packages: ${package_name}')
		osal.package_install(package_name)!
		action.done = true
	}

	// Handle !!osal.package_remove actions
	mut package_remove_actions := plbook.find(filter: 'osal.package_remove')!
	for mut action in package_remove_actions {
		mut p := action.params
		
		// Get package name(s) - can be a single package or comma-separated list
		mut packages := []string{}
		if p.exists('name') {
			packages << p.get('name')!
		}
		if p.exists('names') {
			packages = p.get_list('names')!
		}
		// Also check for positional arguments
		for i in 0 .. 10 {
			if arg := p.get_arg_default(i, '') {
				if arg != '' {
					packages << arg
				}
			} else {
				break
			}
		}
		
		if packages.len == 0 {
			return error('No packages specified for removal')
		}
		
		package_name := packages.join(' ')
		console.print_header('Removing packages: ${package_name}')
		osal.package_remove(package_name)!
		action.done = true
	}
}