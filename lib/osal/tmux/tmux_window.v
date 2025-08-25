module tmux

import os
import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.data.ourtime
import time
import freeflowuniverse.herolib.ui.console

@[heap]
struct Window {
pub mut:
	session &Session @[skip]
	name    string
	id      int
	panes   []&Pane // windows contain multiple panes
	active  bool
	env     map[string]string
}

@[params]
pub struct PaneNewArgs {
pub mut:
	name  string
	reset bool // means we reset the pane if it already exists
	cmd   string
	env   map[string]string
}

pub fn (mut w Window) scan() ! {
	// Get current panes for this window
	cmd := "tmux list-panes -t ${w.session.name}:@${w.id} -F '#{pane_id}|#{pane_pid}|#{pane_active}|#{pane_start_command}'"
	result := osal.execute_silent(cmd) or {
		// Window might not exist anymore
		return
	}

	mut current_panes := map[int]bool{}
	for line in result.split_into_lines() {
		if line.contains('|') {
			parts := line.split('|')
			if parts.len >= 3 {
				pane_id := parts[0].replace('%', '').int()
				pane_pid := parts[1].int()
				pane_active := parts[2] == '1'
				pane_cmd := if parts.len > 3 { parts[3] } else { '' }

				current_panes[pane_id] = true

				// Update existing pane or create new one
				mut found := false
				for mut p in w.panes {
					if p.id == pane_id {
						p.pid = pane_pid
						p.active = pane_active
						p.cmd = pane_cmd
						found = true
						break
					}
				}

				if !found {
					mut new_pane := Pane{
						window:             &w
						id:                 pane_id
						pid:                pane_pid
						active:             pane_active
						cmd:                pane_cmd
						env:                map[string]string{}
						created_at:         time.now()
						last_output_offset: 0
					}
					w.panes << &new_pane
				}
			}
		}
	}

	// Remove panes that no longer exist
	w.panes = w.panes.filter(current_panes[it.id] == true)
}

pub fn (mut w Window) stop() ! {
	w.kill()!
}

// helper function
// TODO env variables are not inserted in pane
pub fn (mut w Window) create(cmd_ string) ! {
	mut final_cmd := cmd_
	if cmd_.contains('\n') {
		os.mkdir_all('/tmp/tmux/${w.session.name}')!
		// Fix: osal.exec_string doesn't exist, use file writing instead
		script_path := '/tmp/tmux/${w.session.name}/${w.name}.sh'
		script_content := '#!/bin/bash\n' + cmd_
		os.write_file(script_path, script_content)!
		os.chmod(script_path, 0o755)!
		final_cmd = script_path
	}

	mut newcmd := '/bin/bash -c "${final_cmd}"'
	if cmd_ == '' {
		newcmd = '/bin/bash'
	}

	// Build environment arguments
	mut env_args := ''
	for key, value in w.env {
		env_args += ' -e ${key}="${value}"'
	}

	res_opt := "-P -F '#{session_name}|#{window_name}|#{window_id}|#{pane_active}|#{pane_id}|#{pane_pid}|#{pane_start_command}'"
	cmd := 'tmux new-window ${res_opt}${env_args} -t ${w.session.name} -n ${w.name} \'${newcmd}\''
	console.print_debug(cmd)

	res := osal.exec(cmd: cmd, stdout: false, name: 'tmux_window_create') or {
		return error("Can't create new window ${w.name} \n${cmd}\n${err}")
	}

	line_arr := res.output.split('|')
	wid := line_arr[2] or { return error('cannot split line for window create.\n${line_arr}') }
	w.id = wid.replace('@', '').int()
}

// stop the window
pub fn (mut w Window) kill() ! {
	osal.exec(
		cmd:    'tmux kill-window -t @${w.id}'
		stdout: false
		name:   'tmux_kill-window'
		// die:    false
	) or { return error("Can't kill window with id:${w.id}: ${err}") }
	w.active = false // Window is no longer active
}

pub fn (window Window) str() string {
	mut out := ' - name:${window.name} wid:${window.id} active:${window.active}'
	for pane in window.panes {
		out += '\n    ${*pane}'
	}
	return out
}

pub fn (mut w Window) stats() !ProcessStats {
	mut total := ProcessStats{}
	for mut pane in w.panes {
		stats := pane.stats() or { continue }
		total.cpu_percent += stats.cpu_percent
		total.memory_bytes += stats.memory_bytes
		total.memory_percent += stats.memory_percent
	}
	return total
}

// will select the current window so with tmux a we can go there .
// to login into a session do `tmux a -s mysessionname`
fn (mut w Window) activate() ! {
	cmd2 := 'tmux select-window -t @${w.id}'
	osal.execute_silent(cmd2) or {
		return error("Couldn't select window ${w.name} \n${cmd2}\n${err}")
	}
}

// List panes in a window
pub fn (mut w Window) pane_list() []&Pane {
	return w.panes
}

// Get active pane in window
pub fn (mut w Window) pane_active() ?&Pane {
	for pane in w.panes {
		if pane.active {
			return pane
		}
	}
	return none
}
