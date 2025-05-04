module tst

import os

// Define a struct for test cases
struct PrefixEdgeCaseTest {
	prefix        string
	expected_keys []string
}

// Test specific edge cases for prefix search that were problematic
fn test_edge_case_prefix_search() {
	mut tree := new(path: 'testdata/test_edge_prefix.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Keys with a common prefix that may cause issues
	keys := [
		'test',
		'testing',
		'tea',
		'team',
		'technology',
		'apple',
		'application',
		'appreciate',
		'banana',
		'bandage',
		'band',
		'car',
		'carpet',
		'carriage',
	]

	// Insert all keys
	for i, key in keys {
		value := 'value-${i}'.bytes()
		tree.set(key, value) or {
			assert false, 'Failed to set key "${key}": ${err}'
			return
		}
	}

	// Test cases specifically focusing on the 'te' prefix issue
	test_cases := [
		// prefix, expected_keys
		PrefixEdgeCaseTest{
			prefix:        'te'
			expected_keys: ['test', 'testing', 'tea', 'team', 'technology']
		},
		PrefixEdgeCaseTest{
			prefix:        'tes'
			expected_keys: ['test', 'testing']
		},
		PrefixEdgeCaseTest{
			prefix:        'tea'
			expected_keys: ['tea', 'team']
		},
		PrefixEdgeCaseTest{
			prefix:        'a'
			expected_keys: ['apple', 'application', 'appreciate']
		},
		PrefixEdgeCaseTest{
			prefix:        'ba'
			expected_keys: ['banana', 'bandage', 'band']
		},
		PrefixEdgeCaseTest{
			prefix:        'ban'
			expected_keys: ['banana', 'band']
		},
		PrefixEdgeCaseTest{
			prefix:        'c'
			expected_keys: ['car', 'carpet', 'carriage']
		},
	]

	for test_case in test_cases {
		prefix := test_case.prefix
		expected_keys := test_case.expected_keys

		result := tree.list(prefix) or {
			assert false, 'Failed to list keys with prefix "${prefix}": ${err}'
			return
		}

		// Check count matches
		assert result.len == expected_keys.len, 'For prefix "${prefix}": expected ${expected_keys.len} keys, got ${result.len} (keys: ${result})'

		// Check all expected keys are present
		for key in expected_keys {
			assert key in result, 'Key "${key}" missing from results for prefix "${prefix}"'
		}

		// Verify each result starts with the prefix
		for key in result {
			assert key.starts_with(prefix), 'Key "${key}" does not start with prefix "${prefix}"'
		}
	}

	println('All edge case prefix tests passed successfully!')
}

// Test prefix search with insert order that might cause issues
fn test_tricky_insertion_order() {
	mut tree := new(path: 'testdata/test_tricky_insert.db', reset: true) or {
		assert false, 'Failed to create TST: ${err}'
		return
	}

	// Insert keys in a specific order that might trigger the issue
	// Insert 'team' first, then 'test', etc. to ensure tree layout is challenging
	tricky_keys := [
		'team',
		'test',
		'technology',
		'tea', // 'te' prefix cases
		'car',
		'carriage',
		'carpet', // 'ca' prefix cases
	]

	// Insert all keys
	for i, key in tricky_keys {
		value := 'value-${i}'.bytes()
		tree.set(key, value) or {
			assert false, 'Failed to set key "${key}": ${err}'
			return
		}
	}

	// Test 'te' prefix
	te_results := tree.list('te') or {
		assert false, 'Failed to list keys with prefix "te": ${err}'
		return
	}
	assert te_results.len == 4, 'Expected 4 keys with prefix "te", got ${te_results.len} (keys: ${te_results})'
	assert 'team' in te_results, 'Expected "team" in results'
	assert 'test' in te_results, 'Expected "test" in results'
	assert 'technology' in te_results, 'Expected "technology" in results'
	assert 'tea' in te_results, 'Expected "tea" in results'

	// Test 'ca' prefix
	ca_results := tree.list('ca') or {
		assert false, 'Failed to list keys with prefix "ca": ${err}'
		return
	}
	assert ca_results.len == 3, 'Expected 3 keys with prefix "ca", got ${ca_results.len} (keys: ${ca_results})'
	assert 'car' in ca_results, 'Expected "car" in results'
	assert 'carriage' in ca_results, 'Expected "carriage" in results'
	assert 'carpet' in ca_results, 'Expected "carpet" in results'

	println('All tricky insertion order tests passed successfully!')
}
