module jobs

import freeflowuniverse.herolib.core.redisclient

fn test_runner.groups() {
	mut runner:=new()!

	// Create a new group using the manager
	mut group := runner.groups.new()
	group.guid = 'admin-group'
	group.name = 'Administrators'
	group.description = 'Administrator group with full access'
	
	// Add the group
	runner.groups.set(group)!
	
	// Create a subgroup
	mut subgroup := runner.groups.new()
	subgroup.guid = 'vm-admins'
	subgroup.name = 'VM Administrators'
	subgroup.description = 'VM management administrators'
	
	runner.groups.add(subgroup)!
	
	// Add subgroup to main group
	runner.groups.add_member(group.guid, subgroup.guid)!
	
	// Add a user to the subgroup
	runner.groups.add_member(subgroup.guid, 'user-1-pubkey')!
	
	// Get the groups and verify fields
	retrieved_group := runner.groups.get(group.guid)!
	assert retrieved_group.guid == group.guid
	assert retrieved_group.name == group.name
	assert retrieved_group.description == group.description
	assert retrieved_group.members.len == 1
	assert retrieved_group.members[0] == subgroup.guid
	
	retrieved_subgroup := runner.groups.get(subgroup.guid)!
	assert retrieved_subgroup.members.len == 1
	assert retrieved_subgroup.members[0] == 'user-1-pubkey'
	
	// Test recursive group membership
	user_groups := runner.groups.get_user_groups('user-1-pubkey')!
	assert user_groups.len == 1
	assert user_groups[0].guid == subgroup.guid
	
	// Remove member from subgroup
	runner.groups.remove_member(subgroup.guid, 'user-1-pubkey')!
	updated_subgroup := runner.groups.get(subgroup.guid)!
	assert updated_subgroup.members.len == 0
	
	// List all groups
	groups := runner.groups.list()!
	assert groups.len == 2
	
	// Delete the groups
	runner.groups.delete(subgroup.guid)!
	runner.groups.delete(group.guid)!
	
	// Verify deletion
	groups_after := runner.groups.list()!
	for g in groups_after {
		assert g.guid != group.guid
		assert g.guid != subgroup.guid
	}
}
