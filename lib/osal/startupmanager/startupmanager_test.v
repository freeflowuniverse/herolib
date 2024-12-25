module startupmanager

import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.osal.screen
import freeflowuniverse.herolib.osal.systemd
import os
import time

const process_name = 'testprocess'

// Initialize test environment
pub fn testsuite_begin() ! {
	// Initialize screen factory
	mut screen_factory := screen.new(reset: true)!

	// Ensure screen directory exists with proper permissions
	home := os.home_dir()
	screen_dir := '${home}/.screen'
	if !os.exists(screen_dir) {
		res := os.execute('mkdir -m 700 ${screen_dir}')
		if res.exit_code != 0 {
			return error('Failed to create screen directory: ${res.output}')
		}
	}

	// Clean up any existing process
	mut sm := get()!
	if sm.exists(process_name)! {
		sm.stop(process_name)!
		time.sleep(200 * time.millisecond) // Give time for cleanup
	}
}

pub fn testsuite_end() ! {
	mut sm := get()!
	if sm.exists(process_name)! {
		sm.stop(process_name)!
		time.sleep(200 * time.millisecond) // Give time for cleanup
	}

	// Clean up screen sessions
	mut screen_factory := screen.new(reset: false)!
	screen_factory.scan()!
	if screen_factory.exists(process_name) {
		screen_factory.kill(process_name)!
		time.sleep(200 * time.millisecond)
	}
}

// Test startup manager status functionality
pub fn test_status() ! {
	mut sm := get()!
	mut screen_factory := screen.new(reset: false)!

	if sm.exists(process_name)! {
		sm.stop(process_name)!
		time.sleep(200 * time.millisecond)

		sm.start(process_name)!
		time.sleep(500 * time.millisecond) // Give time for startup

		status := sm.status(process_name)!
		assert status == .inactive
	} else {
		// Create new process with screen session
		sm.new(
			name:        process_name
			cmd:         'sleep 100'
			description: 'Test process for startup manager'
		)!
		time.sleep(200 * time.millisecond)

		sm.start(process_name)!
		time.sleep(500 * time.millisecond) // Give time for startup

		status := sm.status(process_name)!
		assert status == .active

		// Verify screen session
		screen_factory.scan()!
		assert screen_factory.exists(process_name), 'Screen session not found'
	}

	// Cleanup
	sm.stop(process_name)!
	time.sleep(200 * time.millisecond)
}

// Test process creation with description
pub fn test_process_with_description() ! {
	mut sm := get()!
	mut screen_factory := screen.new(reset: false)!

	description := 'Test process with custom description'

	// Create new process
	sm.new(
		name:        '${process_name}_desc'
		cmd:         'sleep 50'
		description: description
	)!
	time.sleep(200 * time.millisecond)

	// Start and verify
	sm.start('${process_name}_desc')!
	time.sleep(500 * time.millisecond)

	// Verify screen session
	screen_factory.scan()!
	assert screen_factory.exists('${process_name}_desc'), 'Screen session not found'

	// Verify screen is running
	mut screen := screen_factory.get('${process_name}_desc')!
	assert screen.is_running()!, 'Screen should be running'

	// Cleanup
	sm.stop('${process_name}_desc')!
	time.sleep(200 * time.millisecond)

	// Verify screen is not running after cleanup
	assert !screen.is_running()!, 'Screen should not be running after cleanup'
}

// Test error handling
pub fn test_error_handling() ! {
	mut sm := get()!
	mut screen_factory := screen.new(reset: false)!

	// Test non-existent process
	if _ := sm.status('nonexistent_process') {
		assert false, 'Should not get status of non-existent process'
	} else {
		assert true
	}

	// Test invalid screen session
	if _ := screen_factory.get('nonexistent_screen') {
		assert false, 'Should not get non-existent screen'
	} else {
		assert true
	}

	// Test stopping non-existent process
	if _ := sm.stop('nonexistent_process') {
		assert false, 'Should not stop non-existent process'
	} else {
		assert true
	}
}
