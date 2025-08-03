module gov

import freeflowuniverse.herolib.hero.models.core

// BusinessType represents the type of a business
pub struct BusinessType {
pub mut:
	type_name   string
	description string
}

// Company represents a company in the governance system
pub struct Company {
	core.Base
pub mut:
	name                string @[index]
	registration_number string @[index]
	incorporation_date  u64 // Unix timestamp
	fiscal_year_end     string
	email               string
	phone               string
	website             string
	address             string
	business_type       BusinessType
	industry            string
	description         string
	status              CompanyStatus
}
