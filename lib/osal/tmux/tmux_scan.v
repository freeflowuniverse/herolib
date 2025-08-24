module tmux

import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.ui.console

fn (mut t Tmux) scan_add(line string) !&Pane {
    // Parse the line to get session, window, and pane info
    line_arr := line.split('|')
    session_name := line_arr[0]
    window_name := line_arr[1]
    window_id := line_arr[2]
    pane_active := line_arr[3]
    pane_id := line_arr[4]
    pane_pid := line_arr[5]
    pane_start_command := line_arr[6] or { '' }

    wid := (window_id.replace('@', '')).int()
    pid := (pane_id.replace('%', '')).int()

    mut s := t.session_get(session_name)!

    // Get or create window
    mut w := if s.window_exist(name: window_name, id: wid) {
        s.window_get(name: window_name, id: wid)!
    } else {
        mut new_w := Window{
            session: s
            name: texttools.name_fix(window_name)
            id: wid
            panes: []&Pane{}
        }
        s.windows << &new_w
        &new_w
    }

    // Create or update pane
    mut p := Pane{
        window: w
        id: pid
        pid: pane_pid.int()
        active: pane_active == '1'
        cmd: pane_start_command
        created_at: time.now()
    }

    // Check if pane already exists
    mut found := false
    for mut existing_pane in w.panes {
        if existing_pane.id == pid {
            existing_pane.pid = p.pid
            existing_pane.active = p.active
            existing_pane.cmd = p.cmd
            found = true
            break
        }
    }

    if !found {
        w.panes << &p
    }

    return &p
}

// scan the system to detect sessions .
pub fn (mut t Tmux) scan() ! {
	// os.log('TMUX - Scanning ....')

	cmd_list_session := "tmux list-sessions -F '#{session_name}'"
	exec_list := osal.exec(cmd: cmd_list_session, stdout: false, name: 'tmux_list') or {
		if err.msg().contains('no server running') {
			return
		}
		return error('could not execute list sessions.\n${err}')
	}

	// console.print_debug('execlist out for sessions: ${exec_list}')

	// make sure we have all sessions
	for line in exec_list.output.split_into_lines() {
		session_name := line.trim(' \n').to_lower()
		if session_name == '' {
			continue
		}
		if t.session_exist(session_name) {
			continue
		}
		mut s := Session{
			tmux: &t // reference back
			name: session_name
		}
		t.sessions << &s
	}

	console.print_debug(t)
	println('t: ${t}')
	// mut done := map[string]bool{}
	cmd := "tmux list-panes -a -F '#{session_name}|#{window_name}|#{window_id}|#{pane_active}|#{pane_id}|#{pane_pid}|#{pane_start_command}'"
	out := osal.execute_silent(cmd) or { return error("Can't execute ${cmd} \n${err}") }

	// $if debug{console.print_debug('tmux list panes out:\n${out}')}

	for line in out.split_into_lines() {
		if line.contains('|') {
			t.scan_add(line)!
		}
	}
}
