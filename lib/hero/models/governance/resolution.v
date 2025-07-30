module governance

import freeflowuniverse.herolib.hero.models.core

// ResolutionStatus tracks resolution state
pub enum ResolutionStatus {
    proposed
    voting
    passed
    failed
    implemented
    withdrawn
}

// ResolutionType categorizes resolutions
pub enum ResolutionType {
    ordinary
    special
    unanimous
}

// Resolution represents a formal resolution
pub struct Resolution {
    core.Base
pub mut:
    company_id u32 // Reference to company @[index]
    meeting_id u32 // Reference to meeting @[index]
    proposal_id u32 // Reference to proposal @[index]
    resolution_number string // Unique resolution number @[index]
    title string // Resolution title @[index]
    description string // Detailed description
    resolution_type ResolutionType // Category
    status ResolutionStatus // Current state
    mover_id u32 // Person who moved @[index]
    seconder_id u32 // Person who seconded @[index]
    votes_for u32 // Votes in favor
    votes_against u32 // Votes against
    votes_abstain u32 // Abstention votes
    effective_date u64 // When resolution takes effect
}