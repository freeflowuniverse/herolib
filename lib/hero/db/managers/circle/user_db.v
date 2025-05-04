module circle

import freeflowuniverse.herolib.hero.db.core { DBHandler, SessionState, new_dbhandler }
import freeflowuniverse.herolib.hero.db.models.circle { User, Role }
type UserObj = User

@[heap]
pub struct UserDB {
pub mut:
	db DBHandler[UserObj]
}

pub fn new_userdb(session_state SessionState) !UserDB {
	return UserDB{
		db: new_dbhandler[UserObj]('user', session_state)
	}
}

pub fn (mut m UserDB) new() User {
	return UserObj{}
}

// set adds or updates a user
pub fn (mut m UserDB) set(user User) !UserObj {
	return m.db.set(user)!
}

// get retrieves a user by its ID
pub fn (mut m UserDB) get(id u32) !UserObj {
	data := m.db.get_data(id)!
	return loads_user(data)!
}

// list returns all user IDs
pub fn (mut m UserDB) list() ![]u32 {
	return m.db.list()!
}

pub fn (mut m UserDB) getall() ![]UserObj {
	mut objs := []UserObj{}
	for id in m.list()! {
		user := m.get(id)!
		objs << user
	}
	return objs
}

// delete removes a user by its ID
pub fn (mut m UserDB) delete(obj UserObj) ! {
	m.db.delete(obj)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_name retrieves a user by its name
pub fn (mut m UserDB) get_by_name(name string) !UserObj {
	data := m.db.get_data_by_key('name', name)!
	return loads_user(data)!	
}

// delete_by_name removes a user by its name
pub fn (mut m UserDB) delete_by_name(name string) ! {
	// Get the user by name
	user := m.get_by_name(name) or {
		// User not found, nothing to delete
		return
	}

	// Delete the user by ID
	m.delete(user)!
}

// update_user_role updates the role of a user
pub fn (mut m UserDB) update_user_role(name string, new_role Role) !UserObj {
	// Get the user by name
	mut user := m.get_by_name(name)!

	// Update the user role
	user.role = new_role

	// Save the updated user
	return m.set(user)!
}