module biz

import freeflowuniverse.herolib.hero.models.core

// Shareholder tracks company ownership details
pub struct Shareholder {
	core.Base
pub mut:
	company_id u32
	user_id    u32
	name       string
	shares     f64
	percentage f64
	type_      ShareholderType
	since      u64 // Unix timestamp
}

// ShareholderType distinguishes between individual and corporate owners
pub enum ShareholderType {
	individual
	corporate
}
