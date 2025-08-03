module governance

import freeflowuniverse.herolib.hero.models.core

// ProposalStatus tracks the state of a governance proposal
pub enum ProposalStatus {
	draft
	pending_review
	active
	voting
	passed
	rejected
	implemented
	cancelled
}

// ProposalType categorizes proposals
pub enum ProposalType {
	constitutional
	policy
	budget
	election
	merger
	dissolution
	other
}

// Proposal represents a governance proposal
pub struct Proposal {
	core.Base
pub mut:
	company_id           u32            // Reference to company @[index]
	title                string         // Proposal title @[index]
	description          string         // Detailed description
	proposal_type        ProposalType   // Category of proposal
	status               ProposalStatus // Current state
	proposer_id          u32            // User who created @[index]
	target_committee_id  u32            // Target committee @[index]
	voting_start         u64            // Start timestamp
	voting_end           u64            // End timestamp
	quorum_required      f64            // Percentage required
	approval_threshold   f64            // Percentage for approval
	votes_for            u32            // Votes in favor
	votes_against        u32            // Votes against
	votes_abstain        u32            // Abstention votes
	implementation_notes string         // Post-implementation notes
}
