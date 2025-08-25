#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.osal.tmux
import freeflowuniverse.herolib.osal.core as osal
import time
import os

// Configuration
const session_name = 'server_dashboard'
const window_name = 'dashboard'
const python_port = 8000
const ttyd_port = 7890

println('=== Server Dashboard with 3 Panes ===')
println('Setting up tmux session with:')
println('  1. Python HTTP Server (port ${python_port})')
println('  2. Counter (updating every 5 seconds)')
println('  3. CPU Monitor (htop)')
println('')

// Initialize tmux
mut t := tmux.new()!

if !t.is_running()! {
	println('Starting tmux server...')
	t.start()!
}

// Clean up existing session if it exists
if t.session_exist(session_name) {
	println('Cleaning up existing ${session_name} session...')
	t.session_delete(session_name)!
}

// Create new session
println('Creating ${session_name} session...')
mut session := t.session_create(name: session_name)!

// Create main window with initial bash shell
println('Creating dashboard window...')
mut window := session.window_new(name: window_name, cmd: 'bash', reset: true)!

// Wait for initial setup
time.sleep(500 * time.millisecond)
t.scan()!

println('\n=== Setting up 3-pane layout ===')

// Get the main window
window = session.window_get(name: window_name)!

// Split horizontally first (left and right halves)
println('1. Splitting horizontally for left/right layout...')
mut right_pane := window.pane_split_horizontal('bash')!
time.sleep(300 * time.millisecond)
window.scan()!

// Split left pane vertically (top-left and bottom-left)
println('2. Splitting left pane vertically...')
window.scan()!
if window.panes.len >= 2 {
	mut left_pane := window.panes[0] // First pane should be the left one
	left_pane.select()!
	time.sleep(200 * time.millisecond)
	mut bottom_left_pane := window.pane_split_vertical('bash')!
	time.sleep(300 * time.millisecond)
	window.scan()!
}

println('3. Layout complete! We now have 3 panes.')

// Refresh to get all panes
window.scan()!
println('\nCurrent panes: ${window.panes.len}')
for i, pane in window.panes {
	println('  Pane ${i}: ID=%${pane.id}, PID=${pane.pid}')
}

if window.panes.len < 3 {
	eprintln('Expected 3 panes, but got ${window.panes.len}')
	exit(1)
}

println('\n=== Starting services in each pane ===')

// Pane 1 (top-left): Python HTTP Server
println('Starting Python HTTP Server in pane 1...')
mut pane1 := window.panes[0]
pane1.select()!
pane1.send_command('echo "=== Python HTTP Server Port 8000 ==="')!
pane1.send_command('cd /tmp && python3 -m http.server ${python_port}')!

time.sleep(500 * time.millisecond)

// Pane 2 (bottom-left): Counter
println('Starting Counter in pane 2...')
mut pane2 := window.panes[1]
pane2.select()!
pane2.send_command('echo "=== Counter 1 to 10000 every 5 seconds ==="')!
// Start simple counter using a loop instead of watch
pane2.send_command('while true; do echo "Count: $(date)"; sleep 5; done')!

time.sleep(500 * time.millisecond)

// Pane 3 (right): CPU Monitor
println('Starting CPU Monitor in pane 3...')
mut pane3 := window.panes[2]
pane3.select()!
pane3.send_command('echo "=== CPU Monitor ==="')!
pane3.send_command('htop')!

println('\n=== All services started! ===')

// Wait a moment for services to initialize
time.sleep(2000 * time.millisecond)

// Refresh and show current state
t.scan()!
window = session.window_get(name: window_name)!

println('\n=== Current Dashboard State ===')
for i, mut pane in window.panes {
	stats := pane.stats() or {
		println('  Pane ${i + 1}: ID=%${pane.id}, PID=${pane.pid} (stats unavailable)')
		continue
	}
	memory_mb := f64(stats.memory_bytes) / (1024.0 * 1024.0)
	service_name := match i {
		0 { 'Python Server' }
		1 { 'Counter' }
		2 { 'CPU Monitor' }
		else { 'Unknown' }
	}
	println('  Pane ${i + 1} (${service_name}): ID=%${pane.id}, CPU=${stats.cpu_percent:.1f}%, Memory=${memory_mb:.1f}MB')
}

println('\n=== Access Information ===')
println('• Python HTTP Server: http://localhost:${python_port}')
println('• Tmux Session: tmux attach-session -t ${session_name}')
println('')
println('=== Pane Resize Commands ===')
println('To resize panes, attach to the session and use:')
println('  Ctrl+B then Arrow Keys (hold Ctrl+B and press arrow keys)')
println('  Or programmatically:')
for i, pane in window.panes {
	service_name := match i {
		0 { 'Python Server' }
		1 { 'Counter' }
		2 { 'CPU Monitor' }
		else { 'Unknown' }
	}
	println('  # Resize ${service_name} pane:')
	println('  tmux resize-pane -t ${session_name}:${window_name}.%${pane.id} -U 5  # Up')
	println('  tmux resize-pane -t ${session_name}:${window_name}.%${pane.id} -D 5  # Down')
	println('  tmux resize-pane -t ${session_name}:${window_name}.%${pane.id} -L 5  # Left')
	println('  tmux resize-pane -t ${session_name}:${window_name}.%${pane.id} -R 5  # Right')
}

println('\n=== Dashboard is running! ===')
println('Attach to view: tmux attach-session -t ${session_name}')
println('Press Ctrl+B then d to detach from session')
println('To stop all services: tmux kill-session -t ${session_name}')
println('Running the browser-based dashboard: TTYD')

window.run_ttyd(ttyd_port) or { println('Failed to start ttyd: ${err}') }
