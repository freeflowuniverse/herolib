module dedupestor

import os

fn testsuite_begin() ! {
	// Ensure test directories exist and are clean
	test_dirs := [
		'/tmp/dedupestor_test',
		'/tmp/dedupestor_test_size',
		'/tmp/dedupestor_test_exists',
		'/tmp/dedupestor_test_multiple'
	]
	
	for dir in test_dirs {
		if os.exists(dir) {
			os.rmdir_all(dir) or {}
		}
		os.mkdir_all(dir) or {}
	}
}

fn test_basic_operations() ! {
	mut ds := new(
		path: '/tmp/dedupestor_test'
		reset: true
	)!

	// Test storing and retrieving data
	value1 := 'test data 1'.bytes()
	hash1 := ds.store(value1)!
	
	retrieved1 := ds.get(hash1)!
	assert retrieved1 == value1

	// Test deduplication
	hash2 := ds.store(value1)!
	assert hash1 == hash2 // Should return same hash for same data

	// Test different data gets different hash
	value2 := 'test data 2'.bytes()
	hash3 := ds.store(value2)!
	assert hash1 != hash3 // Should be different hash for different data

	retrieved2 := ds.get(hash3)!
	assert retrieved2 == value2
}

fn test_size_limit() ! {
	mut ds := new(
		path: '/tmp/dedupestor_test_size'
		reset: true
	)!

	// Test data under size limit (1KB)
	small_data := []u8{len: 1024, init: u8(index)}
	small_hash := ds.store(small_data)!
	retrieved := ds.get(small_hash)!
	assert retrieved == small_data

	// Test data over size limit (2MB)
	large_data := []u8{len: 2 * 1024 * 1024, init: u8(index)}
	if _ := ds.store(large_data) {
		assert false, 'Expected error for data exceeding size limit'
	}
}

fn test_exists() ! {
	mut ds := new(
		path: '/tmp/dedupestor_test_exists'
		reset: true
	)!

	value := 'test data'.bytes()
	hash := ds.store(value)!

	assert ds.exists(hash) == true
	assert ds.exists('nonexistent') == false
}

fn test_multiple_operations() ! {
	mut ds := new(
		path: '/tmp/dedupestor_test_multiple'
		reset: true
	)!

	// Store multiple values
	mut values := [][]u8{}
	mut hashes := []string{}

	for i in 0..5 {
		value := 'test data ${i}'.bytes()
		values << value
		hash := ds.store(value)!
		hashes << hash
	}

	// Verify all values can be retrieved
	for i, hash in hashes {
		retrieved := ds.get(hash)!
		assert retrieved == values[i]
	}

	// Test deduplication by storing same values again
	for i, value in values {
		hash := ds.store(value)!
		assert hash == hashes[i] // Should get same hash for same data
	}
}
