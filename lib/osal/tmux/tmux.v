module tmux

import freeflowuniverse.herolib.osal.core as osal
// import freeflowuniverse.herolib.session
import os
import time
import freeflowuniverse.herolib.ui.console

@[heap]
pub struct Tmux {
pub mut:
	sessions  []&Session
	sessionid string // unique link to job
}

@[heap]
struct Pane {
pub mut:
	   window     &Window @[str: skip]
	   id         int     // pane id (e.g., %1, %2)
	   pid        int     // process id
	   active     bool    // is this the active pane
	   cmd        string  // command running in pane
	   env        map[string]string
	   created_at time.Time
	   last_output_offset int // for tracking new logs
}

@[params]
pub struct TmuxNewArgs {
	sessionid string
}

// return tmux instance
pub fn new(args TmuxNewArgs) !Tmux {
	mut t := Tmux{
		sessionid: args.sessionid
	}
	// t.load()!
	t.scan()!
	return t
}

// // loads tmux session, populate the object
// pub fn (mut tmux Tmux) load() ! {
// 	// isrunning := tmux.is_running()!
// 	// if !isrunning {
// 	// 	tmux.start()!
// 	// }
// 	// console.print_debug("SCAN")
// 	tmux.scan()!
// }

pub struct ProcessStats {
pub mut:
    cpu_percent   f64
    memory_bytes  u64
    memory_percent f64
}

pub fn (mut p Pane) get_stats() !ProcessStats {
    if p.pid == 0 {
        return ProcessStats{}
    }

    // Use ps command to get CPU and memory stats
    cmd := 'ps -p ${p.pid} -o %cpu,%mem,rss --no-headers'
    result := osal.execute_silent(cmd) or {
        return error('Cannot get stats for PID ${p.pid}: ${err}')
    }

    if result.trim() == '' {
        return error('Process ${p.pid} not found')
    }

    parts := result.trim().split_any(' \t').filter(it != '')
    if parts.len < 3 {
        return error('Invalid ps output: ${result}')
    }

    return ProcessStats{
        cpu_percent: parts[0].f64()
        memory_percent: parts[1].f64()
        memory_bytes: parts[2].u64() * 1024 // ps returns KB, convert to bytes
    }
}

pub fn (mut t Tmux) stop() ! {
	$if debug {
		console.print_debug('Stopping tmux...')
	}

	t.sessions = []&Session{}
	t.scan()!

	for _, mut session in t.sessions {
		session.stop()!
	}

	cmd := 'tmux kill-server'
	_ := osal.exec(cmd: cmd, stdout: false, name: 'tmux_kill_server', ignore_error: true) or {
		panic('bug')
	}
	os.log('TMUX - All sessions stopped .')
}

pub fn (mut t Tmux) start() ! {
	cmd := 'tmux new-sess -d -s main'
	_ := osal.exec(cmd: cmd, stdout: false, name: 'tmux_start') or {
		return error("Can't execute ${cmd} \n${err}")
	}
	// scan and add default bash window created with session init
	time.sleep(time.Duration(100 * time.millisecond))
	t.scan()!
}

enum ProcessStatus {
        running
        finished_ok
        finished_error
        not_found
    }

pub struct LogEntry {
pub mut:
    content   string
    timestamp time.Time
    offset    int
}

pub fn (mut p Pane) get_new_logs() ![]LogEntry {
    // Capture pane content with line numbers
    cmd := 'tmux capture-pane -t ${p.window.session.name}:@${p.window.id}.%${p.id} -S ${p.last_output_offset} -p'
    result := osal.execute_silent(cmd) or {
        return error('Cannot capture pane output: ${err}')
    }
    
    }

pub fn (mut p Pane) check_process_status() !ProcessStatus {
        
        }
    
        if result.trim() == '' {
            // Process not found, check exit status from shell history or tmux
            return p.check_exit_status() or { .finished_error }
        }
    
        return .running
    }
    
    fn (mut p Pane) check_exit_status() !ProcessStatus {
        // Get the last few lines to see if there's an exit status
        logs := p.get_all_logs()!
        lines := logs.split_into_lines()
    
        // Look for shell prompt indicating command finished
        for line in lines.reverse() {
            line_clean := line.trim()
            if line_clean.contains('$') || line_clean.contains('#') || line_clean.contains('>') {
                // Found shell prompt, command likely finished
                // Could also check for specific exit codes in history
                return .finished_ok
            }
        }
    
        return .finished_error
    }

    lines := result.split_into_lines()
    mut entries := []LogEntry{}

    for i, line in lines {
        if line.trim() != '' {
            entries << LogEntry{
                content: line
                timestamp: time.now()
                offset: p.last_output_offset + i + 1
            }
        }
    }

    // Update offset to avoid duplicates next time
    if entries.len > 0 {
        p.last_output_offset = entries.last().offset
    }

    return entries
}

pub fn (mut p Pane) get_all_logs() !string {
    cmd := 'tmux capture-pane -t ${p.window.session.name}:@${p.window.id}.%${p.id} -S -1000 -p'
    return osal.execute_silent(cmd) or {
        error('Cannot capture pane output: ${err}')
    }
}

// print list of tmux sessions
pub fn (mut t Tmux) list_print() {
	// os.log('TMUX - Start listing  ....')
	for _, session in t.sessions {
		for _, window in session.windows {
			console.print_debug(window)
		}
	}
}

// get all windows as found in all sessions
pub fn (mut t Tmux) windows_get() []&Window {
	mut res := []&Window{}
	// os.log('TMUX - Start listing  ....')
	for _, session in t.sessions {
		for _, window in session.windows {
			res << window
		}
	}
	return res
}

// checks whether tmux server is running
pub fn (mut t Tmux) is_running() !bool {
	res := os.execute('tmux info')
	if res.exit_code != 0 {
		if res.output.contains('no server running') {
			// console.print_debug(" TMUX NOT RUNNING")
			return false
		}
		if res.output.contains('no current client') {
			return true
		}
		return error('could not execute tmux info.\n${res.output}')
	}

	return true
}

pub fn (mut t Tmux) str() string {
	mut out := '# Tmux\n\n'
	for s in t.sessions {
		out += '${*s}\n'
	}
	return out
}
