module graphdb

import encoding.binary
import math

// Serializes a Node struct to bytes
fn serialize_node(node Node) []u8 {
	mut data := []u8{}

	// Serialize properties
	data << u32_to_bytes(u32(node.properties.len)) // Number of properties
	for key, value in node.properties {
		// Key length and bytes
		data << u32_to_bytes(u32(key.len))
		data << key.bytes()
		// Value length and bytes
		data << u32_to_bytes(u32(value.len))
		data << value.bytes()
	}

	// Serialize outgoing edges
	data << u32_to_bytes(u32(node.edges_out.len)) // Number of outgoing edges
	for edge in node.edges_out {
		data << u32_to_bytes(edge.edge_id)
		data << u32_to_bytes(u32(edge.edge_type.len))
		data << edge.edge_type.bytes()
	}

	// Serialize incoming edges
	data << u32_to_bytes(u32(node.edges_in.len)) // Number of incoming edges
	for edge in node.edges_in {
		data << u32_to_bytes(edge.edge_id)
		data << u32_to_bytes(u32(edge.edge_type.len))
		data << edge.edge_type.bytes()
	}

	return data
}

// Deserializes bytes to a Node struct
fn deserialize_node(data []u8) !Node {
	if data.len < 4 {
		return error('Invalid node data: too short')
	}

	mut offset := 0
	mut node := Node{
		properties: map[string]string{}
		edges_out: []EdgeRef{}
		edges_in: []EdgeRef{}
	}

	// Deserialize properties
	mut end_pos := int(offset) + 4
	if end_pos > data.len {
		return error('Invalid node data: truncated properties count')
	}
	num_properties := bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	for _ in 0 .. num_properties {
		// Read key
		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid node data: truncated property key length')
		}
		key_len := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + int(key_len)
		if end_pos > data.len {
			return error('Invalid node data: truncated property key')
		}
		key := data[offset..end_pos].bytestr()
		offset = end_pos

		// Read value
		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid node data: truncated property value length')
		}
		value_len := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + int(value_len)
		if end_pos > data.len {
			return error('Invalid node data: truncated property value')
		}
		value := data[offset..end_pos].bytestr()
		offset = end_pos

		node.properties[key] = value
	}

	// Deserialize outgoing edges
	end_pos = int(offset) + 4
	if end_pos > data.len {
		return error('Invalid node data: truncated outgoing edges count')
	}
	num_edges_out := bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	for _ in 0 .. num_edges_out {
		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid node data: truncated edge ID')
		}
		edge_id := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid node data: truncated edge type length')
		}
		type_len := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + int(type_len)
		if end_pos > data.len {
			return error('Invalid node data: truncated edge type')
		}
		edge_type := data[offset..end_pos].bytestr()
		offset = end_pos

		node.edges_out << EdgeRef{
			edge_id: edge_id
			edge_type: edge_type
		}
	}

	// Deserialize incoming edges
	end_pos = int(offset) + 4
	if end_pos > data.len {
		return error('Invalid node data: truncated incoming edges count')
	}
	num_edges_in := bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	for _ in 0 .. num_edges_in {
		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid node data: truncated edge ID')
		}
		edge_id := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid node data: truncated edge type length')
		}
		type_len := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + int(type_len)
		if end_pos > data.len {
			return error('Invalid node data: truncated edge type')
		}
		edge_type := data[offset..end_pos].bytestr()
		offset = end_pos

		node.edges_in << EdgeRef{
			edge_id: edge_id
			edge_type: edge_type
		}
	}

	return node
}

// Serializes an Edge struct to bytes
fn serialize_edge(edge Edge) []u8 {
	mut data := []u8{}

	// Serialize edge metadata
	data << u32_to_bytes(edge.from_node)
	data << u32_to_bytes(edge.to_node)
	data << u32_to_bytes(u32(edge.edge_type.len))
	data << edge.edge_type.bytes()

	// Serialize properties
	data << u32_to_bytes(u32(edge.properties.len))
	for key, value in edge.properties {
		data << u32_to_bytes(u32(key.len))
		data << key.bytes()
		data << u32_to_bytes(u32(value.len))
		data << value.bytes()
	}

	return data
}

// Deserializes bytes to an Edge struct
fn deserialize_edge(data []u8) !Edge {
	if data.len < 12 {
		return error('Invalid edge data: too short')
	}

	mut offset := 0
	mut edge := Edge{
		properties: map[string]string{}
	}

	// Deserialize edge metadata
	mut end_pos := int(offset) + 4
	if end_pos > data.len {
		return error('Invalid edge data: truncated from_node')
	}
	edge.from_node = bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	end_pos = int(offset) + 4
	if end_pos > data.len {
		return error('Invalid edge data: truncated to_node')
	}
	edge.to_node = bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	end_pos = int(offset) + 4
	if end_pos > data.len {
		return error('Invalid edge data: truncated type length')
	}
	type_len := bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	end_pos = int(offset) + int(type_len)
	if end_pos > data.len {
		return error('Invalid edge data: truncated edge type')
	}
	edge.edge_type = data[offset..end_pos].bytestr()
	offset = end_pos

	// Deserialize properties
	end_pos = int(offset) + 4
	if end_pos > data.len {
		return error('Invalid edge data: truncated properties count')
	}
	num_properties := bytes_to_u32(data[offset..end_pos])
	offset = end_pos

	for _ in 0 .. num_properties {
		// Read key
		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid edge data: truncated property key length')
		}
		key_len := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + int(key_len)
		if end_pos > data.len {
			return error('Invalid edge data: truncated property key')
		}
		key := data[offset..end_pos].bytestr()
		offset = end_pos

		// Read value
		end_pos = int(offset) + 4
		if end_pos > data.len {
			return error('Invalid edge data: truncated property value length')
		}
		value_len := bytes_to_u32(data[offset..end_pos])
		offset = end_pos

		end_pos = int(offset) + int(value_len)
		if end_pos > data.len {
			return error('Invalid edge data: truncated property value')
		}
		value := data[offset..end_pos].bytestr()
		offset = end_pos

		edge.properties[key] = value
	}

	return edge
}

// Helper function to convert u32 to bytes
fn u32_to_bytes(n u32) []u8 {
	mut bytes := []u8{len: 4}
	binary.little_endian_put_u32(mut bytes, n)
	return bytes
}

// Helper function to convert bytes to u32
fn bytes_to_u32(data []u8) u32 {
	return binary.little_endian_u32(data)
}
