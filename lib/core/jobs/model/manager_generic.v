module model

import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.data.ourdb
import json


// Manager is a generic manager for handling database operations with any type that implements IndexKeyer and Serializer
pub struct Manager[T] {
pub mut:
	db_data &ourdb.OurDB
	db_meta &radixtree.RadixTree
	prefix string = 'item'  // Default prefix for keys in the radix tree
}

// set adds or updates an item
pub fn (mut m Manager[T]) set(item_ T) !T {

	mut item:=item_

	// Store the item data in the database and get the assigned ID
	item.id=m.db_data.set(id: item.id, data: item.dumps()!)!

	// Update index keys
	keys := item.index_keys()	
	for key, value in keys {
		index_key := '${m.prefix}:${key}:${value}'
		m.db_meta.insert(index_key, item.id.str().bytes())!
	}	
	
	// Get current list of all IDs
	mut all_keys := m.list()!
	
	// Check if the item ID is already in the list
	mut found := false
	for item_id in all_keys {
		if item_id == item.id {
			found = true
			break
		}
	}
	
	// Add the new ID if it doesn't exist in the list
	if !found {
		all_keys << item.id
		
		// Create a comma-separated string of all IDs
		mut new_all_keys_str := all_keys.map(fn (id u32) string {
			return id.str()
		}).join(',')
		
		// Store the updated list
		m.db_meta.insert('${m.prefix}:all', new_all_keys_str.bytes())!
	}

	return item
}

// get retrieves an item by its ID
pub fn (mut m Manager[T]) get(id u32) !T {
	
	// Get the item data from the database
	item_data := m.db_data.get(id) or {
		return error('Item data not found for ID ${id}')
	}
	
	// Deserialize the item data using the loader function
	$if T is Agent {
		mut o:= agent_loads(item_data)!
		o.id = id
		return o
	} $else $if T is Circle {
		mut o:= circle_loads(item_data)!
		o.id = id
		return o
	} $else $if T is Name {
		mut o:= name_loads(item_data)!
		o.id = id
		return o
	} $else {
		return error('Unsupported type for deserialization')
	}
}

pub fn (mut m Manager[T]) exists(id u32) !bool {	
	return m.db_data.get(id) or { return false } != []u8{}
}


// get_by_key retrieves an item by a specific key field and value
pub fn (mut m Manager[T]) get_by_key(key_field string, key_value string) !T {
	// Create the key for the radix tree
	key := '${m.prefix}:${key_field}:${key_value}'
	
	// Get the ID from the radix tree
	id_bytes := m.db_meta.search(key) or {
		return error('Item with ${key_field}=${key_value} not found')
	}
	
	// Convert the ID bytes to u32
	id_str := id_bytes.bytestr()
	id := id_str.u32()
	
	// Get the item using the ID
	return m.get(id)
}

// delete removes an item by its ID
pub fn (mut m Manager[T]) delete(id u32) ! {

	exists := m.exists(id)!
	if !exists {
		return
	}

	// Get the item before deleting it to remove index keys
	item := m.get(id)!

	keys := item.index_keys()	
	for key, value in keys {
		index_key := '${m.prefix}:${key}:${value}'
		m.db_meta.delete(index_key)!
	}	
		
	// Delete the item data from the database
	m.db_data.delete(id)!
	
	all_keys := m.list()!
	
	// Filter out the key to remove
	mut new_keys := []u32{}
	for existing_key in all_keys {
		if existing_key != id {
			new_keys << existing_key
		}
	}
	
	// Join the keys with commas and store
	new_all_keys_str := new_keys.map(it.str()).join(',')
	m.db_meta.insert('${m.prefix}:all', new_all_keys_str.bytes())!

}

// list returns all ids from the manager
pub fn (mut m Manager[T]) list() ![]u32 {
	// Try to get existing list
	if all_bytes := m.db_meta.search('${m.prefix}:all') {
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			// Convert string IDs to u32
			mut u32_ids := []u32{}
			for id_str in all_str.split(',') {
				if id_str.len > 0 {
					u32_ids << id_str.u32()
				}
			}
			return u32_ids
		}
	}	
	return []u32{}
}


pub fn (mut m Manager[T]) getall() ![]T {
	mut items := []T{}
	for id in m.list()! {
		items << m.get(id)!
	}
	return items
}


