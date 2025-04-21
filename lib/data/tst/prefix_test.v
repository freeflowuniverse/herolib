module tst

import os

// Define a struct for test cases
struct PrefixTestCase {
	prefix string
	expected_count int
}

// Test more complex prefix search scenarios
fn test_complex_prefix_search() {
	mut tree := new(path: 'testdata/test_complex_prefix.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Insert a larger set of keys with various prefixes
	keys := [
		'a', 'ab', 'abc', 'abcd', 'abcde',
		'b', 'bc', 'bcd', 'bcde',
		'c', 'cd', 'cde',
		'x', 'xy', 'xyz',
		'test', 'testing', 'tested', 'tests',
		'team', 'teammate', 'teams',
		'tech', 'technology', 'technical'
	]

	// Insert all keys
	for i, key in keys {
		value := 'value-${i}'.bytes()
		tree.set(key, value) or {
			assert false, 'Failed to set key "${key}": ${err}'
			return
		}
	}

	// Test various prefix searches
	test_cases := [
		// prefix, expected_count
		PrefixTestCase{'a', 5},
		PrefixTestCase{'ab', 4},
		PrefixTestCase{'abc', 3},
		PrefixTestCase{'abcd', 2},
		PrefixTestCase{'abcde', 1},
		PrefixTestCase{'b', 4},
		PrefixTestCase{'bc', 3},
		PrefixTestCase{'t', 10},
		PrefixTestCase{'te', 7},
		PrefixTestCase{'tes', 4},
		PrefixTestCase{'test', 4},
		PrefixTestCase{'team', 3},
		PrefixTestCase{'tech', 3},
		PrefixTestCase{'x', 3},
		PrefixTestCase{'xy', 2},
		PrefixTestCase{'xyz', 1},
		PrefixTestCase{'z', 0},  // No matches
		PrefixTestCase{'', keys.len}  // All keys
	]

	for test_case in test_cases {
		prefix := test_case.prefix
		expected_count := test_case.expected_count

		result := tree.list(prefix) or {
			if expected_count > 0 {
				assert false, 'Failed to list keys with prefix "${prefix}": ${err}'
			}
			[]string{}
		}

		assert result.len == expected_count, 'For prefix "${prefix}": expected ${expected_count} keys, got ${result.len}'
		
		// Verify each result starts with the prefix
		for key in result {
			assert key.starts_with(prefix), 'Key "${key}" does not start with prefix "${prefix}"'
		}
	}
}

// Test prefix search with longer strings and special characters
fn test_special_prefix_search() {
	mut tree := new(path: 'testdata/test_special_prefix.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Insert keys with special characters and longer strings
	special_keys := [
		'user:1:profile', 'user:1:settings', 'user:1:posts',
		'user:2:profile', 'user:2:settings',
		'config:app:name', 'config:app:version', 'config:app:debug',
		'config:db:host', 'config:db:port',
		'data:2023:01:01', 'data:2023:01:02', 'data:2023:02:01',
		'very:long:key:with:multiple:segments:and:special:characters:!@#$%^&*()',
		'another:very:long:key:with:different:segments'
	]

	// Insert all keys
	for i, key in special_keys {
		value := 'special-value-${i}'.bytes()
		tree.set(key, value) or {
			assert false, 'Failed to set key "${key}": ${err}'
			return
		}
	}

	// Test various prefix searches
	special_test_cases := [
		// prefix, expected_count
		PrefixTestCase{'user:', 5},
		PrefixTestCase{'user:1:', 3},
		PrefixTestCase{'user:2:', 2},
		PrefixTestCase{'config:', 5},
		PrefixTestCase{'config:app:', 3},
		PrefixTestCase{'config:db:', 2},
		PrefixTestCase{'data:2023:', 3},
		PrefixTestCase{'data:2023:01:', 2},
		PrefixTestCase{'very:', 1},
		PrefixTestCase{'another:', 1},
		PrefixTestCase{'nonexistent:', 0}
	]

	for test_case in special_test_cases {
		prefix := test_case.prefix
		expected_count := test_case.expected_count

		result := tree.list(prefix) or {
			if expected_count > 0 {
				assert false, 'Failed to list keys with prefix "${prefix}": ${err}'
			}
			[]string{}
		}

		assert result.len == expected_count, 'For prefix "${prefix}": expected ${expected_count} keys, got ${result.len}'
		
		// Verify each result starts with the prefix
		for key in result {
			assert key.starts_with(prefix), 'Key "${key}" does not start with prefix "${prefix}"'
		}
	}
}

// Test prefix search performance with a larger dataset
fn test_prefix_search_performance() {
	mut tree := new(path: 'testdata/test_performance.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Generate a larger dataset (1000 keys)
	prefixes := ['user', 'config', 'data', 'app', 'service', 'api', 'test', 'dev', 'prod', 'staging']
	mut large_keys := []string{}
	
	for prefix in prefixes {
		for i in 0..100 {
			large_keys << '${prefix}:${i}:name'
		}
	}

	// Insert all keys
	for i, key in large_keys {
		value := 'performance-value-${i}'.bytes()
		tree.set(key, value) or {
			assert false, 'Failed to set key "${key}": ${err}'
			return
		}
	}

	// Test prefix search performance
	for prefix in prefixes {
		result := tree.list(prefix + ':') or {
			assert false, 'Failed to list keys with prefix "${prefix}:": ${err}'
			return
		}

		assert result.len == 100, 'For prefix "${prefix}:": expected 100 keys, got ${result.len}'
		
		// Verify each result starts with the prefix
		for key in result {
			assert key.starts_with(prefix + ':'), 'Key "${key}" does not start with prefix "${prefix}:"'
		}
	}

	// Test more specific prefixes
	for prefix in prefixes {
		for i in 0..10 {
			specific_prefix := '${prefix}:${i}'
			result := tree.list(specific_prefix) or {
				assert false, 'Failed to list keys with prefix "${specific_prefix}": ${err}'
				return
			}

			assert result.len == 1, 'For prefix "${specific_prefix}": expected 1 key, got ${result.len}'
			assert result[0] == '${specific_prefix}:name', 'Expected "${specific_prefix}:name", got "${result[0]}"'
		}
	}
}