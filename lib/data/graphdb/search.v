module graphdb

// SearchConfig represents the configuration for graph traversal search
pub struct SearchConfig {
pub mut:
	types        []string // List of node types to search for
	max_distance f32      // Maximum distance to traverse using edge weights
}

// SearchResult represents a node found during search with its distance from start
pub struct SearchResult {
pub:
	node     &Node
	distance f32
}

// search performs a breadth-first traversal from a start node
// Returns nodes of specified types within max_distance
pub fn (mut gdb GraphDB) search(start_id u32, config SearchConfig) ![]SearchResult {
	mut results := []SearchResult{}
	mut visited := map[u32]f32{} // Maps node ID to shortest distance found
	mut queue := []u32{cap: 100} // Queue of node IDs to visit

	// Start from the given node
	queue << start_id
	visited[start_id] = 0

	// Process nodes in queue
	for queue.len > 0 {
		current_id := queue[0]
		queue.delete(0)

		current_distance := visited[current_id]
		if current_distance > config.max_distance {
			continue
		}

		// Get current node
		current_node := gdb.get_node(current_id)!

		// Add to results if node type matches search criteria
		if config.types.len == 0 || current_node.node_type in config.types {
			results << SearchResult{
				node:     &current_node
				distance: current_distance
			}
		}

		// Process outgoing edges
		for edge_ref in current_node.edges_out {
			edge := gdb.get_edge(edge_ref.edge_id)!
			next_id := edge.to_node

			// Calculate new distance using edge weight
			weight := if edge.weight == 0 { f32(1) } else { f32(edge.weight) }
			new_distance := current_distance + weight

			// Skip if we've found a shorter path or would exceed max distance
			if new_distance > config.max_distance {
				continue
			}
			if next_distance := visited[next_id] {
				if new_distance >= next_distance {
					continue
				}
			}

			// Add to queue and update distance
			queue << next_id
			visited[next_id] = new_distance
		}

		// Process incoming edges
		for edge_ref in current_node.edges_in {
			edge := gdb.get_edge(edge_ref.edge_id)!
			next_id := edge.from_node

			// Calculate new distance using edge weight
			weight := if edge.weight == 0 { f32(1) } else { f32(edge.weight) }
			new_distance := current_distance + weight

			// Skip if we've found a shorter path or would exceed max distance
			if new_distance > config.max_distance {
				continue
			}
			if next_distance := visited[next_id] {
				if new_distance >= next_distance {
					continue
				}
			}

			// Add to queue and update distance
			queue << next_id
			visited[next_id] = new_distance
		}
	}

	return results
}
