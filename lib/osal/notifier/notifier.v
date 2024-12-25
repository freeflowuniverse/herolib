module notifier

import os.notify
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
	fd       int
}

// Notifier manages file system notifications
pub struct Notifier {
pub mut:
	name        string
	watcher     notify.FdNotifier
	watch_list  []WatchEntry
	is_watching bool
}

// new creates a new Notifier instance
pub fn new(name string) !&Notifier {
	return &Notifier{
		name:        name
		watcher:     notify.new()!
		watch_list:  []WatchEntry{}
		is_watching: false
	}
}

// add_watch adds a path to watch with an associated callback
pub fn (mut n Notifier) add_watch(path string, callback NotifyCallback) ! {
	if !os.exists(path) {
		return error('Path does not exist: ${path}')
	}

	mut f := os.open(path)!
	fd := f.fd
	f.close()

	n.watcher.add(fd, .write | .read, .edge_trigger)!

	n.watch_list << WatchEntry{
		path:     path
		callback: callback
		fd:       fd
	}

	println('Added watch for: ${path}')
}

// remove_watch removes a watched path
pub fn (mut n Notifier) remove_watch(path string) ! {
	for i, entry in n.watch_list {
		if entry.path == path {
			n.watcher.remove(entry.fd) or { return err }
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
	go n.watch_loop()
}

// stop stops watching for events
pub fn (mut n Notifier) stop() {
	n.is_watching = false
}

fn (mut n Notifier) watch_loop() {
	for n.is_watching {
		event := n.watcher.wait(time.Duration(time.hour * 1))
		println(event)
		panic('implement')
		// for entry in n.watch_list {
		// 	if event.fd == entry.fd {
		// 		mut notify_event := NotifyEvent.modify
		// 		if event.kind == .create {
		// 			notify_event = .create
		// 		} else if event.kind == .write {
		// 			notify_event = .write
		// 		}
		// 		if entry.callback != none {
		// 			entry.callback(notify_event, entry.path)
		// 		}
		// 	}
		// }
	}
}
