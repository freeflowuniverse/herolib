module tst

import freeflowuniverse.herolib.data.ourdb

// Represents a node in the ternary search tree
struct Node {
mut:
	character      u8      // The character stored at this nodexs
	is_end_of_string bool    // Flag indicating if this node represents the end of a key
	value          []u8      // The value associated with the key (if this node is the end of a key)
	left_id        u32       // Database ID for left child (character < node.character)
	middle_id      u32       // Database ID for middle child (character == node.character)
	right_id       u32       // Database ID for right child (character > node.character)
}

// TST represents a ternary search tree data structure
@[heap]
pub struct TST {
mut:
	db      &ourdb.OurDB // Database for persistent storage
	root_id u32          // Database ID of the root node
}

@[params]
pub struct NewArgs {
pub mut:
	path  string
	reset bool
}

// Creates a new ternary search tree with the specified database path
pub fn new(args NewArgs) !TST {
	println('Creating new TST with path: ${args.path}, reset: ${args.reset}')
	mut db := ourdb.new(
		path:             args.path
		record_size_max:  1024 * 1024 // 1MB
		incremental_mode: true
		reset:            args.reset
	)!

	mut root_id := u32(1) // First ID in ourdb is now 1 instead of 0
	
	if db.get_next_id()! == 1 {
		// Create a new root node if the database is empty
		// We'll use a null character (0) for the root node
		println('Creating new root node')
		root := Node{
			character:       0
			is_end_of_string: false
			value:           []u8{}
			left_id:         0
			middle_id:       0
			right_id:        0
		}
		root_id = db.set(data: serialize_node(root))!
		println('Root node created with ID: ${root_id}')
		assert root_id == 1 // First ID is now 1
	} else {
		// Database already exists, just get the root node
		println('Database already exists, getting root node')
		root_data := db.get(1)! // Get root node with ID 1
		root := deserialize_node(root_data)!
		println('Root node retrieved: character=${root.character}, is_end=${root.is_end_of_string}, left=${root.left_id}, middle=${root.middle_id}, right=${root.right_id}')
	}

	return TST{
		db:      &db
		root_id: root_id
	}
}

// Sets a key-value pair in the tree
pub fn (mut self TST) set(key string, value []u8) ! {
	println('Setting key: "${key}"')
	if key.len == 0 {
		return error('Empty key not allowed')
	}

	// If the tree is empty, create a root node
	if self.root_id == 0 {
		println('Tree is empty, creating root node')
		root := Node{
			character:       0
			is_end_of_string: false
			value:           []u8{}
			left_id:         0
			middle_id:       0
			right_id:        0
		}
		self.root_id = self.db.set(data: serialize_node(root))!
		println('Root node created with ID: ${self.root_id}')
	}

	self.insert_recursive(self.root_id, key, 0, value)!
	println('Key "${key}" inserted successfully')
}

// Recursive helper function for insertion
fn (mut self TST) insert_recursive(node_id u32, key string, pos int, value []u8) !u32 {
	// If we've reached the end of the tree, create a new node
	if node_id == 0 {
		println('Creating new node for character: ${key[pos]} (${key[pos].ascii_str()}) at position ${pos}')
		new_node := Node{
			character:       key[pos]
			is_end_of_string: pos == key.len - 1
			value:           if pos == key.len - 1 { value } else { []u8{} }
			left_id:         0
			middle_id:       0
			right_id:        0
		}
		new_id := self.db.set(data: serialize_node(new_node))!
		println('New node created with ID: ${new_id}, character: ${key[pos]} (${key[pos].ascii_str()}), is_end: ${pos == key.len - 1}')
		return new_id
	}

	// Get the current node
	mut node := deserialize_node(self.db.get(node_id)!)!
	println('Node ${node_id}: character=${node.character} (${node.character.ascii_str()}), is_end=${node.is_end_of_string}, left=${node.left_id}, middle=${node.middle_id}, right=${node.right_id}')
	
	// Compare the current character with the node's character
	if key[pos] < node.character {
		println('Going left for character: ${key[pos]} (${key[pos].ascii_str()}) < ${node.character} (${node.character.ascii_str()})')
		// Go left
		node.left_id = self.insert_recursive(node.left_id, key, pos, value)!
		self.db.set(id: node_id, data: serialize_node(node))!
	} else if key[pos] > node.character {
		println('Going right for character: ${key[pos]} (${key[pos].ascii_str()}) > ${node.character} (${node.character.ascii_str()})')
		// Go right
		node.right_id = self.insert_recursive(node.right_id, key, pos, value)!
		self.db.set(id: node_id, data: serialize_node(node))!
	} else {
		// Equal - go middle
		if pos == key.len - 1 {
			println('End of key reached, setting is_end_of_string=true')
			// We've reached the end of the key
			node.is_end_of_string = true
			node.value = value
			self.db.set(id: node_id, data: serialize_node(node))!
		} else {
			println('Going middle for next character: ${key[pos+1]} (${key[pos+1].ascii_str()})')
			// Move to the next character in the key
			node.middle_id = self.insert_recursive(node.middle_id, key, pos + 1, value)!
			self.db.set(id: node_id, data: serialize_node(node))!
		}
	}

	return node_id
}

