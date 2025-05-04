module tst

// Test serialization and deserialization of nodes
fn test_node_serialization() {
	// Create a leaf node (end of string)
	leaf_node := Node{
		character:        `a`
		is_end_of_string: true
		value:            'test value'.bytes()
		left_id:          0
		middle_id:        0
		right_id:         0
	}

	// Serialize the leaf node
	leaf_data := serialize_node(leaf_node)

	// Deserialize and verify
	deserialized_leaf := deserialize_node(leaf_data) or {
		assert false, 'Failed to deserialize leaf node: ${err}'
		return
	}

	assert deserialized_leaf.character == leaf_node.character, 'Character mismatch'
	assert deserialized_leaf.is_end_of_string == leaf_node.is_end_of_string, 'is_end_of_string mismatch'
	assert deserialized_leaf.value.bytestr() == leaf_node.value.bytestr(), 'Value mismatch'
	assert deserialized_leaf.left_id == leaf_node.left_id, 'left_id mismatch'
	assert deserialized_leaf.middle_id == leaf_node.middle_id, 'middle_id mismatch'
	assert deserialized_leaf.right_id == leaf_node.right_id, 'right_id mismatch'

	// Create an internal node (not end of string)
	internal_node := Node{
		character:        `b`
		is_end_of_string: false
		value:            []u8{}
		left_id:          10
		middle_id:        20
		right_id:         30
	}

	// Serialize the internal node
	internal_data := serialize_node(internal_node)

	// Deserialize and verify
	deserialized_internal := deserialize_node(internal_data) or {
		assert false, 'Failed to deserialize internal node: ${err}'
		return
	}

	assert deserialized_internal.character == internal_node.character, 'Character mismatch'
	assert deserialized_internal.is_end_of_string == internal_node.is_end_of_string, 'is_end_of_string mismatch'
	assert deserialized_internal.value.len == 0, 'Value should be empty'
	assert deserialized_internal.left_id == internal_node.left_id, 'left_id mismatch'
	assert deserialized_internal.middle_id == internal_node.middle_id, 'middle_id mismatch'
	assert deserialized_internal.right_id == internal_node.right_id, 'right_id mismatch'

	// Create a root node
	root_node := Node{
		character:        0 // null character for root
		is_end_of_string: false
		value:            []u8{}
		left_id:          5
		middle_id:        15
		right_id:         25
	}

	// Serialize the root node
	root_data := serialize_node(root_node)

	// Deserialize and verify
	deserialized_root := deserialize_node(root_data) or {
		assert false, 'Failed to deserialize root node: ${err}'
		return
	}

	assert deserialized_root.character == root_node.character, 'Character mismatch'
	assert deserialized_root.is_end_of_string == root_node.is_end_of_string, 'is_end_of_string mismatch'
	assert deserialized_root.value.len == 0, 'Value should be empty'
	assert deserialized_root.left_id == root_node.left_id, 'left_id mismatch'
	assert deserialized_root.middle_id == root_node.middle_id, 'middle_id mismatch'
	assert deserialized_root.right_id == root_node.right_id, 'right_id mismatch'
}

// Test serialization with special characters and larger values
fn test_special_serialization() {
	// Create a node with special character
	special_node := Node{
		character:        `!` // special character
		is_end_of_string: true
		value:            'special value with spaces and symbols: !@#$%^&*()'.bytes()
		left_id:          42
		middle_id:        99
		right_id:         123
	}

	// Serialize the special node
	special_data := serialize_node(special_node)

	// Deserialize and verify
	deserialized_special := deserialize_node(special_data) or {
		assert false, 'Failed to deserialize special node: ${err}'
		return
	}

	assert deserialized_special.character == special_node.character, 'Character mismatch'
	assert deserialized_special.is_end_of_string == special_node.is_end_of_string, 'is_end_of_string mismatch'
	assert deserialized_special.value.bytestr() == special_node.value.bytestr(), 'Value mismatch'
	assert deserialized_special.left_id == special_node.left_id, 'left_id mismatch'
	assert deserialized_special.middle_id == special_node.middle_id, 'middle_id mismatch'
	assert deserialized_special.right_id == special_node.right_id, 'right_id mismatch'

	// Create a node with a large value
	mut large_value := []u8{len: 1000}
	for i in 0 .. 1000 {
		large_value[i] = u8(i % 256)
	}

	large_node := Node{
		character:        `z`
		is_end_of_string: true
		value:            large_value
		left_id:          1
		middle_id:        2
		right_id:         3
	}

	// Serialize the large node
	large_data := serialize_node(large_node)

	// Deserialize and verify
	deserialized_large := deserialize_node(large_data) or {
		assert false, 'Failed to deserialize large node: ${err}'
		return
	}

	assert deserialized_large.character == large_node.character, 'Character mismatch'
	assert deserialized_large.is_end_of_string == large_node.is_end_of_string, 'is_end_of_string mismatch'
	assert deserialized_large.value.len == large_node.value.len, 'Value length mismatch'

	// Check each byte of the large value
	for i in 0 .. large_node.value.len {
		assert deserialized_large.value[i] == large_node.value[i], 'Value byte mismatch at index ${i}'
	}

	assert deserialized_large.left_id == large_node.left_id, 'left_id mismatch'
	assert deserialized_large.middle_id == large_node.middle_id, 'middle_id mismatch'
	assert deserialized_large.right_id == large_node.right_id, 'right_id mismatch'
}

// Test serialization version handling
fn test_version_handling() {
	// Create a valid node
	valid_node := Node{
		character:        `a`
		is_end_of_string: true
		value:            'test'.bytes()
		left_id:          0
		middle_id:        0
		right_id:         0
	}

	// Serialize the node
	mut valid_data := serialize_node(valid_node)

	// Corrupt the version byte
	valid_data[0] = 99 // Invalid version

	// Attempt to deserialize with invalid version
	deserialize_node(valid_data) or {
		assert err.str().contains('Invalid version byte'), 'Expected version error, got: ${err}'
		return
	}
	assert false, 'Expected error for invalid version byte'
}
