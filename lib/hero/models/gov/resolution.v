module gov

import freeflowuniverse.herolib.hero.models.core

// Resolution represents a resolution in the governance system
pub struct Resolution {
	core.Base
pub mut:
	company_id      u32    @[index]
	title           string @[index]
	description     string
	resolution_type ResolutionType
	status          ResolutionStatus
	proposed_date   u64  // Unix timestamp
	effective_date  ?u64 // Unix timestamp
	expiry_date     ?u64 // Unix timestamp
	approvals       []string
}
