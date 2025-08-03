module governance

import freeflowuniverse.herolib.hero.models.core

// CommitteeType defines committee categories
pub enum CommitteeType {
	board
	executive
	audit
	compensation
	nomination
	governance
	finance
	risk
	other
}

// CommitteeStatus tracks committee state
pub enum CommitteeStatus {
	active
	inactive
	dissolved
}

// Committee represents a governance committee
pub struct Committee {
	core.Base
pub mut:
	company_id        u32             // Reference to company @[index]
	name              string          // Committee name @[index]
	committee_type    CommitteeType   // Type of committee
	description       string          // Detailed description
	status            CommitteeStatus // Current state
	chairman_id       u32             // Committee chair @[index]
	term_start        u64             // Start of term
	term_end          u64             // End of term
	meeting_frequency string          // e.g., "monthly", "quarterly"
	quorum_size       u32             // Minimum members for quorum
}
