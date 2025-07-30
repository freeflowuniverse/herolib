module gov

import freeflowuniverse.herolib.hero.models.core

// CommitteeMember represents a member of a committee
pub struct CommitteeMember {
pub struct CommitteeMember {
    core.Base
pub mut:
	user_id     u32
	name        string
	role        CommitteeRole
	joined_date u64 // Unix timestamp
	notes       string
}

// Committee represents a committee in the governance system
pub struct Committee {
	core.Base
pub mut:
	company_id    u32 @[index]
	name          string @[index]
	description   string
	members       []CommitteeMember
}