// Gets a value by key from the tree
pub fn (mut self TST) get(key string) ![]u8 {
	println('Getting key: "${key}"')
	if key.len == 0 {
		return error('Empty key not allowed')
	}

	if self.root_id == 0 {
		return error('Tree is empty')
	}

	return self.search_recursive(self.root_id, key, 0)!
}

// Recursive helper function for search
fn (mut self TST) search_recursive(node_id u32, key string, pos int) ![]u8 {
	if node_id == 0 {
		println('Node ID is 0, key not found')
		return error('Key not found')
	}

	node := deserialize_node(self.db.get(node_id)!)!
	println('Searching node ${node_id}: character=${node.character} (${node.character.ascii_str()}), is_end=${node.is_end_of_string}, left=${node.left_id}, middle=${node.middle_id}, right=${node.right_id}, pos=${pos}')
	
	if key[pos] < node.character {
		println('Going left: ${key[pos]} (${key[pos].ascii_str()}) < ${node.character} (${node.character.ascii_str()})')
		// Go left
		return self.search_recursive(node.left_id, key, pos)!
	} else if key[pos] > node.character {
		println('Going right: ${key[pos]} (${key[pos].ascii_str()}) > ${node.character} (${node.character.ascii_str()})')
		// Go right
		return self.search_recursive(node.right_id, key, pos)!
	} else {
		// Equal
		println('Character matches: ${key[pos]} (${key[pos].ascii_str()}) == ${node.character} (${node.character.ascii_str()})')
		if pos == key.len - 1 {
			// We've reached the end of the key
			if node.is_end_of_string {
				println('End of key reached and is_end_of_string=true, returning value')
				return node.value
			} else {
				println('End of key reached but is_end_of_string=false, key not found')
				return error('Key not found')
			}
		} else {
			// Move to the next character in the key
			println('Moving to next character: ${key[pos+1]} (${key[pos+1].ascii_str()})')
			return self.search_recursive(node.middle_id, key, pos + 1)!
		}
	}
}

// Deletes a key from the tree
pub fn (mut self TST) delete(key string) ! {
	println('Deleting key: "${key}"')
	if key.len == 0 {
		return error('Empty key not allowed')
	}

	if self.root_id == 0 {
		return error('Tree is empty')
	}

	self.delete_recursive(self.root_id, key, 0)!
	println('Key "${key}" deleted successfully')
}

