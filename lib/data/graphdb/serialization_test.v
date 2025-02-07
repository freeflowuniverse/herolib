module graphdb

fn test_node_serialization() {
	// Create a test node with all fields populated
	node := Node{
		node_type:  'user'
		properties: {
			'name':  'John Doe'
			'age':   '30'
			'email': 'john@example.com'
		}
		edges_out:  [
			EdgeRef{
				edge_id:   1
				edge_type: 'follows'
			},
			EdgeRef{
				edge_id:   2
				edge_type: 'likes'
			},
		]
		edges_in:   [
			EdgeRef{
				edge_id:   3
				edge_type: 'followed_by'
			},
		]
	}

	// Serialize the node
	serialized := serialize_node(node)

	// Deserialize back to node
	deserialized := deserialize_node(serialized) or {
		assert false, 'Failed to deserialize node: ${err}'
		Node{}
	}

	// Verify all fields match
	assert deserialized.node_type == node.node_type, 'node_type mismatch'
	assert deserialized.properties.len == node.properties.len, 'properties length mismatch'
	for key, value in node.properties {
		assert deserialized.properties[key] == value, 'property ${key} mismatch'
	}
	assert deserialized.edges_out.len == node.edges_out.len, 'edges_out length mismatch'
	for i, edge in node.edges_out {
		assert deserialized.edges_out[i].edge_id == edge.edge_id, 'edge_out ${i} id mismatch'
		assert deserialized.edges_out[i].edge_type == edge.edge_type, 'edge_out ${i} type mismatch'
	}
	assert deserialized.edges_in.len == node.edges_in.len, 'edges_in length mismatch'
	for i, edge in node.edges_in {
		assert deserialized.edges_in[i].edge_id == edge.edge_id, 'edge_in ${i} id mismatch'
		assert deserialized.edges_in[i].edge_type == edge.edge_type, 'edge_in ${i} type mismatch'
	}
}

fn test_edge_serialization() {
	// Create a test edge with all fields populated
	edge := Edge{
		from_node:  1
		to_node:    2
		edge_type:  'follows'
		weight:     5
		properties: {
			'created_at': '2024-01-31'
			'active':     'true'
		}
	}

	// Serialize the edge
	serialized := serialize_edge(edge)

	// Deserialize back to edge
	deserialized := deserialize_edge(serialized) or {
		assert false, 'Failed to deserialize edge: ${err}'
		Edge{}
	}

	// Verify all fields match
	assert deserialized.from_node == edge.from_node, 'from_node mismatch'
	assert deserialized.to_node == edge.to_node, 'to_node mismatch'
	assert deserialized.edge_type == edge.edge_type, 'edge_type mismatch'
	assert deserialized.weight == edge.weight, 'weight mismatch'
	assert deserialized.properties.len == edge.properties.len, 'properties length mismatch'
	for key, value in edge.properties {
		assert deserialized.properties[key] == value, 'property ${key} mismatch'
	}
}

fn test_node_serialization_empty() {
	// Test with empty node
	node := Node{
		node_type:  ''
		properties: map[string]string{}
		edges_out:  []EdgeRef{}
		edges_in:   []EdgeRef{}
	}

	serialized := serialize_node(node)
	deserialized := deserialize_node(serialized) or {
		assert false, 'Failed to deserialize empty node: ${err}'
		Node{}
	}

	assert deserialized.node_type == '', 'empty node_type mismatch'
	assert deserialized.properties.len == 0, 'empty properties mismatch'
	assert deserialized.edges_out.len == 0, 'empty edges_out mismatch'
	assert deserialized.edges_in.len == 0, 'empty edges_in mismatch'
}

fn test_edge_serialization_empty() {
	// Test with empty edge
	edge := Edge{
		from_node:  0
		to_node:    0
		edge_type:  ''
		weight:     0
		properties: map[string]string{}
	}

	serialized := serialize_edge(edge)
	deserialized := deserialize_edge(serialized) or {
		assert false, 'Failed to deserialize empty edge: ${err}'
		Edge{}
	}

	assert deserialized.from_node == 0, 'empty from_node mismatch'
	assert deserialized.to_node == 0, 'empty to_node mismatch'
	assert deserialized.edge_type == '', 'empty edge_type mismatch'
	assert deserialized.weight == 0, 'empty weight mismatch'
	assert deserialized.properties.len == 0, 'empty properties mismatch'
}

fn test_version_compatibility() {
	// Test version checking
	node := Node{
		node_type: 'test'
	}
	mut serialized := serialize_node(node)

	// Modify version byte to invalid version
	serialized[0] = 99

	// Should fail with version error
	deserialize_node(serialized) or {
		assert err.msg().contains('Unsupported version'), 'Expected version error'
		return
	}
	assert false, 'Expected error for invalid version'
}

fn test_large_property_values() {
	// Create a large string that's bigger than the slice bounds we're seeing in the error (20043)
	mut large_value := ''
	for _ in 0 .. 25000 {
		large_value += 'x'
	}

	// Create a node with the large property value
	node := Node{
		node_type:  'test'
		properties: {
			'large_prop': large_value
		}
	}

	// Serialize and deserialize
	serialized := serialize_node(node)
	deserialized := deserialize_node(serialized) or {
		assert false, 'Failed to deserialize node with large property: ${err}'
		Node{}
	}

	// Verify the large property was preserved
	assert deserialized.properties['large_prop'] == large_value, 'large property value mismatch'
}

fn test_data_validation() {
	// Test with invalid data
	invalid_data := []u8{}
	deserialize_node(invalid_data) or {
		assert err.msg().contains('too short'), 'Expected data length error'
		return
	}
	assert false, 'Expected error for empty data'

	// Test with truncated data
	node := Node{
		node_type:  'test'
		properties: {
			'key': 'value'
		}
	}
	serialized := serialize_node(node)
	truncated := serialized[..serialized.len / 2]

	deserialize_node(truncated) or {
		assert err.msg().contains('Invalid'), 'Expected truncation error'
		return
	}
	assert false, 'Expected error for truncated data'
}
