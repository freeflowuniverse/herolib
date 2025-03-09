module model

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import json
import os

// CircleManager handles all circle-related operations
pub struct CircleManager {
pub mut:
	db_data   &ourdb.OurDB     // Database for storing circle data
	db_meta   &radixtree.RadixTree // Radix tree for mapping keys to IDs
	manager   Manager[Circle]  // Generic manager for Circle operations
}

// new_circle_manager creates a new CircleManager instance
pub fn new_circle_manager(db_data &ourdb.OurDB, db_meta &radixtree.RadixTree) CircleManager {
	return CircleManager{
		db_data: db_data
		db_meta: db_meta
		manager: new_manager[Circle](db_data, db_meta, 'circles')
	}
}


// new creates a new Circle instance
pub fn (mut m CircleManager) new() Circle {
	return Circle{
		id: 0
		name: ''
		description: ''
		members: []Member{}
	}
}

// set adds or updates a circle
pub fn (mut m CircleManager) set(mut circle Circle) !Circle {
	// If ID is 0, use the autoincrement feature from ourdb
	if circle.id == 0 {
		// Store the circle with autoincrement ID
		circle_data := circle.dumps()!
		new_id := m.db_data.set(data: circle_data)! // ourdb now gives 1 as first id
		// Update the circle ID
		circle.id = new_id
		
		// Create the key for the radix tree
		key := 'circles:${new_id}'
		
		// Store the ID in the radix tree for future lookups
		m.db_meta.insert(key, new_id.str().bytes())!
		
		// Store index keys using the generic manager
		m.manager.store_index_keys(circle, new_id)!
		
		// Update the circles:all key with this new circle
		m.add_to_all_circles(new_id.str())!
	
	} else {
		// Create the key for the radix tree
		key := 'circles:${circle.id}'
		
		// Serialize the circle data using dumps
		circle_data := circle.dumps()!
		
		// Check if this circle already exists in the database
		if id_bytes := m.db_meta.search(key) {
			// Circle exists, get the ID and update
			id_str := id_bytes.bytestr()
			id := id_str.u32()
			
			// Store the updated circle
			m.db_data.set(id: id, data: circle_data)!
			
			// Update index keys using the generic manager
			m.manager.store_index_keys(circle, id)!
		} else {
			// Circle doesn't exist, create a new one with auto-incrementing ID
			id := m.db_data.set(data: circle_data)!
			
			// Store the ID in the radix tree for future lookups
			m.db_meta.insert(key, id.str().bytes())!
			
			// Store index keys using the generic manager
			m.manager.store_index_keys(circle, id)!
			
			// Update the circles:all key with this new circle
			m.add_to_all_circles(id.str())!
		}
	}
	return circle	
}

// get retrieves a circle by its ID
pub fn (mut m CircleManager) get(id u32) !Circle {
	// Create the key for the radix tree
	key := 'circles:${id}'
	
	// Get the ID from the radix tree
	id_bytes := m.db_meta.search(key) or {
		return error('Circle with ID ${id} not found')
	}
	
	// Convert the ID bytes to u32
	id_str := id_bytes.bytestr()
	db_id := id_str.u32()
	
	// Get the circle data from the database
	circle_data := m.db_data.get(db_id) or {
		return error('Circle data not found for ID ${db_id}')
	}
	
	// Deserialize the circle data using circle_loads
	mut circle := circle_loads(circle_data) or {
		return error('Failed to deserialize circle data: ${err}')
	}
	
	return circle
}

// list returns all circles
pub fn (mut m CircleManager) list() ![]Circle {
	mut circles := []Circle{}
	
	// Get the list of all circle IDs from the special key
	circle_ids := m.get_all_circle_ids() or {
		// If no circles are found, return an empty list
		return circles
	}
	
	// For each ID, get the circle
	for id in circle_ids {
		// Get the circle
		circle := m.get(id) or {
			// If we can't get the circle, skip it
			continue
		}
		
		circles << circle
	}
	
	return circles
}

