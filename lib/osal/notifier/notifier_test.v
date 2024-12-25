module notifier

import time
import os

const (
	test_file  = 'test_watch.txt'
	test_file2 = 'test_watch2.txt'
)

fn testsuite_begin() {
	if os.exists(test_file) {
		os.rm(test_file) or { }
	}
}

fn testsuite_end() {
	if os.exists(test_file) {
		os.rm(test_file) or { }
	}
}

fn test_notifier() {
	mut event_received := false
	mut last_event := NotifyEvent.create

	on_file_change := fn [mut event_received, mut last_event] (event NotifyEvent, path string) {
		event_received = true
		last_event = event
	}

	// Create notifier
	mut n := new('test_watcher')!

	// Create test file
	os.write_file(test_file, 'initial content')!

	// Add watch
	n.add_watch(test_file, on_file_change)!

	// Start watching
	n.start()!

	// Test file modification
	time.sleep(100 * time.millisecond)
	os.write_file(test_file, 'modified content')!
	time.sleep(500 * time.millisecond)

	assert event_received == true
	assert last_event == .modify

	// Test file deletion
	event_received = false
	os.rm(test_file)!
	time.sleep(500 * time.millisecond)

	assert event_received == true
	assert last_event == .delete

	// Stop watching
	n.stop()
}

fn test_multiple_watches() {
	mut events_count := 0

	on_any_change := fn [mut events_count] (event NotifyEvent, path string) {
		events_count++
	}

	// Create notifier
	mut n := new('multi_watcher')!

	// Create test files
	os.write_file(test_file, 'file1')!
	os.write_file(test_file2, 'file2')!

	// Add watches
	n.add_watch(test_file, on_any_change)!
	n.add_watch(test_file2, on_any_change)!

	// Start watching
	n.start()!

	// Modify both files
	time.sleep(100 * time.millisecond)
	os.write_file(test_file, 'file1 modified')!
	os.write_file(test_file2, 'file2 modified')!
	time.sleep(500 * time.millisecond)

	assert events_count == 2

	// Cleanup
	n.stop()
	os.rm(test_file)!
	os.rm(test_file2)!
}

fn test_remove_watch() {
	mut events_count := 0

	on_change := fn [mut events_count] (event NotifyEvent, path string) {
		events_count++
	}

	// Create notifier
	mut n := new('remove_test')!

	// Create test file
	os.write_file(test_file, 'content')!

	// Add watch
	n.add_watch(test_file, on_change)!

	// Start watching
	n.start()!

	// Modify file
	time.sleep(100 * time.millisecond)
	os.write_file(test_file, 'modified')!
	time.sleep(500 * time.millisecond)

	assert events_count == 1

	// Remove watch
	n.remove_watch(test_file)!

	// Modify file again
	os.write_file(test_file, 'modified again')!
	time.sleep(500 * time.millisecond)

	// Should still be 1 since watch was removed
	assert events_count == 1

	// Cleanup
	n.stop()
	os.rm(test_file)!
}
