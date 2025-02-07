module radixtree

fn test_serialize_deserialize() {
	// Create a test node with children
	node := Node{
		key_segment: 'test'
		value:       'hello world'.bytes()
		children:    [
			NodeRef{
				key_part: 'child1'
				node_id:  1
			},
			NodeRef{
				key_part: 'child2'
				node_id:  2
			},
		]
		is_leaf:     true
	}

	// Serialize
	data := serialize_node(node)

	// Verify version byte
	assert data[0] == version

	// Deserialize
	decoded := deserialize_node(data)!

	// Verify all fields match
	assert decoded.key_segment == node.key_segment
	assert decoded.value == node.value
	assert decoded.is_leaf == node.is_leaf
	assert decoded.children.len == node.children.len

	// Verify children
	assert decoded.children[0].key_part == node.children[0].key_part
	assert decoded.children[0].node_id == node.children[0].node_id
	assert decoded.children[1].key_part == node.children[1].key_part
	assert decoded.children[1].node_id == node.children[1].node_id
}

fn test_empty_node() {
	// Test node with empty values
	node := Node{
		key_segment: ''
		value:       []u8{}
		children:    []NodeRef{}
		is_leaf:     false
	}

	data := serialize_node(node)
	decoded := deserialize_node(data)!

	assert decoded.key_segment == node.key_segment
	assert decoded.value == node.value
	assert decoded.children == node.children
	assert decoded.is_leaf == node.is_leaf
}

fn test_large_values() {
	// Create large test data
	mut large_value := []u8{len: 1000, init: u8(index & 0xFF)}
	mut children := []NodeRef{cap: 100}
	for i in 0 .. 100 {
		children << NodeRef{
			key_part: 'child${i}'
			node_id:  u32(i)
		}
	}

	node := Node{
		key_segment: 'large_test'
		value:       large_value
		children:    children
		is_leaf:     true
	}

	data := serialize_node(node)
	decoded := deserialize_node(data)!

	assert decoded.key_segment == node.key_segment
	assert decoded.value == node.value
	assert decoded.children.len == node.children.len

	// Verify some random children
	assert decoded.children[0] == node.children[0]
	assert decoded.children[50] == node.children[50]
	assert decoded.children[99] == node.children[99]
}

fn test_invalid_version() {
	node := Node{
		key_segment: 'test'
		value:       []u8{}
		children:    []NodeRef{}
		is_leaf:     false
	}

	mut data := serialize_node(node)
	// Corrupt version byte
	data[0] = 255

	// Should return error for version mismatch
	if result := deserialize_node(data) {
		assert false, 'Expected error for invalid version byte'
	} else {
		assert err.msg() == 'Invalid version byte: expected ${version}, got 255'
	}
}
