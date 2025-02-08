module screen

import os
import time

const test_screen_name = 'test_screen_session'
const test_cmd = 'echo "test command"'

// Initialize test environment
pub fn testsuite_begin() ! {
	// Check if screen is installed
	res := os.execute('which screen')
	if res.exit_code != 0 {
		return error('screen is not installed. Please install screen first.')
	}

	// Ensure screen directory exists with proper permissions
	home := os.home_dir()
	screen_dir := '${home}/.screen'
	if !os.exists(screen_dir) {
		// Create directory with proper permissions using mkdir -m
		res2 := os.execute('mkdir -m 700 ${screen_dir}')
		if res2.exit_code != 0 {
			return error('Failed to create screen directory: ${res2.output}')
		}
	}

	mut screen_factory := new(reset: true)!
	cleanup_test_screens()!
}

fn cleanup_test_screens() ! {
	mut screen_factory := new(reset: false)!
	screen_factory.scan()!

	// Clean up main test screen
	if screen_factory.exists(test_screen_name) {
		screen_factory.kill(test_screen_name)!
		time.sleep(200 * time.millisecond) // Give time for cleanup
	}

	// Clean up multiple test screens
	if screen_factory.exists('${test_screen_name}_1') {
		screen_factory.kill('${test_screen_name}_1')!
		time.sleep(200 * time.millisecond)
	}
	if screen_factory.exists('${test_screen_name}_2') {
		screen_factory.kill('${test_screen_name}_2')!
		time.sleep(200 * time.millisecond)
	}

	// Final scan to ensure cleanup
	screen_factory.scan()!
}

// Helper function to create and verify screen
fn create_and_verify_screen(mut screen_factory ScreensFactory, name string, cmd string) !&Screen {
	mut screen := screen_factory.add(
		name: name
		cmd:  cmd
	)!

	// Give screen time to initialize
	time.sleep(500 * time.millisecond)

	// Verify screen exists and is running
	screen_factory.scan()!
	if !screen_factory.exists(name) {
		return error('Screen ${name} was not found after creation')
	}

	mut result := screen_factory.get(name)!
	return &result
}

// Test screen creation and basic status
pub fn test_screen_creation() ! {
	defer {
		cleanup_test_screens() or { panic('failed to cleanup test screens: ${err}') }
	}
	mut screen_factory := new(reset: false)!
	mut screen := create_and_verify_screen(mut &screen_factory, test_screen_name, '/bin/bash')!

	assert screen.name == test_screen_name
	status := screen.status()!
	assert status == .active
}

// Test command sending functionality
pub fn test_screen_cmd_send() ! {
	defer {
		cleanup_test_screens() or { panic('failed to cleanup test screens: ${err}') }
	}
	mut screen_factory := new(reset: false)!
	mut screen := create_and_verify_screen(mut &screen_factory, test_screen_name, '/bin/bash')!

	// Send a test command
	screen.cmd_send(test_cmd)!

	// Give some time for command execution
	time.sleep(200 * time.millisecond)

	// Verify screen status after command
	status := screen.status()!
	assert status == .active
}

// Test error cases
pub fn test_screen_errors() ! {
	defer {
		cleanup_test_screens() or { panic('failed to cleanup test screens: ${err}') }
	}
	mut screen_factory := new(reset: false)!

	// Test invalid screen name
	if _ := screen_factory.get('nonexistent_screen') {
		assert false, 'Should not find nonexistent screen'
	} else {
		assert true
	}

	// Test screen status after creation but before start
	mut screen := screen_factory.add(
		name:  test_screen_name
		cmd:   '/bin/bash'
		start: false
	)!
	status := screen.status()!
	assert status == .inactive, 'Screen should be inactive before start'
}

// Test multiple screens
pub fn test_multiple_screens() ! {
	defer {
		cleanup_test_screens() or { panic('failed to cleanup test screens: ${err}') }
	}
	mut screen_factory := new(reset: false)!

	screen1_name := '${test_screen_name}_1'
	screen2_name := '${test_screen_name}_2'

	mut screen1 := create_and_verify_screen(mut &screen_factory, screen1_name, '/bin/bash')!
	mut screen2 := create_and_verify_screen(mut &screen_factory, screen2_name, '/bin/bash')!

	assert screen1.status()! == .active
	assert screen2.status()! == .active

	screen_factory.kill(screen1_name)!
	time.sleep(200 * time.millisecond)
	assert screen1.status()! == .inactive
	assert screen2.status()! == .active

	screen_factory.kill(screen2_name)!
	time.sleep(200 * time.millisecond)
}
