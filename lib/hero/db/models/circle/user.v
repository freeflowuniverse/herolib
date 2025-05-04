module circle

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.hero.db.models.base

// Role represents the role of a member in a circle
pub enum Role {
	admin
	stakeholder
	member
	contributor
	guest
	external //means no right in this circle appart from we register this user
}

// Member represents a member of a circle
pub struct User {
	base.Base
pub mut:
	name        string   // name of the member as used in this circle
	description string   // optional description which is relevant to this circle
	role        Role     // role of the member in the circle
	contact_ids []u32    // IDs of contacts linked to this member
	wallet_ids  []u32    // IDs of wallets owned by this member which are relevant to this circle
	pubkey	  string   // public key of the member as used in this circle
}

pub fn (self User) index_keys() map[string]string {
	return {
		'name': self.name
	}
}

pub fn (self User) ftindex_keys() map[string]string {
	return {
		'description': self.description,
	}
}