// Recursive helper function for deletion
fn (mut self TST) delete_recursive(node_id u32, key string, pos int) !bool {
	if node_id == 0 {
		println('Node ID is 0, key not found')
		return error('Key not found')
	}

	mut node := deserialize_node(self.db.get(node_id)!)!
	println('Deleting from node ${node_id}: character=${node.character} (${node.character.ascii_str()}), is_end=${node.is_end_of_string}, left=${node.left_id}, middle=${node.middle_id}, right=${node.right_id}, pos=${pos}')
	mut deleted := false

	if key[pos] < node.character {
		println('Going left: ${key[pos]} (${key[pos].ascii_str()}) < ${node.character} (${node.character.ascii_str()})')
		// Go left
		deleted = self.delete_recursive(node.left_id, key, pos)!
		if deleted && node.left_id != 0 {
			// Check if the left child has been deleted
			if _ := self.db.get(node.left_id) {
				// Child still exists
				println('Left child still exists')
			} else {
				// Child has been deleted
				println('Left child has been deleted, updating node')
				node.left_id = 0
				self.db.set(id: node_id, data: serialize_node(node))!
			}
		}
	} else if key[pos] > node.character {
		println('Going right: ${key[pos]} (${key[pos].ascii_str()}) > ${node.character} (${node.character.ascii_str()})')
		// Go right
		deleted = self.delete_recursive(node.right_id, key, pos)!
		if deleted && node.right_id != 0 {
			// Check if the right child has been deleted
			if _ := self.db.get(node.right_id) {
				// Child still exists
				println('Right child still exists')
			} else {
				// Child has been deleted
				println('Right child has been deleted, updating node')
				node.right_id = 0
				self.db.set(id: node_id, data: serialize_node(node))!
			}
		}
	} else {
		// Equal
		println('Character matches: ${key[pos]} (${key[pos].ascii_str()}) == ${node.character} (${node.character.ascii_str()})')
		if pos == key.len - 1 {
			// We've reached the end of the key
			if node.is_end_of_string {
				// Found the key
				println('End of key reached and is_end_of_string=true, found the key')
				if node.left_id == 0 && node.middle_id == 0 && node.right_id == 0 {
					// Node has no children, delete it
					println('Node has no children, deleting it')
					self.db.delete(node_id)!
					return true
				} else {
					// Node has children, just mark it as not end of string
					println('Node has children, marking it as not end of string')
					node.is_end_of_string = false
					node.value = []u8{}
					self.db.set(id: node_id, data: serialize_node(node))!
					return false
				}
			} else {
				println('End of key reached but is_end_of_string=false, key not found')
				return error('Key not found')
			}
		} else {
			// Move to the next character in the key
			println('Moving to next character: ${key[pos+1]} (${key[pos+1].ascii_str()})')
			deleted = self.delete_recursive(node.middle_id, key, pos + 1)!
			if deleted && node.middle_id != 0 {
				// Check if the middle child has been deleted
				if _ := self.db.get(node.middle_id) {
					// Child still exists
					println('Middle child still exists')
				} else {
					// Child has been deleted
					println('Middle child has been deleted, updating node')
					node.middle_id = 0
					self.db.set(id: node_id, data: serialize_node(node))!
				}
			}
		}
	}

	// If this node has no children and is not the end of a string, delete it
	if node.left_id == 0 && node.middle_id == 0 && node.right_id == 0 && !node.is_end_of_string {
		println('Node has no children and is not end of string, deleting it')
		self.db.delete(node_id)!
		return true
	}

	return deleted
}

// Lists all keys with a given prefix
pub fn (mut self TST) list(prefix string) ![]string {
	println('Listing keys with prefix: "${prefix}"')
	mut result := []string{}

	// Handle empty prefix case - will return all keys
	if prefix.len == 0 {
		println('Empty prefix, collecting all keys')
		self.collect_all_keys(self.root_id, '', mut result)!
		println('Found ${result.len} keys: ${result}')
		return result
	}

	// Find the node corresponding to the prefix
	println('Finding node for prefix: "${prefix}"')
	
	// Start from the root and traverse to the node corresponding to the last character of the prefix
	mut node_id := self.root_id
	mut pos := 0
	mut current_path := ''
	
	// Traverse the tree to find the node corresponding to the prefix
	for pos < prefix.len && node_id != 0 {
		node := deserialize_node(self.db.get(node_id)!)!
		println('Examining node ${node_id}: character=${node.character} (${node.character.ascii_str()}), is_end=${node.is_end_of_string}, left=${node.left_id}, middle=${node.middle_id}, right=${node.right_id}, pos=${pos}, current_path="${current_path}"')
		
		if prefix[pos] < node.character {
			println('Going left: ${prefix[pos]} (${prefix[pos].ascii_str()}) < ${node.character} (${node.character.ascii_str()})')
			node_id = node.left_id
		} else if prefix[pos] > node.character {
			println('Going right: ${prefix[pos]} (${prefix[pos].ascii_str()}) > ${node.character} (${node.character.ascii_str()})')
			node_id = node.right_id
		} else {
			// Character matches
			println('Character matches: ${prefix[pos]} (${prefix[pos].ascii_str()}) == ${node.character} (${node.character.ascii_str()})')
			
			// Update the current path
			if node.character != 0 { // Skip the root node character
				current_path += node.character.ascii_str()
				println('Updated path: "${current_path}"')
			}
			
			if pos == prefix.len - 1 {
				// We've reached the end of the prefix
				println('Reached end of prefix')
				
				// If this node is the end of a string, add it to the result
				if node.is_end_of_string {
					println('Node is end of string, adding key: "${current_path}"')
					result << current_path
				}
				
				// Collect all keys from the middle child
				if node.middle_id != 0 {
					println('Collecting from middle child with path: "${current_path}"')
					self.collect_keys_with_prefix(node.middle_id, current_path, prefix, mut result)!
				}
				
				break
			} else {
				// Move to the next character in the prefix
				println('Moving to next character in prefix: ${prefix[pos+1]} (${prefix[pos+1].ascii_str()})')
				node_id = node.middle_id
				pos++
			}
		}
	}
	
	if node_id == 0 || pos < prefix.len - 1 {
		// Prefix not found or we didn't reach the end of the prefix
		println('Prefix not found or didn\'t reach end of prefix, returning empty result')
		return []string{}
	}
	
	println('Found ${result.len} keys with prefix "${prefix}": ${result}')
	return result
}

