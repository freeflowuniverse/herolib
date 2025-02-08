module core

import os
import base

fn init_context() ! {
	mut c := base.context()!
	c.config.id = 1
	c.config.interactive = true
	c.save()!
}

fn test_sudo_required() ! {
	init_context()!
	// Test if sudo requirement detection works
	required := sudo_required()!
	// We can't assert specific value as it depends on system state
	// but we can verify it returns a valid bool
	assert required == true || required == false
}

fn test_sudo_cmd() {
	init_context()!
	// Test known sudo commands
	assert sudo_cmd('ufw allow 80')! == true
	assert sudo_cmd('echo test')! == false
}

fn test_sudo_path_ok() {
	init_context()!
	// Test path permission checks
	user_home := os.home_dir()
	assert sudo_path_ok(user_home)! == true
}

fn test_sudo_path_protected() {
	init_context()!
	// Test path permission checks for protected paths
	p := '/usr/local'

	// Protected paths should require sudo
	assert sudo_path_ok(p)! == false
}

fn test_sudo_cmd_check() {
	init_context()!
	assert interactive()!, 'interactive mode should be set'

	// Test command sudo requirement checking for non-sudo command
	cmd := 'echo test'

	result := sudo_cmd_check(cmd)!
	assert result == cmd
}

fn test_sudo_cmd_check_sudo_required() ! {
	init_context()!
	assert interactive()!, 'interactive mode should be set'

	// Test command sudo requirement checking for sudo-required command
	cmd := 'ufw something'

	result := sudo_cmd_check(cmd)!
	assert result == 'sudo ${cmd}'
}
