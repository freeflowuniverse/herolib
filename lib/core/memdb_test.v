module core

fn test_memdb_set_get() {
	// Test basic set/get
	memdb_set('test_key', 'test_value')
	assert memdb_get('test_key') == 'test_value'

	// Test overwriting value
	memdb_set('test_key', 'new_value')
	assert memdb_get('test_key') == 'new_value'

	// Test getting non-existent key
	assert memdb_get('non_existent') == ''
}

fn test_memdb_exists() {
	// Test existing key
	memdb_set('exists_key', 'value')
	assert memdb_exists('exists_key') == true

	// Test non-existing key
	assert memdb_exists('non_existent') == false

	// Test empty value
	memdb_set('empty_key', '')
	assert memdb_exists('empty_key') == false
}

