module model

import os
import rand

fn test_circles_model() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_circle_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := new(path: test_dir)!

	// Create multiple circles for testing
	mut circle1 := runner.circles.new()
	circle1.name = 'Administrators'
	circle1.description = 'Administrator circle with full access'

	mut circle2 := runner.circles.new()
	circle2.name = 'Developers'
	circle2.description = 'Developer circle'

	mut circle3 := runner.circles.new()
	circle3.name = 'Guests'
	circle3.description = 'Guest circle with limited access'

	// Add the circles
	println('Adding circle 1')
	c1:=runner.circles.set(mut circle1)!
	println('Adding circle 2')
	c2:=runner.circles.set(mut circle2)!
	println('Adding circle 3')
	c3:=runner.circles.set(mut circle3)!

	assert c1.id== 1
	assert c2.id== 2

	// Test list functionality
	println('Testing list functionality')
	all_circles := runner.circles.list()!
	assert all_circles.len == 3, 'Expected 3 circles, got ${all_circles.len}'
	
	// Verify all circles are in the list
	mut found1 := false
	mut found2 := false
	mut found3 := false
	
	for circle in all_circles {
		if circle.id == 1 {
			found1 = true
		} else if circle.id == 2 {
			found2 = true
		} else if circle.id == 3 {
			found3 = true
		}
	}
	
	assert found1, 'Circle 1 not found in list'
	assert found2, 'Circle 2 not found in list'
	assert found3, 'Circle 3 not found in list'

	// Get and verify individual circles
	println('Verifying individual circles')
	retrieved_circle1 := runner.circles.get(1)!
	assert retrieved_circle1.id == circle1.id
	assert retrieved_circle1.name == circle1.name
	assert retrieved_circle1.description == circle1.description

	// Add members to circles
	println('Adding members to circles')
	runner.circles.add_member(1, 'user1-pubkey')!
	runner.circles.add_member(1, 'user2-pubkey')!
	runner.circles.add_member(2, 'user3-pubkey')!
	runner.circles.add_member(3, 'user4-pubkey')!

	// Verify members were added
	updated_circle1 := runner.circles.get(1)!
	assert updated_circle1.members.len == 2, 'Expected 2 members in admin circle, got ${updated_circle1.members.len}'
	
	mut found_user1 := false
	mut found_user2 := false
	
	for member in updated_circle1.members {
		if member.pubkey == 'user1-pubkey' {
			found_user1 = true
		} else if member.pubkey == 'user2-pubkey' {
			found_user2 = true
		}
	}
	
	assert found_user1, 'User1 not found in admin circle'
	assert found_user2, 'User2 not found in admin circle'

	// Test get_user_circles
	println('Testing get_user_circles')
	user1_circles := runner.circles.get_user_circles('user1-pubkey')!
	assert user1_circles.len == 1, 'Expected 1 circle for user1, got ${user1_circles.len}'
	assert user1_circles[0].id == 1, 'Expected admin-circle for user1'

	// Remove member from circle
	println('Removing member from circle')
	runner.circles.remove_member(1, 'user1-pubkey')!
	
	// Verify member was removed
	updated_circle1_after_remove := runner.circles.get(1)!
	assert updated_circle1_after_remove.members.len == 1, 'Expected 1 member in admin circle after removal, got ${updated_circle1_after_remove.members.len}'
	assert updated_circle1_after_remove.members[0].pubkey == 'user2-pubkey', 'Expected user2 to remain in admin circle'

	// Test delete functionality
	println('Testing delete functionality')
	// Delete circle 2
	runner.circles.delete(2)!
	
	// Verify deletion with list
	circles_after_delete := runner.circles.list()!
	assert circles_after_delete.len == 2, 'Expected 2 circles after deletion, got ${circles_after_delete.len}'
	
	// Verify the remaining circles
	mut found_after_delete1 := false
	mut found_after_delete2 := false
	mut found_after_delete3 := false
	
	for circle in circles_after_delete {
		if circle.id == 1 {
			found_after_delete1 = true
		} else if circle.id == 2 {
			found_after_delete2 = true
		} else if circle.id == 3 {
			found_after_delete3 = true
		}
	}
	
	assert found_after_delete1, 'Circle 1 not found after deletion'
	assert !found_after_delete2, 'Circle 2 found after deletion (should be deleted)'
	assert found_after_delete3, 'Circle 3 not found after deletion'

	// Delete another circle
	println('Deleting another circle')
	runner.circles.delete(3)!
	
	// Verify only one circle remains
	circles_after_second_delete := runner.circles.list()!
	assert circles_after_second_delete.len == 1, 'Expected 1 circle after second deletion, got ${circles_after_second_delete.len}'
	assert circles_after_second_delete[0].id == 1, 'Remaining circle should be admin-circle'

	// Delete the last circle
	println('Deleting last circle')
	runner.circles.delete(1)!
	
	// Verify no circles remain
	circles_after_all_deleted := runner.circles.list() or {
		// This is expected to fail with 'No circles found' error
		assert err.msg() == 'No circles found'
		[]Circle{}
	}
	assert circles_after_all_deleted.len == 0, 'Expected 0 circles after all deletions, got ${circles_after_all_deleted.len}'

	println('All tests passed successfully')
}
