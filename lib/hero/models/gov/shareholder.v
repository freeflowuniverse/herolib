module gov

import freeflowuniverse.herolib.hero.models.core

// Shareholder represents a shareholder in the governance system
pub struct Shareholder {
	core.Base
pub mut:
	company_id       u32    @[index]
	name             string @[index]
	shareholder_type ShareholderType
	contact_info     string @[index]
	shares           u32
	percentage       f64
}
