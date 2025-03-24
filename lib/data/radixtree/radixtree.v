module radixtree

import freeflowuniverse.herolib.data.ourdb
// import freeflowuniverse.herolib.ui.console

// Represents a node in the radix tree
struct Node {
mut:
	key_segment string    // The segment of the key stored at this node
	value       []u8      // Value stored at this node (empty if not a leaf)
	children    []NodeRef // References to child nodes
	is_leaf     bool      // Whether this node is a leaf node
}

// Reference to a node in the database
struct NodeRef {
mut:
	key_part string // The key segment for this child
	node_id  u32    // Database ID of the node
}

// RadixTree represents a radix tree data structure
@[heap]
pub struct RadixTree {
mut:
	db      &ourdb.OurDB // Database for persistent storage
	root_id u32          // Database ID of the root node
}

pub struct NewArgs {
pub mut:
	path  string
	reset bool
}

// Creates a new radix tree with the specified database path
pub fn new(args NewArgs) !RadixTree {
	mut db := ourdb.new(
		path:             args.path
		record_size_max:  1024 * 4 // 4KB max record size
		incremental_mode: true
		reset:            args.reset
	)!

	mut root_id := u32(1) // First ID in ourdb is now 1 instead of 0
	//console.print_debug('Debug: Initializing root node')
	if db.get_next_id()! == 1 {
		//console.print_debug('Debug: Creating new root node')
		root := Node{
			key_segment: ''
			value:       []u8{}
			children:    []NodeRef{}
			is_leaf:     false
		}
		root_id = db.set(data: serialize_node(root))!
		//console.print_debug('Debug: Created root node with ID ${root_id}')
		assert root_id == 1 // First ID is now 1
	} else {
		//console.print_debug('Debug: Using existing root node')
		root_data := db.get(1)! // Get root node with ID 1
		// root_node := 
		deserialize_node(root_data)!
		//console.print_debug('Debug: Root node has ${root_node.children.len} children')
	}

	return RadixTree{
		db:      &db
		root_id: root_id
	}
}

// Sets a key-value pair in the tree
pub fn (mut rt RadixTree) set(key string, value []u8) ! {
	mut current_id := rt.root_id
	mut offset := 0

	// Handle empty key case
	if key.len == 0 {
		mut root_node := deserialize_node(rt.db.get(current_id)!)!
		root_node.is_leaf = true
		root_node.value = value
		rt.db.set(id: current_id, data: serialize_node(root_node))!
		return
	}

	for offset < key.len {
		mut node := deserialize_node(rt.db.get(current_id)!)!

		// Find matching child
		mut matched_child := -1
		for i, child in node.children {
			if key[offset..].starts_with(child.key_part) {
				matched_child = i
				break
			}
		}

		if matched_child == -1 {
			// No matching child found, create new leaf node
			key_part := key[offset..]
			new_node := Node{
				key_segment: key_part
				value:       value
				children:    []NodeRef{}
				is_leaf:     true
			}
			//console.print_debug('Debug: Creating new leaf node with key_part "${key_part}"')
			new_id := rt.db.set(data: serialize_node(new_node))!
			//console.print_debug('Debug: Created node ID ${new_id}')

			// Create new child reference and update parent node
			//console.print_debug('Debug: Updating parent node ${current_id} to add child reference')

			// Get fresh copy of parent node
			mut parent_node := deserialize_node(rt.db.get(current_id)!)!
			//console.print_debug('Debug: Parent node initially has ${parent_node.children.len} children')

			// Add new child reference
			parent_node.children << NodeRef{
				key_part: key_part
				node_id:  new_id
			}
			//console.print_debug('Debug: Added child reference, now has ${parent_node.children.len} children')

			// Update parent node in DB
			//console.print_debug('Debug: Serializing parent node with ${parent_node.children.len} children')
			parent_data := serialize_node(parent_node)
			//console.print_debug('Debug: Parent data size: ${parent_data.len} bytes')

			// First verify we can deserialize the data correctly
			//console.print_debug('Debug: Verifying serialization...')
			if _ := deserialize_node(parent_data) {
				//console.print_debug('Debug: Serialization test successful - node has ${test_node.children.len} children')
			} else {
				//console.print_debug('Debug: ERROR - Failed to deserialize test data')
				return error('Serialization verification failed')
			}

			// Set with explicit ID to update existing node
			//console.print_debug('Debug: Writing to DB...')
			rt.db.set(id: current_id, data: parent_data)!

			// Verify by reading back and comparing
			//console.print_debug('Debug: Reading back for verification...')
			verify_data := rt.db.get(current_id)!
			verify_node := deserialize_node(verify_data)!
			//console.print_debug('Debug: Verification - node has ${verify_node.children.len} children')

			if verify_node.children.len == 0 {
				//console.print_debug('Debug: ERROR - Node update verification failed!')
				//console.print_debug('Debug: Original node children: ${node.children.len}')
				//console.print_debug('Debug: Parent node children: ${parent_node.children.len}')
				//console.print_debug('Debug: Verified node children: ${verify_node.children.len}')
				//console.print_debug('Debug: Original data size: ${parent_data.len}')
				//console.print_debug('Debug: Verified data size: ${verify_data.len}')
				//console.print_debug('Debug: Data equal: ${verify_data == parent_data}')
				return error('Node update failed - children array is empty')
			}
			return
		}

		child := node.children[matched_child]
		common_prefix := get_common_prefix(key[offset..], child.key_part)

		if common_prefix.len < child.key_part.len {
			// Split existing node
			mut child_node := deserialize_node(rt.db.get(child.node_id)!)!

			// Create new intermediate node
			mut new_node := Node{
				key_segment: child.key_part[common_prefix.len..]
				value:       child_node.value
				children:    child_node.children
				is_leaf:     child_node.is_leaf
			}
			new_id := rt.db.set(data: serialize_node(new_node))!

			// Update current node
			node.children[matched_child] = NodeRef{
				key_part: common_prefix
				node_id:  new_id
			}
			rt.db.set(id: current_id, data: serialize_node(node))!
		}

		if offset + common_prefix.len == key.len {
			// Update value at existing node
			mut child_node := deserialize_node(rt.db.get(child.node_id)!)!
			child_node.value = value
			child_node.is_leaf = true
			rt.db.set(id: child.node_id, data: serialize_node(child_node))!
			return
		}

		offset += common_prefix.len
		current_id = child.node_id
	}
}

