module model

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import os

fn test_generic_manager() {
	// Create temporary directory for test
	test_dir := os.temp_dir() + '/herolib_test_manager'
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	// Create database and radix tree
	mut db_data := ourdb.new(path: test_dir + '/data.db')!
	mut db_meta := radixtree.new(path: test_dir + '/meta.db')!
	
	// Create circle manager using our generic implementation
	mut circle_manager := new_circle_manager(db_data, db_meta)
	
	// Create a new circle
	mut circle := circle_manager.new()
	circle.name = 'Test Circle'
	circle.description = 'A test circle for generic manager'
	
	// Add the circle to the database
	circle = circle_manager.set(mut circle)!
	
	// Verify the circle was added
	assert circle.id > 0
	
	// Find the circle by its name using the generic index
	circles := circle_manager.find_by_index('name', 'Test Circle')!
	assert circles.len == 1
	assert circles[0].id == circle.id
	assert circles[0].name == 'Test Circle'
	
	// Find by ID
	circles_by_id := circle_manager.find_by_index('id', circle.id.str())!
	assert circles_by_id.len == 1
	assert circles_by_id[0].id == circle.id
	
	// Delete the circle
	circle_manager.delete(circle.id)!
	
	// Verify the circle was deleted
	circles_after_delete := circle_manager.find_by_index('name', 'Test Circle')!
	assert circles_after_delete.len == 0
	
	println('Generic manager test passed!')
}
