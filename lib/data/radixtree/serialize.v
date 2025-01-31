module radixtree

import freeflowuniverse.herolib.data.encoder

const (
	version = u8(1) // Current binary format version
)

// Serializes a node to bytes for storage
fn serialize_node(node Node) []u8 {
	mut e := encoder.new()
	
	// Add version byte
	e.add_u8(version)
	
	// Add key segment
	e.add_string(node.key_segment)
	
	// Add value as []u8
	e.add_u16(u16(node.value.len))
	e.data << node.value
	
	// Add children
	e.add_u16(u16(node.children.len))
	for child in node.children {
		e.add_string(child.key_part)
		e.add_u32(child.node_id)
	}
	
	// Add leaf flag
	e.add_u8(if node.is_leaf { u8(1) } else { u8(0) })
	
	return e.data
}

// Deserializes bytes to a node
fn deserialize_node(data []u8) !Node {
	mut d := encoder.decoder_new(data)
	
	// Read and verify version
	version_byte := d.get_u8()
	if version_byte != version {
		return error('Invalid version byte: expected ${version}, got ${version_byte}')
	}
	
	// Read key segment
	key_segment := d.get_string()
	
	// Read value as []u8
	value_len := d.get_u16()
	mut value := []u8{len: int(value_len)}
	for i in 0..int(value_len) {
		value[i] = d.get_u8()
	}
	
	// Read children
	children_len := d.get_u16()
	mut children := []NodeRef{cap: int(children_len)}
	for _ in 0 .. children_len {
		key_part := d.get_string()
		node_id := d.get_u32()
		children << NodeRef{
			key_part: key_part
			node_id: node_id
		}
	}
	
	// Read leaf flag
	is_leaf := d.get_u8() == 1
	
	return Node{
		key_segment: key_segment
		value: value
		children: children
		is_leaf: is_leaf
	}
}
