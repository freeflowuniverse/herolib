module graphdb

// Gets detailed information about a node
pub fn (mut gdb GraphDB) debug_node(id u32) !string {
	node := gdb.get_node(id)!

	mut info := '\nNode Details (ID: ${id})\n'
	info += '===================\n'

	// Properties
	info += '\nProperties:\n'
	if node.properties.len == 0 {
		info += '  (none)\n'
	} else {
		for key, value in node.properties {
			info += '  ${key}: ${value}\n'
		}
	}

	// Outgoing edges
	info += '\nOutgoing Edges:\n'
	if node.edges_out.len == 0 {
		info += '  (none)\n'
	} else {
		for edge_ref in node.edges_out {
			edge := gdb.get_edge(edge_ref.edge_id)!
			target := gdb.get_node(edge.to_node)!
			info += '  -[${edge_ref.edge_type}]-> Node(${edge.to_node})'
			if name := target.properties['name'] {
				info += ' (${name})'
			}
			if edge.properties.len > 0 {
				info += ' {'
				mut first := true
				for key, value in edge.properties {
					if !first {
						info += ', '
					}
					info += '${key}: ${value}'
					first = false
				}
				info += '}'
			}
			info += '\n'
		}
	}

	// Incoming edges
	info += '\nIncoming Edges:\n'
	if node.edges_in.len == 0 {
		info += '  (none)\n'
	} else {
		for edge_ref in node.edges_in {
			edge := gdb.get_edge(edge_ref.edge_id)!
			source := gdb.get_node(edge.from_node)!
			info += '  <-[${edge_ref.edge_type}]- Node(${edge.from_node})'
			if name := source.properties['name'] {
				info += ' (${name})'
			}
			if edge.properties.len > 0 {
				info += ' {'
				mut first := true
				for key, value in edge.properties {
					if !first {
						info += ', '
					}
					info += '${key}: ${value}'
					first = false
				}
				info += '}'
			}
			info += '\n'
		}
	}

	return info
}

// Gets detailed information about an edge
pub fn (mut gdb GraphDB) debug_edge(id u32) !string {
	edge := gdb.get_edge(id)!
	from_node := gdb.get_node(edge.from_node)!
	to_node := gdb.get_node(edge.to_node)!

	mut info := '\nEdge Details (ID: ${id})\n'
	info += '===================\n'

	// Basic info
	info += '\nType: ${edge.edge_type}\n'

	// Connected nodes
	info += '\nFrom Node (ID: ${edge.from_node}):\n'
	if name := from_node.properties['name'] {
		info += '  name: ${name}\n'
	}
	for key, value in from_node.properties {
		if key != 'name' {
			info += '  ${key}: ${value}\n'
		}
	}

	info += '\nTo Node (ID: ${edge.to_node}):\n'
	if name := to_node.properties['name'] {
		info += '  name: ${name}\n'
	}
	for key, value in to_node.properties {
		if key != 'name' {
			info += '  ${key}: ${value}\n'
		}
	}

	// Edge properties
	info += '\nProperties:\n'
	if edge.properties.len == 0 {
		info += '  (none)\n'
	} else {
		for key, value in edge.properties {
			info += '  ${key}: ${value}\n'
		}
	}

	return info
}

// Prints the current state of the database
pub fn (mut gdb GraphDB) debug_db() ! {
	mut next_id := gdb.db.get_next_id()!

	println('\nGraph Database State')
	println('===================')

	// Print all nodes
	println('\nNodes:')
	println('------')
	for id := u32(0); id < next_id; id++ {
		if node_data := gdb.db.get(id) {
			if node := deserialize_node(node_data) {
				mut node_info := 'Node(${id})'
				if name := node.properties['name'] {
					node_info += ' (${name})'
				}
				node_info += ' - Properties: ${node.properties.len}, Out Edges: ${node.edges_out.len}, In Edges: ${node.edges_in.len}'
				println(node_info)
			}
		}
	}

	// Print all edges
	println('\nEdges:')
	println('------')
	for id := u32(0); id < next_id; id++ {
		if edge_data := gdb.db.get(id) {
			if edge := deserialize_edge(edge_data) {
				mut from_name := ''
				mut to_name := ''

				if from_node := gdb.get_node(edge.from_node) {
					if name := from_node.properties['name'] {
						from_name = ' (${name})'
					}
				}

				if to_node := gdb.get_node(edge.to_node) {
					if name := to_node.properties['name'] {
						to_name = ' (${name})'
					}
				}

				mut edge_info := 'Edge(${id}): Node(${edge.from_node})${from_name} -[${edge.edge_type}]-> Node(${edge.to_node})${to_name}'
				if edge.properties.len > 0 {
					edge_info += ' {'
					mut first := true
					for key, value in edge.properties {
						if !first {
							edge_info += ', '
						}
						edge_info += '${key}: ${value}'
						first = false
					}
					edge_info += '}'
				}
				println(edge_info)
			}
		}
	}
}

// Prints a visual representation of the graph starting from a given node
pub fn (mut gdb GraphDB) print_graph_from(start_id u32, visited map[u32]bool) ! {
	if start_id in visited {
		return
	}

	mut my_visited := visited.clone()
	my_visited[start_id] = true

	node := gdb.get_node(start_id)!

	mut node_info := 'Node(${start_id})'
	if name := node.properties['name'] {
		node_info += ' (${name})'
	}
	println(node_info)

	// Print outgoing edges and recurse
	for edge_ref in node.edges_out {
		edge := gdb.get_edge(edge_ref.edge_id)!
		mut edge_info := '  -[${edge.edge_type}]->'

		if edge.properties.len > 0 {
			edge_info += ' {'
			mut first := true
			for key, value in edge.properties {
				if !first {
					edge_info += ', '
				}
				edge_info += '${key}: ${value}'
				first = false
			}
			edge_info += '}'
		}

		println(edge_info)
		gdb.print_graph_from(edge.to_node, my_visited)!
	}
}

// Prints a visual representation of the entire graph
pub fn (mut gdb GraphDB) print_graph() ! {
	println('\nGraph Structure')
	println('===============')

	mut visited := map[u32]bool{}
	mut next_id := gdb.db.get_next_id()!

	// Start from each unvisited node to handle disconnected components
	for id := u32(0); id < next_id; id++ {
		if id !in visited {
			if node_data := gdb.db.get(id) {
				if _ := deserialize_node(node_data) {
					gdb.print_graph_from(id, visited)!
				}
			}
		}
	}
}