// Gets a value by key from the tree
pub fn (mut rt RadixTree) get(key string) ![]u8 {
	mut current_id := rt.root_id
	mut offset := 0

	// Handle empty key case
	if key.len == 0 {
		root_node := deserialize_node(rt.db.get(current_id)!)!
		if root_node.is_leaf {
			return root_node.value
		}
		return error('Key not found')
	}

	for offset < key.len {
		node := deserialize_node(rt.db.get(current_id)!)!

		mut found := false
		for child in node.children {
			if key[offset..].starts_with(child.key_part) {
				if offset + child.key_part.len == key.len {
					child_node := deserialize_node(rt.db.get(child.node_id)!)!
					if child_node.is_leaf {
						return child_node.value
					}
				}
				current_id = child.node_id
				offset += child.key_part.len
				found = true
				break
			}
		}

		if !found {
			return error('Key not found')
		}
	}

	return error('Key not found')
}

// Updates the value at a given key prefix, preserving the prefix while replacing the remainder
pub fn (mut rt RadixTree) update(prefix string, new_value []u8) ! {
	mut current_id := rt.root_id
	mut offset := 0

	// Handle empty prefix case
	if prefix.len == 0 {
		return error('Empty prefix not allowed')
	}

	for offset < prefix.len {
		node := deserialize_node(rt.db.get(current_id)!)!

		mut found := false
		for child in node.children {
			if prefix[offset..].starts_with(child.key_part) {
				if offset + child.key_part.len == prefix.len {
					// Found exact prefix match
					mut child_node := deserialize_node(rt.db.get(child.node_id)!)!
					if child_node.is_leaf {
						// Update the value
						child_node.value = new_value
						rt.db.set(id: child.node_id, data: serialize_node(child_node))!
						return
					}
				}
				current_id = child.node_id
				offset += child.key_part.len
				found = true
				break
			}
		}

		if !found {
			return error('Prefix not found')
		}
	}

	return error('Prefix not found')
}

