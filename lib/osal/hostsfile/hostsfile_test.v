module hostsfile

fn test_hostsfile_basic() {
	// Create new hosts file instance
	mut hosts := new() or {
		assert false, 'Failed to create hosts file: ${err}'
		return
	}

	// Test adding a host
	hosts.add_host('127.0.0.1', 'test.local', 'Test') or {
		assert false, 'Failed to add host: ${err}'
		return
	}

	// Verify host exists
	assert hosts.exists('test.local'), 'Added host test.local not found'

	// Test adding duplicate host (should fail)
	hosts.add_host('127.0.0.1', 'test.local', 'Test') or {
		assert err.str() == 'Domain test.local already exists in hosts file'
		goto next_test
	}
	assert false, 'Adding duplicate host should fail'
	next_test:
	// Test removing host
	hosts.remove_host('test.local') or {
		assert false, 'Failed to remove host: ${err}'
		return
	}

	// Verify host was removed
	assert !hosts.exists('test.local'), 'Host test.local still exists after removal'

	// Test removing non-existent host (should fail)
	hosts.remove_host('nonexistent.local') or {
		assert err.str() == 'Domain nonexistent.local not found in hosts file'
		return
	}
	assert false, 'Removing non-existent host should fail'
}

fn test_hostsfile_sections() {
	mut hosts := new() or {
		assert false, 'Failed to create hosts file: ${err}'
		return
	}

	// Add hosts to different sections
	hosts.add_host('127.0.0.1', 'dev.local', 'Development') or {
		assert false, 'Failed to add dev host: ${err}'
		return
	}
	hosts.add_host('127.0.0.1', 'prod.local', 'Production') or {
		assert false, 'Failed to add prod host: ${err}'
		return
	}

	// Verify both hosts exist
	assert hosts.exists('dev.local'), 'dev.local not found'
	assert hosts.exists('prod.local'), 'prod.local not found'

	// Test clearing a section
	hosts.clear_section('Development') or {
		assert false, 'Failed to clear Development section: ${err}'
		return
	}

	// Verify Development host removed but Production remains
	assert !hosts.exists('dev.local'), 'dev.local still exists after clearing section'
	assert hosts.exists('prod.local'), 'prod.local was incorrectly removed'

	// Test removing a section
	hosts.remove_section('Production') or {
		assert false, 'Failed to remove Production section: ${err}'
		return
	}

	// Verify all hosts removed
	assert !hosts.exists('dev.local'), 'dev.local still exists'
	assert !hosts.exists('prod.local'), 'prod.local still exists'

	// Test removing non-existent section (should fail)
	hosts.remove_section('NonExistent') or {
		assert err.str() == 'Section NonExistent not found'
		return
	}
	assert false, 'Removing non-existent section should fail'
}

fn test_hostsfile_validation() {
	mut hosts := new() or {
		assert false, 'Failed to create hosts file: ${err}'
		return
	}

	// Test empty IP
	hosts.add_host('', 'test.local', 'Test') or {
		assert err.str() == 'IP address cannot be empty'
		goto next_test1
	}
	assert false, 'Empty IP should fail'
	next_test1:
	// Test empty domain
	hosts.add_host('127.0.0.1', '', 'Test') or {
		assert err.str() == 'Domain cannot be empty'
		return
	}
	assert false, 'Empty domain should fail'
}
