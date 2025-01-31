module model

import freeflowuniverse.herolib.core.redisclient
import json

const groups_key = 'herorunner:groups' // Redis key for storing groups

// GroupManager handles all group-related operations
pub struct GroupManager {
mut:
	redis &redisclient.Redis
}

// new creates a new Group instance
pub fn (mut m GroupManager) new() Group {
	return Group{
		guid:    '' // Empty GUID to be filled by caller
		members: []string{}
	}
}

// add adds a new group to Redis
pub fn (mut m GroupManager) set(group Group) ! {
	// Store group in Redis hash where key is group.guid and value is JSON of group
	group_json := json.encode(group)
	m.redis.hset(groups_key, group.guid, group_json)!
}

// get retrieves a group by its GUID
pub fn (mut m GroupManager) get(guid string) !Group {
	group_json := m.redis.hget(groups_key, guid)!
	return json.decode(Group, group_json)
}

// list returns all groups
pub fn (mut m GroupManager) list() ![]Group {
	mut groups := []Group{}

	// Get all groups from Redis hash
	groups_map := m.redis.hgetall(groups_key)!

	// Convert each JSON value to Group struct
	for _, group_json in groups_map {
		group := json.decode(Group, group_json)!
		groups << group
	}

	return groups
}

// delete removes a group by its GUID
pub fn (mut m GroupManager) delete(guid string) ! {
	m.redis.hdel(groups_key, guid)!
}

// add_member adds a member (user pubkey or group GUID) to a group
pub fn (mut m GroupManager) add_member(guid string, member string) ! {
	mut group := m.get(guid)!
	if member !in group.members {
		group.members << member
		m.set(group)!
	}
}

// remove_member removes a member from a group
pub fn (mut m GroupManager) remove_member(guid string, member string) ! {
	mut group := m.get(guid)!
	group.members = group.members.filter(it != member)
	m.set(group)!
}

pub fn (mut m GroupManager) get_user_groups(user_pubkey string) ![]Group {
	mut user_groups := []Group{}
	mut checked_groups := map[string]bool{}
	groups := m.list()!
	// Check each group
	for group in groups {
		check_group_membership(group, user_pubkey, groups, mut checked_groups, mut user_groups)
	}
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
