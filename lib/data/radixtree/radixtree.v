module radixtree

import freeflowuniverse.herolib.data.ourdb

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
pub fn new(args NewArgs) !&RadixTree {
	mut db := ourdb.new(
		path:             args.path
		record_size_max:  1024 * 4 // 4KB max record size
		incremental_mode: true
		reset:            args.reset
	)!

	mut root_id := u32(0)
	println('Debug: Initializing root node')
	if db.get_next_id()! == 0 {
		println('Debug: Creating new root node')
		root := Node{
			key_segment: ''
			value:       []u8{}
			children:    []NodeRef{}
			is_leaf:     false
		}
		root_id = db.set(data: serialize_node(root))!
		println('Debug: Created root node with ID ${root_id}')
		assert root_id == 0
	} else {
		println('Debug: Using existing root node')
		root_data := db.get(0)!
		root_node := deserialize_node(root_data)!
		println('Debug: Root node has ${root_node.children.len} children')
	}

	return &RadixTree{
		db:      &db
		root_id: root_id
	}
}

// Inserts a key-value pair into the tree
pub fn (mut rt RadixTree) insert(key string, value []u8) ! {
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
			println('Debug: Creating new leaf node with key_part "${key_part}"')
			new_id := rt.db.set(data: serialize_node(new_node))!
			println('Debug: Created node ID ${new_id}')

			// Create new child reference and update parent node
			println('Debug: Updating parent node ${current_id} to add child reference')

			// Get fresh copy of parent node
			mut parent_node := deserialize_node(rt.db.get(current_id)!)!
			println('Debug: Parent node initially has ${parent_node.children.len} children')

			// Add new child reference
			parent_node.children << NodeRef{
				key_part: key_part
				node_id:  new_id
			}
			println('Debug: Added child reference, now has ${parent_node.children.len} children')

			// Update parent node in DB
			println('Debug: Serializing parent node with ${parent_node.children.len} children')
			parent_data := serialize_node(parent_node)
			println('Debug: Parent data size: ${parent_data.len} bytes')

			// First verify we can deserialize the data correctly
			println('Debug: Verifying serialization...')
			if test_node := deserialize_node(parent_data) {
				println('Debug: Serialization test successful - node has ${test_node.children.len} children')
			} else {
				println('Debug: ERROR - Failed to deserialize test data')
				return error('Serialization verification failed')
			}

			// Set with explicit ID to update existing node
			println('Debug: Writing to DB...')
			rt.db.set(id: current_id, data: parent_data)!

			// Verify by reading back and comparing
			println('Debug: Reading back for verification...')
			verify_data := rt.db.get(current_id)!
			verify_node := deserialize_node(verify_data)!
			println('Debug: Verification - node has ${verify_node.children.len} children')

			if verify_node.children.len == 0 {
				println('Debug: ERROR - Node update verification failed!')
				println('Debug: Original node children: ${node.children.len}')
				println('Debug: Parent node children: ${parent_node.children.len}')
				println('Debug: Verified node children: ${verify_node.children.len}')
				println('Debug: Original data size: ${parent_data.len}')
				println('Debug: Verified data size: ${verify_data.len}')
				println('Debug: Data equal: ${verify_data == parent_data}')
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

// Searches for a key in the tree
pub fn (mut rt RadixTree) search(key string) ![]u8 {
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

	// Remove the leaf node
	mut last_node := deserialize_node(rt.db.get(path.last().node_id)!)!
	last_node.is_leaf = false
	last_node.value = []u8{}

	// If node has no children, remove it from parent
	if last_node.children.len == 0 {
		if path.len > 1 {
			mut parent_node := deserialize_node(rt.db.get(path[path.len - 2].node_id)!)!
			for i, child in parent_node.children {
				if child.node_id == path.last().node_id {
					parent_node.children.delete(i)
					break
				}
			}
			rt.db.set(id: path[path.len - 2].node_id, data: serialize_node(parent_node))!
		}
	} else {
		rt.db.set(id: path.last().node_id, data: serialize_node(last_node))!
	}
}

// Helper function to get the common prefix of two strings
fn get_common_prefix(a string, b string) string {
	mut i := 0
	for i < a.len && i < b.len && a[i] == b[i] {
		i++
	}
	return a[..i]
}
