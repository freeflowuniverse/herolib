module tst

import os

fn testsuite_begin() {
	// Clean up any test files from previous runs
	if os.exists('testdata') {
		os.rmdir_all('testdata') or {}
	}
	os.mkdir('testdata') or {}
}

fn testsuite_end() {
	// Clean up test files
	if os.exists('testdata') {
		os.rmdir_all('testdata') or {}
	}
}

// Test basic set and get operations
fn test_set_get() {
	mut tree := new(path: 'testdata/test_set_get.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Test setting and getting values
	tree.set('hello', 'world'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('help', 'me'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('test', 'value'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}

	// Test getting values
	value1 := tree.get('hello') or {
		assert false, 'Failed to get key: ${err}'
		return
	}
	assert value1.bytestr() == 'world', 'Expected "world", got "${value1.bytestr()}"'

	value2 := tree.get('help') or {
		assert false, 'Failed to get key: ${err}'
		return
	}
	assert value2.bytestr() == 'me', 'Expected "me", got "${value2.bytestr()}"'

	value3 := tree.get('test') or {
		assert false, 'Failed to get key: ${err}'
		return
	}
	assert value3.bytestr() == 'value', 'Expected "value", got "${value3.bytestr()}"'

	// Test getting a non-existent key
	tree.get('nonexistent') or {
		assert err.str() == 'Key not found', 'Expected "Key not found", got "${err}"'
		return
	}
	assert false, 'Expected error for non-existent key'
}

// Test deletion
fn test_delete() {
	mut tree := new(path: 'testdata/test_delete.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Set some keys
	tree.set('hello', 'world'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('help', 'me'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('test', 'value'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}

	// Delete a key
	tree.delete('hello') or {
		assert false, 'Failed to delete key: ${err}'
		return
	}

	// Verify the key was deleted
	tree.get('hello') or {
		assert err.str() == 'Key not found', 'Expected "Key not found", got "${err}"'
		return
	}
	assert false, 'Expected error for deleted key'
}

// Test prefix search
fn test_list_prefix() {
	mut tree := new(path: 'testdata/test_list_prefix.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Set some keys with common prefixes
	tree.set('hello', 'world'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('help', 'me'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('test', 'value'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('testing', 'another'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('tested', 'past'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}

	// Test listing keys with prefix 'hel'
	hel_keys := tree.list('hel') or {
		assert false, 'Failed to list keys with prefix: ${err}'
		return
	}
	assert hel_keys.len == 2, 'Expected 2 keys with prefix "hel", got ${hel_keys.len}'
	assert 'hello' in hel_keys, 'Expected "hello" in keys with prefix "hel"'
	assert 'help' in hel_keys, 'Expected "help" in keys with prefix "hel"'

	// Test listing keys with prefix 'test'
	test_keys := tree.list('test') or {
		assert false, 'Failed to list keys with prefix: ${err}'
		return
	}
	assert test_keys.len == 2, 'Expected 2 keys with prefix "test", got ${test_keys.len}'
	assert 'test' in test_keys, 'Expected "test" in keys with prefix "test"'
	assert 'testing' in test_keys, 'Expected "testing" in keys with prefix "test"'

	// Test listing all keys
	all_keys := tree.list('') or {
		assert false, 'Failed to list all keys: ${err}'
		return
	}
	assert all_keys.len == 5, 'Expected 5 keys in total, got ${all_keys.len}'
}

// Test getall function
fn test_getall() {
	mut tree := new(path: 'testdata/test_getall.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Set some keys with common prefixes
	tree.set('hello', 'world'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('help', 'me'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}
	tree.set('test', 'value'.bytes()) or {
		assert false, 'Failed to set key: ${err}'
		return
	}

	// Test getting all values with prefix 'hel'
	hel_values := tree.getall('hel') or {
		assert false, 'Failed to get values with prefix: ${err}'
		return
	}
	assert hel_values.len == 2, 'Expected 2 values with prefix "hel", got ${hel_values.len}'

	// Convert byte arrays to strings for easier comparison
	mut hel_strings := []string{}
	for val in hel_values {
		hel_strings << val.bytestr()
	}

	assert 'world' in hel_strings, 'Expected "world" in values with prefix "hel"'
	assert 'me' in hel_strings, 'Expected "me" in values with prefix "hel"'
}

// Test persistence
fn test_persistence() {
	// Create a new TST and add some data
	{
		mut tree := new(path: 'testdata/test_persistence.db', reset: true) or {
			assert false, 'Failed to create TST: ${err}'
			return
		}

		tree.set('hello', 'world'.bytes()) or {
			assert false, 'Failed to set key: ${err}'
			return
		}
		tree.set('test', 'value'.bytes()) or {
			assert false, 'Failed to set key: ${err}'
			return
		}
	}

	// Create a new TST with the same path but don't reset
	{
		mut tree := new(path: 'testdata/test_persistence.db', reset: false) or {
			assert false, 'Failed to create TST: ${err}'
			return
		}

		// Verify the data persisted
		value1 := tree.get('hello') or {
			assert false, 'Failed to get key: ${err}'
			return
		}
		assert value1.bytestr() == 'world', 'Expected "world", got "${value1.bytestr()}"'

		value2 := tree.get('test') or {
			assert false, 'Failed to get key: ${err}'
			return
		}
		assert value2.bytestr() == 'value', 'Expected "value", got "${value2.bytestr()}"'
	}
}
