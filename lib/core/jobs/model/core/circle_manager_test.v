module model

import os
import rand

fn test_circle_manager() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_circle_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := new(path: test_dir)!

	// Create multiple circles for testing
	mut circle1 := runner.circles.new()
	circle1.name = 'Development Team'
	circle1.description = 'Software development team'

	mut circle2 := runner.circles.new()
	circle2.name = 'Marketing Team'
	circle2.description = 'Marketing and communications team'

	mut circle3 := runner.circles.new()
	circle3.name = 'Executive Team'
	circle3.description = 'Executive leadership team'

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
	
	// Debug: Print the circle IDs in the list
	circle_ids := runner.circles.list()!
	println('Circle IDs in list: ${circle_ids}')
	
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
		if circle.name == 'Development Team' {
			found1 = true
		} else if circle.name == 'Marketing Team' {
			found2 = true
		} else if circle.name == 'Executive Team' {
			found3 = true
		}
	}
	
	assert found1, 'Circle 1 not found in list'
	assert found2, 'Circle 2 not found in list'
	assert found3, 'Circle 3 not found in list'

	// Get and verify individual circles
	println('Verifying individual circles')
	retrieved_circle1 := runner.circles.get_by_name('Development Team')!
	assert retrieved_circle1.name == circle1.name
	assert retrieved_circle1.description == circle1.description
	assert retrieved_circle1.members.len == 0

	// Test adding members to a circle
	println('Testing adding members to a circle')
	
	// Create members
	mut member1 := Member{
		pubkeys: ['dev-lead-pubkey']
		name: 'Development Lead'
		description: 'Lead developer'
		role: .admin
		emails: ['dev.lead@example.com']
	}
	
	mut member2 := Member{
		pubkeys: ['dev-member-pubkey']
		name: 'Developer'
		description: 'Team developer'
		role: .member
		emails: ['developer@example.com']
	}
	
	mut member3 := Member{
		pubkeys: ['contributor-pubkey']
		name: 'Contributor'
		description: 'External contributor'
		role: .contributor
		emails: ['contributor@example.com']
	}
	
	// Add members to circle 1
	runner.circles.add_member(circle1.id, member1)!
	runner.circles.add_member(circle1.id, member2)!
	runner.circles.add_member(circle1.id, member3)!
	
	// Verify members were added
	updated_circle1 := runner.circles.get(circle1.id)!
	assert updated_circle1.members.len == 3, 'Expected 3 members, got ${updated_circle1.members.len}'
	
	// Test get_members functionality
	println('Testing get_members functionality')
	members := runner.circles.get_members(circle1.id)!
	assert members.len == 3, 'Expected 3 members, got ${members.len}'
	
	// Test get_members_by_role functionality
	println('Testing get_members_by_role functionality')
	admin_members := runner.circles.get_members_by_role(circle1.id, .admin)!
	assert admin_members.len == 1, 'Expected 1 admin member, got ${admin_members.len}'
	assert admin_members[0].pubkeys.len > 0
	assert admin_members[0].pubkeys[0] == 'dev-lead-pubkey'
	
	regular_members := runner.circles.get_members_by_role(circle1.id, .member)!
	assert regular_members.len == 1, 'Expected 1 regular member, got ${regular_members.len}'
	assert regular_members[0].pubkeys.len > 0
	assert regular_members[0].pubkeys[0] == 'dev-member-pubkey'
	
	contributor_members := runner.circles.get_members_by_role(circle1.id, .contributor)!
	assert contributor_members.len == 1, 'Expected 1 contributor member, got ${contributor_members.len}'
	assert contributor_members[0].pubkeys.len > 0
	assert contributor_members[0].pubkeys[0] == 'contributor-pubkey'
	
	// Test update_member_role functionality
	println('Testing update_member_role functionality')
	runner.circles.update_member_role(circle1.id, 'dev-member-pubkey', .stakeholder)!
	
	// Verify role was updated
	updated_circle_after_role_change := runner.circles.get(circle1.id)!
	mut found_stakeholder := false
	
	for member in updated_circle_after_role_change.members {
		if member.pubkeys.len > 0 && member.pubkeys[0] == 'dev-member-pubkey' {
			assert member.role == .stakeholder, 'Expected role to be stakeholder, got ${member.role}'
			found_stakeholder = true
		}
	}
	
	assert found_stakeholder, 'Stakeholder member not found after role update'
	
	// Test remove_member functionality
	println('Testing remove_member functionality')
	runner.circles.remove_member(circle1.id, 'contributor-pubkey')!
	
	// Verify member was removed
	updated_circle_after_removal := runner.circles.get(circle1.id)!
	assert updated_circle_after_removal.members.len == 2, 'Expected 2 members after removal, got ${updated_circle_after_removal.members.len}'
	
	mut found_contributor := false
	for member in updated_circle_after_removal.members {
		if member.pubkeys.len > 0 && member.pubkeys[0] == 'contributor-pubkey' {
			found_contributor = true
		}
	}
	
	assert !found_contributor, 'Contributor still found after removal'
	
	// Test delete_by_name functionality
	println('Testing delete_by_name functionality')
	runner.circles.delete_by_name('Marketing Team')!
	
	// Verify deletion
	circles_after_delete := runner.circles.getall()!
	assert circles_after_delete.len == 2, 'Expected 2 circles after deletion, got ${circles_after_delete.len}'
	
	mut found_marketing := false
	for circle in circles_after_delete {
		if circle.name == 'Marketing Team' {
			found_marketing = true
		}
	}
	
	assert !found_marketing, 'Marketing Team still found after deletion'
	
	// Delete remaining circles
	println('Deleting remaining circles')
	runner.circles.delete_by_name('Development Team')!
	runner.circles.delete_by_name('Executive Team')!
	
	// Verify all circles are deleted
	circles_after_all_deleted := runner.circles.getall() or {
		// This is expected to fail with 'No circles found' error
		assert err.msg().contains('not found'), 'Expected error message to contain "not found"'
		[]Circle{}
	}
	assert circles_after_all_deleted.len == 0, 'Expected 0 circles after all deletions, got ${circles_after_all_deleted.len}'

	println('All circle manager tests passed successfully')
}
