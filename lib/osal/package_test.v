module osal

fn test_package_management() {
	platform_ := platform()

	if platform_ == .osx {
		// Check if brew is installed
		if !cmd_exists('brew') {
			eprintln('WARNING: Homebrew is not installed. Please install it to run package management tests on OSX.')
			return
		}
	}

	// First ensure wget is not installed
	package_remove('wget') or {}

	// Verify wget is not installed
	assert !cmd_exists('wget')

	// Update package list
	package_refresh() or { assert false, 'Failed to refresh package list: ${err}' }

	// Install wget
	package_install('wget') or { assert false, 'Failed to install wget: ${err}' }

	// Verify wget is now installed
	assert cmd_exists('wget')

	// Clean up - remove wget
	package_remove('wget') or { assert false, 'Failed to remove wget: ${err}' }

	// Verify wget is removed
	assert !cmd_exists('wget')
}
