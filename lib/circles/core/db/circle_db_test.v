module db

import os
import rand
import freeflowuniverse.herolib.circles.actionprocessor
import freeflowuniverse.herolib.circles.core.models {Circle, Member}

fn test_circle_db() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_circle_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := actionprocessor.new(path: test_dir)!

	// Create multiple circles for testing
	mut circle1 := runner.circles.new()
	circle1.name = 'test-circle-1'
	circle1.description = 'Test Circle 1'

	mut circle2 := runner.circles.new()
	circle2.name = 'test-circle-2'
	circle2.description = 'Test Circle 2'

	mut circle3 := runner.circles.new()
	circle3.name = 'test-circle-3'
	circle3.description = 'Test Circle 3'

	// Create members for testing
	mut member1 := Member{
		name: 'member1'
		description: 'Test Member 1'
		role: .admin
		pubkeys: ['pubkey1']
		emails: ['member1@example.com']
	}

	mut member2 := Member{
		name: 'member2'
		description: 'Test Member 2'
		role: .member
		pubkeys: ['pubkey2']
		emails: ['member2@example.com']
	}

	// Add members to circle1
	circle1.members << member1
	circle1.members << member2

	// Add the circles
	println('Adding circle 1')
	circle1 = runner.circles.set(circle1)!
	
	// Explicitly set different IDs for each circle to avoid overwriting
	circle2.id = 1 // Set a different ID for circle2
	println('Adding circle 2')
	circle2 = runner.circles.set(circle2)!
	
	circle3.id = 2 // Set a different ID for circle3
	println('Adding circle 3')
	circle3 = runner.circles.set(circle3)!

	// Test list functionality
	println('Testing list functionality')
	
	// Get all circles
	all_circles := runner.circles.getall()!
	println('Retrieved ${all_circles.len} circles')
	for i, circle in all_circles {
		println('Circle ${i}: id=${circle.id}, name=${circle.name}')
	}
	
	assert all_circles.len == 3, 'Expected 3 circles, got ${all_circles.len}'
	
	// Verify all circles are in the list
	mut found1 := false
	mut found2 := false
	mut found3 := false
	
	for circle in all_circles {
		if circle.name == 'test-circle-1' {
			found1 = true
		} else if circle.name == 'test-circle-2' {
			found2 = true
		} else if circle.name == 'test-circle-3' {
			found3 = true
		}
	}
	
	assert found1, 'Circle 1 not found in list'
	assert found2, 'Circle 2 not found in list'
	assert found3, 'Circle 3 not found in list'

	// Get and verify individual circles
	println('Verifying individual circles')
	retrieved_circle1 := runner.circles.get_by_name('test-circle-1')!
	assert retrieved_circle1.name == circle1.name
	assert retrieved_circle1.description == circle1.description
	assert retrieved_circle1.members.len == 2
	assert retrieved_circle1.members[0].name == 'member1'
	assert retrieved_circle1.members[0].role == .admin
	assert retrieved_circle1.members[1].name == 'member2'
	assert retrieved_circle1.members[1].role == .member

	// Test add_member method
	println('Testing add_member method')
	mut member3 := Member{
		name: 'member3'
		description: 'Test Member 3'
		role: .contributor
		pubkeys: ['pubkey3']
		emails: ['member3@example.com']
	}
	
	runner.circles.add_member('test-circle-2', member3)!
	updated_circle2 := runner.circles.get_by_name('test-circle-2')!
	assert updated_circle2.members.len == 1
	assert updated_circle2.members[0].name == 'member3'
	assert updated_circle2.members[0].role == .contributor

	// Test update_member_role method
	println('Testing update_member_role method')
	runner.circles.update_member_role('test-circle-2', 'member3', .stakeholder)!
	role_updated_circle2 := runner.circles.get_by_name('test-circle-2')!
	assert role_updated_circle2.members[0].role == .stakeholder

	// Test remove_member method
	println('Testing remove_member method')
	runner.circles.remove_member('test-circle-1', 'member2')!
	member_removed_circle1 := runner.circles.get_by_name('test-circle-1')!
	assert member_removed_circle1.members.len == 1
	assert member_removed_circle1.members[0].name == 'member1'

	// Test get_all_circle_names method
	println('Testing get_all_circle_names method')
	circle_names := runner.circles.get_all_circle_names()!
	assert circle_names.len == 3
	assert 'test-circle-1' in circle_names
	assert 'test-circle-2' in circle_names
	assert 'test-circle-3' in circle_names

	// Test delete functionality
	println('Testing delete functionality')
	// Delete circle 2
	runner.circles.delete_by_name('test-circle-2')!
	
	// Verify deletion with list
	circles_after_delete := runner.circles.getall()!
	assert circles_after_delete.len == 2, 'Expected 2 circles after deletion, got ${circles_after_delete.len}'
	
	// Verify the remaining circles
	mut found_after_delete1 := false
	mut found_after_delete2 := false
	mut found_after_delete3 := false
	
	for circle in circles_after_delete {
		if circle.name == 'test-circle-1' {
			found_after_delete1 = true
		} else if circle.name == 'test-circle-2' {
			found_after_delete2 = true
		} else if circle.name == 'test-circle-3' {
			found_after_delete3 = true
		}
	}
	
	assert found_after_delete1, 'Circle 1 not found after deletion'
	assert !found_after_delete2, 'Circle 2 found after deletion (should be deleted)'
	assert found_after_delete3, 'Circle 3 not found after deletion'

	// Delete another circle
	println('Deleting another circle')
	runner.circles.delete_by_name('test-circle-3')!
	
	// Verify only one circle remains
	circles_after_second_delete := runner.circles.getall()!
	assert circles_after_second_delete.len == 1, 'Expected 1 circle after second deletion, got ${circles_after_second_delete.len}'
	assert circles_after_second_delete[0].name == 'test-circle-1', 'Remaining circle should be test-circle-1'

	// Delete the last circle
	println('Deleting last circle')
	runner.circles.delete_by_name('test-circle-1')!
	
	// Verify no circles remain
	circles_after_all_deleted := runner.circles.getall() or {
		// This is expected to fail with 'No circles found' error
		assert err.msg().contains('No index keys defined for this type') || err.msg().contains('No circles found')
		[]Circle{cap: 0}
	}
	assert circles_after_all_deleted.len == 0, 'Expected 0 circles after all deletions, got ${circles_after_all_deleted.len}'

	println('All tests passed successfully')
}
