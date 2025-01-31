module radixtree

fn test_basic_operations() ! {
	mut rt := new(path: '/tmp/radixtree_test', reset: true)!

	// Test insert and search
	rt.insert('test', 'value1'.bytes())!
	value1 := rt.search('test')!
	assert value1.bytestr() == 'value1'

	// Test updating existing key
	rt.insert('test', 'value2'.bytes())!
	value2 := rt.search('test')!
	assert value2.bytestr() == 'value2'

	// Test non-existent key
	if _ := rt.search('nonexistent') {
		assert false, 'Expected error for non-existent key'
	}

	// Test delete
	rt.delete('test')!
	mut ok := false
	if _ := rt.search('test') {
		ok = true
	}
	assert ok
}

fn test_prefix_matching() ! {
	mut rt := new(path: '/tmp/radixtree_test_prefix')!

	// Insert keys with common prefixes
	rt.insert('team', 'value1'.bytes())!
	rt.insert('test', 'value2'.bytes())!
	rt.insert('testing', 'value3'.bytes())!

	// Verify each key has correct value
	value1 := rt.search('team')!
	assert value1.bytestr() == 'value1'

	value2 := rt.search('test')!
	assert value2.bytestr() == 'value2'

	value3 := rt.search('testing')!
	assert value3.bytestr() == 'value3'

	// Delete middle key and verify others still work
	rt.delete('test')!

	if _ := rt.search('test') {
		assert false, 'Expected error after deletion'
	}

	value1_after := rt.search('team')!
	assert value1_after.bytestr() == 'value1'

	value3_after := rt.search('testing')!
	assert value3_after.bytestr() == 'value3'
}

fn test_edge_cases() ! {
	mut rt := new(path: '/tmp/radixtree_test_edge')!

	// Test empty key
	rt.insert('', 'empty'.bytes())!
	empty_value := rt.search('')!
	assert empty_value.bytestr() == 'empty'

	// Test very long key
	long_key := 'a'.repeat(1000)
	rt.insert(long_key, 'long'.bytes())!
	long_value := rt.search(long_key)!
	assert long_value.bytestr() == 'long'

	// Test keys that require node splitting
	rt.insert('test', 'value1'.bytes())!
	rt.insert('testing', 'value2'.bytes())!
	rt.insert('te', 'value3'.bytes())!

	value1 := rt.search('test')!
	assert value1.bytestr() == 'value1'

	value2 := rt.search('testing')!
	assert value2.bytestr() == 'value2'

	value3 := rt.search('te')!
	assert value3.bytestr() == 'value3'
}

fn test_multiple_operations() ! {
	mut rt := new(path: '/tmp/radixtree_test_multiple')!

	// Insert multiple keys
	keys := ['abc', 'abcd', 'abcde', 'bcd', 'bcde']
	for i, key in keys {
		rt.insert(key, 'value${i + 1}'.bytes())!
	}

	// Verify all keys
	for i, key in keys {
		value := rt.search(key)!
		assert value.bytestr() == 'value${i + 1}'
	}

	// Delete some keys
	rt.delete('abcd')!
	rt.delete('bcde')!

	// Verify remaining keys
	remaining := ['abc', 'abcde', 'bcd']
	expected := ['value1', 'value3', 'value4']

	for i, key in remaining {
		value := rt.search(key)!
		assert value.bytestr() == expected[i]
	}

	// Verify deleted keys return error
	deleted := ['abcd', 'bcde']
	for key in deleted {
		if _ := rt.search(key) {
			assert false, 'Expected error for deleted key: ${key}'
		}
	}
}
