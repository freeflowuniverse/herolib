module notifier

import os
import time

// NotifyEvent represents the type of file system event
pub enum NotifyEvent {
	create
	modify
	delete
	rename
}

// NotifyCallback is the function signature for event callbacks
pub type NotifyCallback = fn (event NotifyEvent, path string)

// WatchEntry represents a watched path and its associated callback
struct WatchEntry {
pub mut:
	path     string
	callback ?NotifyCallback
	pid      int
}

// Notifier manages file system notifications using fswatch
pub struct Notifier {
pub mut:
	name        string
	watch_list  []WatchEntry
	is_watching bool
}

// new creates a new Notifier instance
pub fn new(name string) !&Notifier {
	// Check if fswatch is installed
	if !os.exists_in_system_path('fswatch') {
		return error('fswatch is not installed. Please install it first.')
	}

	return &Notifier{
		name: name
		watch_list: []WatchEntry{}
		is_watching: false
	}
}

// add_watch adds a path to watch with an associated callback
pub fn (mut n Notifier) add_watch(path string, callback NotifyCallback) ! {
	if !os.exists(path) {
		return error('Path does not exist: ${path}')
	}

	n.watch_list << WatchEntry{
		path: path
		callback: callback
		pid: 0
	}

	println('Added watch for: ${path}')
}

// remove_watch removes a watched path
pub fn (mut n Notifier) remove_watch(path string) ! {
	for i, entry in n.watch_list {
		if entry.path == path {
			if entry.pid > 0 {
				os.system('kill ${entry.pid}')
			}
			n.watch_list.delete(i)
			println('Removed watch for: ${path}')
			return
		}
	}
	return error('Path not found in watch list: ${path}')
}

// start begins watching for events
pub fn (mut n Notifier) start() ! {
	if n.is_watching {
		return error('Notifier is already watching')
	}
	if n.watch_list.len == 0 {
		return error('No paths are being watched')
	}

	n.is_watching = true
	
	// Start a watcher for each path
	for mut entry in n.watch_list {
		go n.watch_path(mut entry)
	}
}

// stop stops watching for events
pub fn (mut n Notifier) stop() {
	n.is_watching = false
	// Kill all fswatch processes
	for entry in n.watch_list {
		if entry.pid > 0 {
			os.system('kill ${entry.pid}')
		}
	}
}

fn (mut n Notifier) watch_path(mut entry WatchEntry) {
	// Start fswatch process
	mut p := os.new_process('/opt/homebrew/bin/fswatch')
	p.set_args(['-x', '--event-flags', entry.path])
	p.set_redirect_stdio()
	p.run()
	
	entry.pid = p.pid

	for n.is_watching {
		line := p.stdout_read()
		if line.len > 0 {
			parts := line.split(' ')
			if parts.len >= 2 {
				path := parts[0]
				flags := parts[1]

				mut event := NotifyEvent.modify // Default to modify

				// Parse fswatch event flags
				// See: https://emcrisostomo.github.io/fswatch/doc/1.17.1/fswatch.html#Event-Flags
				if flags.contains('Created') {
					event = .create
				} else if flags.contains('Removed') {
					event = .delete
				} else if flags.contains('Renamed') {
					event = .rename
				} else if flags.contains('Updated') || flags.contains('Modified') {
					event = .modify
				}

				if cb := entry.callback {
					cb(event, path)
				}
			}
		}
		time.sleep(100 * time.millisecond)
	}

	p.close()
}
