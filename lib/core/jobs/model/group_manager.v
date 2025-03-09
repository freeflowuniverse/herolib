module model

import json

// GroupManager handles all group-related operations
pub struct GroupManager {
}

// new creates a new Group instance
pub fn (mut m GroupManager) new() Group {
	return Group{
		guid:    '' // Empty GUID to be filled by caller
		members: []string{}
	}
}

// set adds or updates a group
pub fn (mut m GroupManager) set(group Group) ! {
	// Implementation removed
}

// get retrieves a group by its GUID
pub fn (mut m GroupManager) get(guid string) !Group {
	// Implementation removed
	return Group{}
}

// list returns all groups
pub fn (mut m GroupManager) list() ![]Group {
	mut groups := []Group{}

	// Implementation removed

	return groups
}

// delete removes a group by its GUID
pub fn (mut m GroupManager) delete(guid string) ! {
	// Implementation removed
}

// add_member adds a member (user pubkey or group GUID) to a group
pub fn (mut m GroupManager) add_member(guid string, member string) ! {
	// Implementation removed
}

// remove_member removes a member from a group
pub fn (mut m GroupManager) remove_member(guid string, member string) ! {
	// Implementation removed
}

pub fn (mut m GroupManager) get_user_groups(user_pubkey string) ![]Group {
	mut user_groups := []Group{}
	// Implementation removed
	return user_groups
}

// Recursive function to check group membership
fn check_group_membership(group Group, user string, groups []Group, mut checked map[string]bool, mut result []Group) {
	if group.guid in checked {
		return
	}
	checked[group.guid] = true

	if user in group.members {
		result << group
		// Check parent groups
		for parent_group in groups {
			if group.guid in parent_group.members {
				check_group_membership(parent_group, user, groups, mut checked, mut result)
			}
		}
	}
}
