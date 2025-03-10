module model

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree

@[heap]
pub struct CircleManager {
pub mut:
	manager Manager[Circle]
}

pub fn new_circlemanager(db_data &ourdb.OurDB, db_meta &radixtree.RadixTree) CircleManager {
	return CircleManager{
		manager: Manager[Circle]{db_data: db_data, db_meta: db_meta, prefix: 'circle'}
	}
}

pub fn (mut m CircleManager) new() Circle {
	return Circle{}
}

// set adds or updates a circle
pub fn (mut m CircleManager) set(circle Circle) !Circle {
	return m.manager.set(circle)!
}

// get retrieves a circle by its ID
pub fn (mut m CircleManager) get(id u32) !Circle {
	return m.manager.get(id)!
}

// list returns all circle IDs
pub fn (mut m CircleManager) list() ![]u32 {
	return m.manager.list()!
}

pub fn (mut m CircleManager) getall() ![]Circle {
	return m.manager.getall()!
}

// delete removes a circle by its ID
pub fn (mut m CircleManager) delete(id u32) ! {
	m.manager.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_name retrieves a circle by its name
pub fn (mut m CircleManager) get_by_name(name string) !Circle {
	return m.manager.get_by_key('name', name)!
}

// delete_by_name removes a circle by its name
pub fn (mut m CircleManager) delete_by_name(name string) ! {
	// Get the circle by name
	circle := m.get_by_name(name) or {
		// Circle not found, nothing to delete
		return
	}
	
	// Delete the circle by ID
	m.delete(circle.id)!
}

// add_member adds a member to a circle
pub fn (mut m CircleManager) add_member(circle_id u32, member Member) !Circle {
	// Get the circle by ID
	mut circle := m.get(circle_id)!
	
	// Check if member with the same pubkey already exists
	if member.pubkeys.len == 0 {
		return error('Member must have at least one pubkey')
	}
	
	for existing_member in circle.members {
		for existing_pubkey in existing_member.pubkeys {
			for pubkey in member.pubkeys {
				if existing_pubkey == pubkey {
					return error('Member with pubkey ${pubkey} already exists in circle ${circle.name}')
				}
			}
		}
	}
	
	// Add the member to the circle
	circle.members << member
	
	// Save the updated circle
	return m.set(circle)!
}

// remove_member removes a member from a circle by pubkey
pub fn (mut m CircleManager) remove_member(circle_id u32, pubkey string) !Circle {
	// Get the circle by ID
	mut circle := m.get(circle_id)!
	
	// Find and remove the member with the specified pubkey
	mut found := false
	mut new_members := []Member{}
	
	for member in circle.members {
		mut has_pubkey := false
		for p in member.pubkeys {
			if p == pubkey {
				has_pubkey = true
				break
			}
		}
		
		if !has_pubkey {
			new_members << member
		} else {
			found = true
		}
	}
	
	if !found {
		return error('Member with pubkey ${pubkey} not found in circle ${circle.name}')
	}
	
	// Update the circle's members
	circle.members = new_members
	
	// Save the updated circle
	return m.set(circle)!
}

// update_member_role updates the role of a member in a circle
pub fn (mut m CircleManager) update_member_role(circle_id u32, pubkey string, role Role) !Circle {
	// Get the circle by ID
	mut circle := m.get(circle_id)!
	
	// Find and update the member with the specified pubkey
	mut found := false
	
	for i, mut member in circle.members {
		for p in member.pubkeys {
			if p == pubkey {
				circle.members[i].role = role
				found = true
				break
			}
		}
		if found {
			break
		}
	}
	
	if !found {
		return error('Member with pubkey ${pubkey} not found in circle ${circle.name}')
	}
	
	// Save the updated circle
	return m.set(circle)!
}

// get_members returns all members of a circle
pub fn (mut m CircleManager) get_members(circle_id u32) ![]Member {
	// Get the circle by ID
	circle := m.get(circle_id)!
	
	return circle.members
}

// get_members_by_role returns all members of a circle with a specific role
pub fn (mut m CircleManager) get_members_by_role(circle_id u32, role Role) ![]Member {
	// Get the circle by ID
	circle := m.get(circle_id)!
	
	// Filter members by role
	mut members_with_role := []Member{}
	
	for member in circle.members {
		if member.role == role {
			members_with_role << member
		}
	}
	
	return members_with_role
}
