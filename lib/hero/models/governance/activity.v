module governance

import freeflowuniverse.herolib.hero.models.core


pub struct GovernanceActivity {
    core.Base
pub mut:
    company_id u32 // Reference to company @[index]
    activity_type string // Type of activity (proposal, vote, meeting, etc.) @[index]
    description string // Detailed description
    initiator_id u32 // User who initiated @[index]
    target_id u32 // Target entity ID
    target_type string // Type of target (user, proposal, etc.)
    metadata string // JSON metadata
}

// Activity types
pub enum ActivityType {
    proposal_created
    proposal_updated
    vote_cast
    meeting_scheduled
    resolution_passed
    shareholder_added
}