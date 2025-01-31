module graphdb

import freeflowuniverse.herolib.data.ourdb

// Node represents a vertex in the graph with properties and edge references
pub struct Node {
pub mut:
	id         u32                // Unique identifier
	properties map[string]string  // Key-value properties
	edges_out  []EdgeRef         // Outgoing edge references
	edges_in   []EdgeRef         // Incoming edge references
}

// Edge represents a connection between nodes with properties
pub struct Edge {
pub mut:
	id         u32                // Unique identifier
	from_node  u32                // Source node ID
	to_node    u32                // Target node ID
	edge_type  string             // Type of relationship
	properties map[string]string  // Key-value properties
}

// EdgeRef is a lightweight reference to an edge
pub struct EdgeRef {
pub mut:
	edge_id    u32    // Database ID of the edge
	edge_type  string // Type of the edge relationship
}

// GraphDB represents the graph database
pub struct GraphDB {
mut:
	db &ourdb.OurDB // Database for persistent storage
}

pub struct NewArgs {
pub mut:
	path  string
	reset bool
}

// Creates a new graph database instance
pub fn new(args NewArgs) !&GraphDB {
	mut db := ourdb.new(
		path: args.path
		record_size_max: 1024 * 4 // 4KB max record size
		incremental_mode: true
		reset: args.reset
	)!

	return &GraphDB{
		db: &db
	}
}

// Creates a new node with the given properties
pub fn (mut gdb GraphDB) create_node(properties map[string]string) !u32 {
	node := Node{
		properties: properties
		edges_out: []EdgeRef{}
		edges_in: []EdgeRef{}
	}
	
	node_id := gdb.db.set(data: serialize_node(node))!
	return node_id
}

// Creates an edge between two nodes
pub fn (mut gdb GraphDB) create_edge(from_id u32, to_id u32, edge_type string, properties map[string]string) !u32 {
	// Create the edge
	edge := Edge{
		from_node: from_id
		to_node: to_id
		edge_type: edge_type
		properties: properties
	}
	edge_id := gdb.db.set(data: serialize_edge(edge))!

	// Update source node's outgoing edges
	mut from_node := deserialize_node(gdb.db.get(from_id)!)!
	from_node.edges_out << EdgeRef{
		edge_id: edge_id
		edge_type: edge_type
	}
	gdb.db.set(id: from_id, data: serialize_node(from_node))!

	// Update target node's incoming edges
	mut to_node := deserialize_node(gdb.db.get(to_id)!)!
	to_node.edges_in << EdgeRef{
		edge_id: edge_id
		edge_type: edge_type
	}
	gdb.db.set(id: to_id, data: serialize_node(to_node))!

	return edge_id
}

// Gets a node by its ID
pub fn (mut gdb GraphDB) get_node(id u32) !Node {
	node_data := gdb.db.get(id)!
	return deserialize_node(node_data)!
}

// Gets an edge by its ID
pub fn (mut gdb GraphDB) get_edge(id u32) !Edge {
	edge_data := gdb.db.get(id)!
	return deserialize_edge(edge_data)!
}

// Updates a node's properties
pub fn (mut gdb GraphDB) update_node(id u32, properties map[string]string) ! {
	mut node := deserialize_node(gdb.db.get(id)!)!
	node.properties = properties.clone()
	gdb.db.set(id: id, data: serialize_node(node))!
}

// Updates an edge's properties
pub fn (mut gdb GraphDB) update_edge(id u32, properties map[string]string) ! {
	mut edge := deserialize_edge(gdb.db.get(id)!)!
	edge.properties = properties.clone()
	gdb.db.set(id: id, data: serialize_edge(edge))!
}

// Deletes a node and all its edges
pub fn (mut gdb GraphDB) delete_node(id u32) ! {
	node := deserialize_node(gdb.db.get(id)!)!
	
	// Delete outgoing edges
	for edge_ref in node.edges_out {
		gdb.delete_edge(edge_ref.edge_id)!
	}

	// Delete incoming edges
	for edge_ref in node.edges_in {
		gdb.delete_edge(edge_ref.edge_id)!
	}

	// Delete the node itself
	gdb.db.delete(id)!
}

// Deletes an edge and updates connected nodes
pub fn (mut gdb GraphDB) delete_edge(id u32) ! {
	edge := deserialize_edge(gdb.db.get(id)!)!

	// Update source node
	mut from_node := deserialize_node(gdb.db.get(edge.from_node)!)!
	for i, edge_ref in from_node.edges_out {
		if edge_ref.edge_id == id {
			from_node.edges_out.delete(i)
			break
		}
	}
	gdb.db.set(id: edge.from_node, data: serialize_node(from_node))!

	// Update target node
	mut to_node := deserialize_node(gdb.db.get(edge.to_node)!)!
	for i, edge_ref in to_node.edges_in {
		if edge_ref.edge_id == id {
			to_node.edges_in.delete(i)
			break
		}
	}
	gdb.db.set(id: edge.to_node, data: serialize_node(to_node))!

	// Delete the edge itself
	gdb.db.delete(id)!
}

// Queries nodes by property value
pub fn (mut gdb GraphDB) query_nodes_by_property(key string, value string) ![]Node {
	mut nodes := []Node{}
	mut next_id := gdb.db.get_next_id()!

	for id := u32(0); id < next_id; id++ {
		if node_data := gdb.db.get(id) {
			if node := deserialize_node(node_data) {
				if node.properties[key] == value {
					nodes << node
				}
			}
		}
	}

	return nodes
}

// Gets all edges between two nodes
pub fn (mut gdb GraphDB) get_edges_between(from_id u32, to_id u32) ![]Edge {
	from_node := deserialize_node(gdb.db.get(from_id)!)!
	mut edges := []Edge{}

	for edge_ref in from_node.edges_out {
		edge := deserialize_edge(gdb.db.get(edge_ref.edge_id)!)!
		if edge.to_node == to_id {
			edges << edge
		}
	}

	return edges
}

// Gets all nodes connected to a given node by edge type
pub fn (mut gdb GraphDB) get_connected_nodes(id u32, edge_type string, direction string) ![]Node {
	node := deserialize_node(gdb.db.get(id)!)!
	mut connected_nodes := []Node{}

	if direction in ['out', 'both'] {
		for edge_ref in node.edges_out {
			if edge_ref.edge_type == edge_type {
				edge := deserialize_edge(gdb.db.get(edge_ref.edge_id)!)!
				connected_nodes << deserialize_node(gdb.db.get(edge.to_node)!)!
			}
		}
	}

	if direction in ['in', 'both'] {
		for edge_ref in node.edges_in {
			if edge_ref.edge_type == edge_type {
				edge := deserialize_edge(gdb.db.get(edge_ref.edge_id)!)!
				connected_nodes << deserialize_node(gdb.db.get(edge.from_node)!)!
			}
		}
	}

	return connected_nodes
}
