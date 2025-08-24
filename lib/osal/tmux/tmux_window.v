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
	panes   []&Pane  // windows contain multiple panes
	active  bool
	env     map[string]string
}

@[params]
pub struct PaneNewArgs {
pub mut:
	name  string
	reset bool //means we reset the pane if it already exists
	cmd   string
	env   map[string]string 
}


pub fn (mut w Window) scan() ! {
	//TODO: here needs to be the code to check reality and update panes
}


//helper function
//TODO env variables are not inserted in pane
fn (mut w Window) pane_create(args_ PaneNewArgs) ! {
	// tmux new-window -P -c /tmp -e good=1 -e bad=0 -n koekoe -t main bash
	mut args := args_
	mut final_cmd := args.cmd
	if args.cmd.contains('\n') {
		// means is multiline need to write it
		// scriptpath         string // is the path where the script will be put which is executed
		// scriptkeep         bool   // means we don't remove the script
		os.mkdir_all('/tmp/tmux/${w.session.name}')!
		cmd_new := osal.exec_string(
			cmd:        cmd_
			scriptpath: '/tmp/tmux/${w.session.name}/${w.name}.sh'
			scriptkeep: true
		)!
		final_cmd = cmd_new
	}

	mut newcmd:='/bin/bash -c ${final_cmd}'
	if cmd_==""{
		newcmd = '/bin/bash'	
	}

	res_opt := "-P -F '#{session_name}|#{window_name}|#{window_id}|#{pane_active}|#{pane_id}|#{pane_pid}|#{pane_start_command}'"
	cmd := 'tmux new-window  ${res_opt} -t ${w.session.name} -n ${w.name} \'${newcmd}\''
	console.print_debug(cmd)
	res := osal.exec(cmd: cmd, stdout: false, name: 'tmux_window_create') or {
		return error("Can't create new window ${w.name} \n${cmd}\n${err}")
	}
	// now look at output to get the window id = wid
	line_arr := res.output.split('|')
	wid := line_arr[2] or { panic('cannot split line for window create.\n${line_arr}') }
	w.id = wid.replace('@', '').int()
	$if debug {
		console.print_header(' WINDOW - Window: ${w.name} created in session: ${w.session.name}')
	}
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
