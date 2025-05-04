module circle

import freeflowuniverse.herolib.hero.db.core { new_session }
import freeflowuniverse.herolib.hero.db.models.circle { Role }
import freeflowuniverse.herolib.data.ourtime
import os

// test_user_db tests the functionality of the UserDB
pub fn test_user_db() ! {
	println('Starting User DB Test')

	// Create a temporary directory for the test
	test_dir := os.join_path(os.temp_dir(), 'hero_user_test')
	os.mkdir_all(test_dir) or { return error('Failed to create test directory: ${err}') }
	defer {
		// Clean up after test
		os.rmdir_all(test_dir) or { eprintln('Failed to remove test directory: ${err}') }
	}

	// Create a new session state
	mut session := new_session(
		name: 'test_session'
		path: test_dir
	)!

	println('Session created: ${session.name}')

	// Initialize the UserDB
	mut user_db := new_userdb(session)!

	println('UserDB initialized')

	// Create and add users
	mut admin_user := user_db.new()
	admin_user.name = 'admin_user'
	admin_user.description = 'Administrator user for testing'
	admin_user.role = Role.admin
	admin_user.pubkey = 'admin_pubkey_123'
	admin_user.creation_time = ourtime.now()
	admin_user.mod_time = ourtime.now()

	// println(admin_user)
	// if true{panic("sss")}

	// Save the admin user
	admin_user = user_db.set(admin_user)!
	println('Admin user created with ID: ${admin_user.Base.id}')

	// Create a regular member
	mut member_user := user_db.new()
	member_user.name = 'member_user'
	member_user.description = 'Regular member for testing'
	member_user.role = Role.member
	member_user.pubkey = 'member_pubkey_456'
	member_user.creation_time = ourtime.now()
	member_user.mod_time = ourtime.now()

	// Save the member user
	member_user = user_db.set(member_user)!
	println('Member user created with ID: ${member_user.Base.id}')

	// Create a guest user
	mut guest_user := user_db.new()
	guest_user.name = 'guest_user'
	guest_user.description = 'Guest user for testing'
	guest_user.role = Role.guest
	guest_user.pubkey = 'guest_pubkey_789'
	guest_user.creation_time = ourtime.now()
	guest_user.mod_time = ourtime.now()

	// Save the guest user
	guest_user = user_db.set(guest_user)!
	println('Guest user created with ID: ${guest_user.Base.id}')

	// Retrieve users by ID
	retrieved_admin := user_db.get(admin_user.Base.id)!
	println('Retrieved admin user by ID: ${retrieved_admin.name} (Role: ${retrieved_admin.role})')

	// Retrieve users by name
	retrieved_member := user_db.get_by_name('member_user')!
	println('Retrieved member user by name: ${retrieved_member.name} (Role: ${retrieved_member.role})')

	// Update a user's role
	updated_guest := user_db.update_user_role('guest_user', Role.contributor)!
	println('Updated guest user role to contributor: ${updated_guest.name} (Role: ${updated_guest.role})')

	// List all users
	user_ids := user_db.list()!
	println('Total users: ${user_ids.len}')
	println('User IDs: ${user_ids}')

	// Get all users
	all_users := user_db.getall()!
	println('All users:')
	for user in all_users {
		println('  - ${user.name} (ID: ${user.Base.id}, Role: ${user.role})')
	}

	// Delete a user
	user_db.delete(member_user)!
	println('Deleted member user with ID: ${member_user.Base.id}')

	// Delete a user by name
	user_db.delete_by_name('guest_user')!
	println('Deleted guest user by name')

	// List remaining users
	remaining_user_ids := user_db.list()!
	println('Remaining users: ${remaining_user_ids.len}')
	println('Remaining user IDs: ${remaining_user_ids}')

	println('User DB Test completed successfully')
}
