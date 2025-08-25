module tmux

import freeflowuniverse.herolib.osal.core as osal
import freeflowuniverse.herolib.data.ourtime
import time
// import freeflowuniverse.herolib.session
import os
import freeflowuniverse.herolib.ui.console

@[heap]
struct Pane {
pub mut:
	window             &Window @[str: skip]
	id                 int    // pane id (e.g., %1, %2)
	pid                int    // process id
	active             bool   // is this the active pane
	cmd                string // command running in pane
	env                map[string]string
	created_at         time.Time
	last_output_offset int // for tracking new logs
}

pub fn (mut p Pane) stats() !ProcessStats {
	if p.pid == 0 {
		return ProcessStats{}
	}

	// Use ps command to get CPU and memory stats
	cmd := 'ps -p ${p.pid} -o %cpu,%mem,rss --no-headers'
	result := osal.execute_silent(cmd) or {
		return error('Cannot get stats for PID ${p.pid}: ${err}')
	}

	if result.trim_space() == '' {
		return error('Process ${p.pid} not found')
	}

	parts := result.trim_space().split_any(' \t').filter(it != '')
	if parts.len < 3 {
		return error('Invalid ps output: ${result}')
	}

	return ProcessStats{
		cpu_percent:    parts[0].f64()
		memory_percent: parts[1].f64()
		memory_bytes:   parts[2].u64() * 1024 // ps returns KB, convert to bytes
	}
}

pub struct TMuxLogEntry {
pub mut:
	content   string
	timestamp time.Time
	offset    int
}

pub fn (mut p Pane) logs_get_new(reset bool) ![]TMuxLogEntry {
	if reset {
		p.last_output_offset = 0
	}
	// Capture pane content with line numbers
	cmd := 'tmux capture-pane -t ${p.window.session.name}:@${p.window.id}.%${p.id} -S ${p.last_output_offset} -p'
	result := osal.execute_silent(cmd) or { return error('Cannot capture pane output: ${err}') }

	lines := result.split_into_lines()
	mut entries := []TMuxLogEntry{}

	mut i := 0
	for line in lines {
		if line.trim_space() != '' {
			entries << TMuxLogEntry{
				content:   line
				timestamp: time.now()
				offset:    p.last_output_offset + i + 1
			}
		}
	}
	// Update offset to avoid duplicates next time
	if entries.len > 0 {
		p.last_output_offset = entries.last().offset
	}
	return entries
}

pub fn (mut p Pane) exit_status() !ProcessStatus {
	// Get the last few lines to see if there's an exit status
	logs := p.logs_all()!
	lines := logs.split_into_lines()

	// Look for shell prompt indicating command finished
	for line in lines.reverse() {
		line_clean := line.trim_space()
		if line_clean.contains('$') || line_clean.contains('#') || line_clean.contains('>') {
			// Found shell prompt, command likely finished
			// Could also check for specific exit codes in history
			return .finished_ok
		}
	}
	return .finished_error
}

pub fn (mut p Pane) logs_all() !string {
	cmd := 'tmux capture-pane -t ${p.window.session.name}:@${p.window.id}.%${p.id} -S -2000 -p'
	return osal.execute_silent(cmd) or { error('Cannot capture pane output: ${err}') }
}

// Fix the output_wait method to use correct method name
pub fn (mut p Pane) output_wait(c_ string, timeoutsec int) ! {
	mut t := ourtime.now()
	start := t.unix()
	c := c_.replace('\n', '')
	for i in 0 .. 2000 {
		entries := p.logs_get_new(reset: false)!
		for entry in entries {
			if entry.content.replace('\n', '').contains(c) {
				return
			}
		}
		mut t2 := ourtime.now()
		if t2.unix() > start + timeoutsec {
			return error('timeout on output wait for tmux.\n${p} .\nwaiting for:\n${c}')
		}
		time.sleep(100 * time.millisecond)
	}
}

// Get process information for this pane and all its children
pub fn (mut p Pane) processinfo() !osal.ProcessMap {
	if p.pid == 0 {
		return error('Pane has no associated process (pid is 0)')
	}

	return osal.processinfo_with_children(p.pid)!
}

// Get process information for just this pane's main process
pub fn (mut p Pane) processinfo_main() !osal.ProcessInfo {
	if p.pid == 0 {
		return error('Pane has no associated process (pid is 0)')
	}

	return osal.processinfo_get(p.pid)!
}