// delete removes a circle by its ID
pub fn (mut m CircleManager) delete(id u32) ! {
	// Create the key for the radix tree
	key := 'circles:${id}'
	
	// Get the ID from the radix tree
	id_bytes := m.db_meta.search(key) or {
		return error('Circle with ID ${id} not found')
	}
	
	// Convert the ID bytes to u32
	id_str := id_bytes.bytestr()
	db_id := id_str.u32()
	
	// Get the circle before deleting it to remove index keys
	circle := m.get(id)!
	
	// Delete index keys using the generic manager
	m.manager.delete_index_keys(circle, id)!
	
	// Delete the circle data from the database
	m.db_data.delete(db_id)!
	
	// Delete the key from the radix tree
	m.db_meta.delete(key)!
	
	// Remove from the circles:all list
	m.remove_from_all_circles(id)!
}

// add_member adds a member to a circle
pub fn (mut m CircleManager) add_member(circle_id u32, member_pubkey string) ! {
	// Get the circle
	mut circle := m.get(circle_id)!
	
	// Check if member already exists
	for existing_member in circle.members {
		if existing_member.pubkey == member_pubkey {
			// Member already exists, nothing to do
			return
		}
	}
	
	// Add the new member with default role
	circle.members << Member{
		pubkey: member_pubkey
		emails: []
		name: ''
		description: ''
		role: .member
	}
	
	// Save the updated circle
	m.set(mut circle)!
}

// remove_member removes a member from a circle
pub fn (mut m CircleManager) remove_member(circle_id u32, member_pubkey string) ! {
	// Get the circle
	mut circle := m.get(circle_id)!
	
	// Filter out the member to remove
	mut new_members := []Member{}
	for member in circle.members {
		if member.pubkey != member_pubkey {
			new_members << member
		}
	}
	
	// Update the circle with the new members list
	circle.members = new_members
	
	// Save the updated circle
	m.set(mut circle)!
}

// find_by_index returns circles that match the given index key and value
pub fn (mut m CircleManager) find_by_index(key string, value string) ![]Circle {
	// Use the generic manager to find IDs by index key
	ids := m.manager.find_by_index_key(key, value)!
	
	// Get each circle by ID
	mut circles := []Circle{}
	for id in ids {
		circle := m.get(id) or { continue }
		circles << circle
	}
	
	return circles
}

// get_user_circles returns all circles that a user is a member of
pub fn (mut m CircleManager) get_user_circles(user_pubkey string) ![]Circle {
	// Get all circles
	all_circles := m.list()!
	
	mut user_circles := []Circle{}

	
	// Check each circle for direct membership
	for circle in all_circles {
		for member in circle.members {
			if member.pubkey == user_pubkey {
				user_circles << circle
				break
			}
		}
	}
	
	return user_circles
}

// Helper function to get all circle IDs from the special key
fn (mut m CircleManager) get_all_circle_ids() ![]u32 {
	// Try to get the circles:all key
	if all_bytes := m.db_meta.search('circles:all') {
		// Convert to string and split by comma
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			str_ids := all_str.split(',')
			
			// Convert string IDs to u32
			mut u32_ids := []u32{}
			for id_str in str_ids {
				if id_str.len > 0 {
					u32_ids << id_str.u32()
				}
			}
			
			return u32_ids
		}
	}
	
	return error('No circles found')
}

// Helper function to add an ID to the circles:all list
fn (mut m CircleManager) add_to_all_circles(id string) ! {
	mut all_ids := []string{}
	
	// Try to get existing list
	if all_bytes := m.db_meta.search('circles:all') {
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			all_ids = all_str.split(',')
		}
	}
	
	// Check if ID is already in the list
	for existing in all_ids {
		if existing == id {
			// Already in the list, nothing to do
			return
		}
	}
	
	// Add the new ID
	all_ids << id
	
	// Join and store back
	new_all := all_ids.join(',')
	
	// Store in the radix tree
	m.db_meta.insert('circles:all', new_all.bytes())!
}

// Helper function to remove an ID from the circles:all list
fn (mut m CircleManager) remove_from_all_circles(id u32) ! {
	// Try to get the circles:all key
	if all_bytes := m.db_meta.search('circles:all') {
		// Convert to string and split by comma
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			all_ids := all_str.split(',')
			
			// Filter out the ID to remove
			mut new_all_ids := []string{}
			for existing in all_ids {
				if existing != id.str() {
					new_all_ids << existing
				}
			}
			
			// Join and store back
			new_all := new_all_ids.join(',')
			
			// Store in the radix tree
			m.db_meta.insert('circles:all', new_all.bytes())!
		}
	}
}
