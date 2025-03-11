module core

import freeflowuniverse.herolib.circles.models { DBHandler, SessionState }
import freeflowuniverse.herolib.circles.models.core { Circle }

@[heap]
pub struct CircleDB {
pub mut:
	db DBHandler[Circle]
}

pub fn new_circledb(session_state SessionState) !CircleDB {
	return CircleDB{
		db: models.new_dbhandler[Circle]('circle', session_state)
	}
}

pub fn (mut m CircleDB) new() Circle {
	return Circle{}
}

// set adds or updates a circle
pub fn (mut m CircleDB) set(circle Circle) !Circle {
	return m.db.set(circle)!
}

// get retrieves a circle by its ID
pub fn (mut m CircleDB) get(id u32) !Circle {
	return m.db.get(id)!
}

// list returns all circle IDs
pub fn (mut m CircleDB) list() ![]u32 {
	return m.db.list()!
}

pub fn (mut m CircleDB) getall() ![]Circle {
	return m.db.getall()!
}

// delete removes a circle by its ID
pub fn (mut m CircleDB) delete(id u32) ! {
	m.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_name retrieves a circle by its name
pub fn (mut m CircleDB) get_by_name(name string) !Circle {
	return m.db.get_by_key('name', name)!
}

// delete_by_name removes a circle by its name
pub fn (mut m CircleDB) delete_by_name(name string) ! {
	// Get the circle by name
	circle := m.get_by_name(name) or {
		// Circle not found, nothing to delete
		return
	}
	
	// Delete the circle by ID
	m.delete(circle.id)!
}

// get_all_circle_names returns all circle names
pub fn (mut m CircleDB) get_all_circle_names() ![]string {
	// Get all circle IDs
	circle_ids := m.list()!
	
	// Get names for all circles
	mut names := []string{}
	for id in circle_ids {
		circle := m.get(id) or { continue }
		names << circle.name
	}
	
	return names
}

// add_member adds a member to a circle
pub fn (mut m CircleDB) add_member(circle_name string, member core.Member) !Circle {
	// Get the circle by name
	mut circle := m.get_by_name(circle_name)!
	
	// Check if member with same name already exists
	for existing_member in circle.members {
		if existing_member.name == member.name {
			return error('Member with name ${member.name} already exists in circle ${circle_name}')
		}
	}
	
	// Add the member
	circle.members << member
	
	// Save the updated circle
	return m.set(circle)!
}

// remove_member removes a member from a circle by name
pub fn (mut m CircleDB) remove_member(circle_name string, member_name string) !Circle {
	// Get the circle by name
	mut circle := m.get_by_name(circle_name)!
	
	// Find and remove the member
	mut found := false
	mut new_members := []core.Member{}
	
	for member in circle.members {
		if member.name == member_name {
			found = true
			continue
		}
		new_members << member
	}
	
	if !found {
		return error('Member with name ${member_name} not found in circle ${circle_name}')
	}
	
	// Update the circle members
	circle.members = new_members
	
	// Save the updated circle
	return m.set(circle)!
}

// update_member_role updates the role of a member in a circle
pub fn (mut m CircleDB) update_member_role(circle_name string, member_name string, new_role core.Role) !Circle {
	// Get the circle by name
	mut circle := m.get_by_name(circle_name)!
	
	// Find and update the member
	mut found := false
	
	for i, mut member in circle.members {
		if member.name == member_name {
			circle.members[i].role = new_role
			found = true
			break
		}
	}
	
	if !found {
		return error('Member with name ${member_name} not found in circle ${circle_name}')
	}
	
	// Save the updated circle
	return m.set(circle)!
}
