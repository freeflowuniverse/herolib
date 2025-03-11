module core

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.circles.models

@[heap]
pub struct CircleDB {
pub mut:
	db models.DBHandler[Circle]
}

pub fn new_circledb(session_state models.SessionState) !CircleDB {
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

// add_member adds a member to a circle
pub fn (mut m CircleDB) add_member(circle_id u32, member Member) !Circle {
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
pub fn (mut m CircleDB) remove_member(circle_id u32, pubkey string) !Circle {
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
pub fn (mut m CircleDB) update_member_role(circle_id u32, pubkey string, role Role) !Circle {
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
pub fn (mut m CircleDB) get_members(circle_id u32) ![]Member {
	// Get the circle by ID
	circle := m.get(circle_id)!
	
	return circle.members
}

// get_members_by_role returns all members of a circle with a specific role
pub fn (mut m CircleDB) get_members_by_role(circle_id u32, role Role) ![]Member {
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

// play processes heroscript commands for circles
pub fn play_circle(mut cm CircleDB, mut plbook playbook.PlayBook) ! {
	// Find all actions that start with 'circle.'
	circle_actions := plbook.actions_find(actor: 'circle')!
	if circle_actions.len == 0 {
		return
	}

	// Process circle.create actions
	mut create_actions := plbook.actions_find(actor: 'circle', name: 'create')!
	for mut action in create_actions {
		mut p := action.params
		
		// Create a new circle
		mut circle := cm.new()
		circle.name = p.get('name')!
		circle.description = p.get_default('description', '')!
		
		// Save the circle
		circle = cm.set(circle)!
		
		// Mark the action as done
		action.done = true
		
		// Return the created circle as a result
		action.result.set('id', circle.id.str())
		action.result.set('name', circle.name)
	}
	
	// Process circle.add_member actions
	mut add_member_actions := plbook.actions_find(actor: 'circle', name: 'add_member')!
	for mut action in add_member_actions {
		mut p := action.params
		
		// Get circle name
		circle_name := p.get('circle')!
		
		// Find the circle by name
		mut circle := cm.get_by_name(circle_name) or {
			action.result.set('error', 'Circle with name ${circle_name} not found')
			action.done = true
			continue
		}
		
		// Create a new member
		mut member := Member{
			name: p.get('name')!
			description: p.get_default('description', '')!
		}
		
		// Get pubkeys if provided
		if p.exists('pubkey') {
			member.pubkeys << p.get('pubkey')!
		} else if p.exists('pubkeys') {
			member.pubkeys = p.get_list('pubkeys')!
		}
		
		// Get emails if provided
		if p.exists('email') {
			member.emails << p.get('email')!
		} else if p.exists('emails') {
			member.emails = p.get_list('emails')!
		}
		
		// Get role if provided
		role_str := p.get_default('role', 'member')!
		member.role = match role_str.to_lower() {
			'admin' { Role.admin }
			'stakeholder' { Role.stakeholder }
			'member' { Role.member }
			'contributor' { Role.contributor }
			'guest' { Role.guest }
			else { Role.member }
		}
		
		// Add the member to the circle
		circle = cm.add_member(circle.id, member) or {
			action.result.set('error', err.str())
			action.done = true
			continue
		}
		
		// Mark the action as done
		action.done = true
		
		// Return the member info as a result
		action.result.set('circle_id', circle.id.str())
		action.result.set('member_name', member.name)
		action.result.set('role', role_str)
	}
}