// Deletes a key from the tree
pub fn (mut rt RadixTree) delete(key string) ! {
	mut current_id := rt.root_id
	mut offset := 0
	mut path := []NodeRef{}

	// Find the node to delete
	for offset < key.len {
		node := deserialize_node(rt.db.get(current_id)!)!

		mut found := false
		for child in node.children {
			if key[offset..].starts_with(child.key_part) {
				path << child
				current_id = child.node_id
				offset += child.key_part.len
				found = true

				// Check if we've matched the full key
				if offset == key.len {
					child_node := deserialize_node(rt.db.get(child.node_id)!)!
					if child_node.is_leaf {
						found = true
						break
					}
				}
				break
			}
		}

		if !found {
			return error('Key not found')
		}
	}

	if path.len == 0 {
		return error('Key not found')
	}

	// Get the node to delete
	mut last_node := deserialize_node(rt.db.get(path.last().node_id)!)!

	// If the node has children, just mark it as non-leaf
	if last_node.children.len > 0 {
		last_node.is_leaf = false
		last_node.value = []u8{}
		rt.db.set(id: path.last().node_id, data: serialize_node(last_node))!
		return
	}

	// If node has no children, remove it from parent
	if path.len > 1 {
		mut parent_node := deserialize_node(rt.db.get(path[path.len - 2].node_id)!)!
		for i, child in parent_node.children {
			if child.node_id == path.last().node_id {
				parent_node.children.delete(i)
				break
			}
		}
		rt.db.set(id: path[path.len - 2].node_id, data: serialize_node(parent_node))!
		
		// Delete the node from the database
		rt.db.delete(path.last().node_id)!
	} else {
		// If this is a direct child of the root, just mark it as non-leaf
		last_node.is_leaf = false
		last_node.value = []u8{}
		rt.db.set(id: path.last().node_id, data: serialize_node(last_node))!
	}
}

// Lists all keys with a given prefix
pub fn (mut rt RadixTree) list(prefix string) ![]string {
	mut result := []string{}

	// Handle empty prefix case - will return all keys
	if prefix.len == 0 {
		rt.collect_all_keys(rt.root_id, '', mut result)!
		return result
	}

	// Start from the root and find all matching keys
	rt.find_keys_with_prefix(rt.root_id, '', prefix, mut result)!
	return result
}

// Helper function to find all keys with a given prefix
fn (mut rt RadixTree) find_keys_with_prefix(node_id u32, current_path string, prefix string, mut result []string) ! {
	node := deserialize_node(rt.db.get(node_id)!)!
	
	// If the current path already matches or exceeds the prefix length
	if current_path.len >= prefix.len {
		// Check if the current path starts with the prefix
		if current_path.starts_with(prefix) {
			// If this is a leaf node, add it to the results
			if node.is_leaf {
				result << current_path
			}
			
			// Collect all keys from this subtree
			for child in node.children {
				child_path := current_path + child.key_part
				rt.find_keys_with_prefix(child.node_id, child_path, prefix, mut result)!
			}
		}
		return
	}
	
	// Current path is shorter than the prefix, continue searching
	for child in node.children {
		child_path := current_path + child.key_part
		
		// Check if this child's path could potentially match the prefix
		if prefix.starts_with(current_path) {
			// The prefix starts with the current path, so we need to check if
			// the child's key_part matches the next part of the prefix
			prefix_remainder := prefix[current_path.len..]
			
			// If the prefix remainder starts with the child's key_part or vice versa
			if prefix_remainder.starts_with(child.key_part) || 
			   (child.key_part.starts_with(prefix_remainder) && child.key_part.len >= prefix_remainder.len) {
				rt.find_keys_with_prefix(child.node_id, child_path, prefix, mut result)!
			}
		}
	}
}

// Helper function to recursively collect all keys under a node
fn (mut rt RadixTree) collect_all_keys(node_id u32, current_path string, mut result []string) ! {
	node := deserialize_node(rt.db.get(node_id)!)!
	
	// If this node is a leaf, add its path to the result
	if node.is_leaf {
		result << current_path
	}
	
	// Recursively collect keys from all children
	for child in node.children {
		child_path := current_path + child.key_part
		rt.collect_all_keys(child.node_id, child_path, mut result)!
	}
}

// Helper function to get the common prefix of two strings
// Gets all values for keys with a given prefix
pub fn (mut rt RadixTree) getall(prefix string) ![][]u8 {
	// Get all matching keys
	keys := rt.list(prefix)!
	
	// Get values for each key
	mut values := [][]u8{}
	for key in keys {
		if value := rt.get(key) {
			values << value
		}
	}
	
	return values
}

// Helper function to get the common prefix of two strings
fn get_common_prefix(a string, b string) string {
	mut i := 0
	for i < a.len && i < b.len && a[i] == b[i] {
		i++
	}
	return a[..i]
}
