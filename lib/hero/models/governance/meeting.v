module governance

import freeflowuniverse.herolib.hero.models.core

// MeetingType defines meeting categories
pub enum MeetingType {
    annual_general
    extraordinary_general
    board
    committee
    special
}

// MeetingStatus tracks meeting state
pub enum MeetingStatus {
    scheduled
    in_progress
    completed
    cancelled
    postponed
}

// Meeting represents a governance meeting
pub struct Meeting {
    core.Base
pub mut:
    company_id u32 // Reference to company @[index]
    committee_id u32 // Reference to committee @[index]
    meeting_type MeetingType // Type of meeting
    title string // Meeting title @[index]
    description string // Detailed description
    status MeetingStatus // Current state
    scheduled_start u64 // Scheduled start time
    scheduled_end u64 // Scheduled end time
    actual_start u64 // Actual start time
    actual_end u64 // Actual end time
    location string // Physical/virtual location
    meeting_url string // Video conference link
    agenda string // Meeting agenda
    minutes string // Meeting minutes
    quorum_required u32 // Members required for quorum
    quorum_present bool // Whether quorum was achieved
    created_by u32 // User who scheduled @[index]
}