module governance

import freeflowuniverse.herolib.hero.models.core

// VoteValue represents voting choices
pub enum VoteValue {
	yes
	no
	abstain
}

// VoteStatus tracks vote state
pub enum VoteStatus {
	pending
	cast
	changed
	retracted
}

// Vote represents a governance vote
pub struct Vote {
	core.Base
pub mut:
	proposal_id    u32        // Reference to proposal @[index]
	resolution_id  u32        // Reference to resolution @[index]
	voter_id       u32        // User who voted @[index]
	company_id     u32        // Reference to company @[index]
	vote_value     VoteValue  // Voting choice
	status         VoteStatus // Current state
	weight         u32        // Vote weight (for weighted voting)
	comments       string     // Optional comments
	proxy_voter_id u32        // If voting by proxy @[index]
	ip_address     string     // IP address for verification
}
