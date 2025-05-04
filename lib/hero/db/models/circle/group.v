module circle

import freeflowuniverse.herolib.hero.db.models.base

// there is one group called "everyone" which is the default group for all members and their roles
pub struct Group {
	base.Base
pub mut:
	name        string // name of the group in a circle, the one "everyone" is the default group
	description string // optional description
	members     []u32  // pointers to the members of this group
}

pub fn (self Group) index_keys() map[string]string {
	return {
		'name': self.name
	}
}

pub fn (self Group) ftindex_keys() map[string]string {
	return {
		'description': self.description
		'members':     self.members.map(it.str()).join(',')
	}
}