// Helper function to collect all keys with a given prefix
fn (mut self TST) collect_keys_with_prefix(node_id u32, current_path string, prefix string, mut result []string) ! {
	if node_id == 0 {
		return
	}

	node := deserialize_node(self.db.get(node_id)!)!
	println('Collecting keys with prefix from node ${node_id}: character=${node.character} (${node.character.ascii_str()}), is_end=${node.is_end_of_string}, left=${node.left_id}, middle=${node.middle_id}, right=${node.right_id}, current_path="${current_path}"')
	
	// Construct the path for this node
	path := current_path + node.character.ascii_str()
	println('Path for node: "${path}"')
	
	// If this node is the end of a string, add it to the result
	if node.is_end_of_string {
		println('Node is end of string, adding key: "${path}"')
		result << path
	}

	// Recursively collect keys from the middle child (keys that extend this prefix)
	if node.middle_id != 0 {
		println('Collecting from middle child with path: "${path}"')
		self.collect_keys_with_prefix(node.middle_id, path, prefix, mut result)!
	}
	
	// Also collect keys from left and right children
	// This is necessary because multiple keys might share the same prefix
	if node.left_id != 0 {
		println('Collecting from left child with path: "${current_path}"')
		self.collect_keys_with_prefix(node.left_id, current_path, prefix, mut result)!
	}
	if node.right_id != 0 {
		println('Collecting from right child with path: "${current_path}"')
		self.collect_keys_with_prefix(node.right_id, current_path, prefix, mut result)!
	}
}

// Helper function to recursively collect all keys under a node
fn (mut self TST) collect_all_keys(node_id u32, current_path string, mut result []string) ! {
	if node_id == 0 {
		return
	}

	node := deserialize_node(self.db.get(node_id)!)!
	println('Collecting all from node ${node_id}: character=${node.character} (${node.character.ascii_str()}), is_end=${node.is_end_of_string}, left=${node.left_id}, middle=${node.middle_id}, right=${node.right_id}, current_path="${current_path}"')
	
	// Construct the path for this node
	path := current_path + node.character.ascii_str()
	println('Path for node: "${path}"')
	
	// If this node is the end of a string, add it to the result
	if node.is_end_of_string {
		println('Node is end of string, adding key: "${path}"')
		result << path
	}

	// Recursively collect keys from all children
	if node.left_id != 0 {
		println('Collecting all from left child with path: "${current_path}"')
		self.collect_all_keys(node.left_id, current_path, mut result)!
	}
	if node.middle_id != 0 {
		println('Collecting all from middle child with path: "${path}"')
		self.collect_all_keys(node.middle_id, path, mut result)!
	}
	if node.right_id != 0 {
		println('Collecting all from right child with path: "${current_path}"')
		self.collect_all_keys(node.right_id, current_path, mut result)!
	}
}

// Gets all values for keys with a given prefix
pub fn (mut self TST) getall(prefix string) ![][]u8 {
	println('Getting all values with prefix: "${prefix}"')
	// Get all matching keys
	keys := self.list(prefix)!

	// Get values for each key
	mut values := [][]u8{}
	for key in keys {
		if value := self.get(key) {
			values << value
		}
	}

	println('Found ${values.len} values with prefix "${prefix}"')
	return values
}