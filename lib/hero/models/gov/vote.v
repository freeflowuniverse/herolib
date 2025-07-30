module gov

import freeflowuniverse.herolib.hero.models.core

// Ballot represents a ballot cast in a vote
pub struct Ballot {
pub mut:
	user_id u32
	option  VoteOption
	weight  f64
	cast_at u64 // Unix timestamp
	notes   string
}

// Vote represents a vote in the governance system
pub struct Vote {
	core.Base
pub mut:
	company_id   u32 @[index]
	resolution_id u32 @[index]
	title        string @[index]
	description  string
	status       VoteStatus
	start_date   u64 // Unix timestamp
	end_date     u64 // Unix timestamp
	ballots      []Ballot
}