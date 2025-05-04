module core

// import freeflowuniverse.herolib.hero.db.managers.circle as circle_models

pub struct DBHandler[T] {
pub mut:
	prefix        string
	session_state SessionState
}

// new_dbhandler creates a new DBHandler for type T
pub fn new_dbhandler[T](prefix string, session_state SessionState) DBHandler[T] {
	return DBHandler[T]{
		prefix:        prefix
		session_state: session_state
	}
}

// set adds or updates an item
pub fn (mut m DBHandler[T]) set(item_ T) !T {
	mut item := item_

	// Store the item data in the database and get the assigned ID
	item.Base.id = m.session_state.dbs.db_data_core.set(data: item.dumps()!)!

	// Update index keys
	for key, value in m.index_keys(item)! {
		index_key := '${m.prefix}:${key}:${value}'
		m.session_state.dbs.db_meta_core.set(index_key, item.Base.id.str().bytes())!
	}

	return item
}

// get retrieves an item by its ID
pub fn (mut m DBHandler[T]) get_data(id u32) ![]u8 {
	// Get the item data from the database
	item_data := m.session_state.dbs.db_data_core.get(id) or {
		return error('Item data not found for ID ${id}')
	}
	return item_data
}

pub fn (mut m DBHandler[T]) exists(id u32) !bool {
	item_data := m.session_state.dbs.db_data_core.get(id) or { return false }
	return item_data != []u8{}
}

// get_by_key retrieves an item by a specific key field and value
pub fn (mut m DBHandler[T]) get_data_by_key(key_field string, key_value string) ![]u8 {
	// Create the key for the radix tree
	key := '${m.prefix}:${key_field}:${key_value}'

	// Get the ID from the radix tree
	id_bytes := m.session_state.dbs.db_meta_core.get(key) or {
		return error('Item with ${key_field}=${key_value} not found')
	}

	// Convert the ID bytes to u32
	id_str := id_bytes.bytestr()
	id := id_str.u32()

	// Get the item using the ID
	return m.get_data(id)
}

// delete removes an item by its ID
pub fn (mut m DBHandler[T]) delete(item T) ! {
	exists := m.exists(item.Base.id)!
	if !exists {
		return
	}

	for key, value in m.index_keys(item)! {
		index_key := '${m.prefix}:${key}:${value}'
		m.session_state.dbs.db_meta_core.delete(index_key)!
	}

	// Delete the item data from the database
	m.session_state.dbs.db_data_core.delete(item.Base.id)!
}

// internal function to always have at least one index key, the default is id
fn (mut m DBHandler[T]) index_keys(item T) !map[string]string {
	mut keymap := item.index_keys()
	if keymap.len == 0 {
		keymap['id'] = item.Base.id.str()
	}
	return keymap
}

// list returns all ids from the db handler
pub fn (mut m DBHandler[T]) list() ![]u32 {
	// Use the RadixTree's prefix capabilities to list all items
	mut empty_item := T{}
	mut keys_map := m.index_keys(empty_item)!
	if keys_map.len == 0 {
		return error('No index keys defined for this type')
	}

	// Get the first key from the map
	mut default_key := ''
	for k, _ in keys_map {
		default_key = k
		break
	}

	// Get all IDs from the meta database
	id_bytes := m.session_state.dbs.db_meta_core.getall('${m.prefix}:${default_key}')!

	// Convert bytes to u32 IDs
	mut result := []u32{}
	for id_byte in id_bytes {
		id_str := id_byte.bytestr()
		result << id_str.u32()
	}

	return result
}

// list_by_prefix returns all items that match a specific prefix pattern
pub fn (mut m DBHandler[T]) list_by_prefix(key_field string, prefix_value string) ![]u32 {
	// Create the prefix for the radix tree
	prefix := '${m.prefix}:${key_field}:${prefix_value}'
	println('DEBUG: Searching with prefix: ${prefix}')

	// Use RadixTree's list method to get all keys with this prefix
	keys := m.session_state.dbs.db_meta_core.list(prefix)!
	println('DEBUG: Found ${keys.len} keys matching prefix')
	for i, key in keys {
		println('DEBUG: Key ${i}: ${key}')
	}

	// Extract IDs from the values stored in these keys
	mut ids := []u32{}
	mut seen := map[u32]bool{}

	for key in keys {
		if id_bytes := m.session_state.dbs.db_meta_core.get(key) {
			id_str := id_bytes.bytestr()
			if id_str.len > 0 {
				id := id_str.u32()
				println('DEBUG: Found ID ${id} for key ${key}')
				// Only add the ID if we haven't seen it before
				if !seen[id] {
					ids << id
					seen[id] = true
				}
			}
		}
	}

	println('DEBUG: Returning ${ids.len} unique IDs')
	return ids
}
