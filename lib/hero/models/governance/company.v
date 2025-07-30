module governance

import freeflowuniverse.herolib.hero.models.core

// CompanyType categorizes companies
pub enum CompanyType {
    corporation
    llc
    partnership
    cooperative
    nonprofit
}

// CompanyStatus tracks company state
pub enum CompanyStatus {
    active
    inactive
    dissolved
    merged
    acquired
}

// Company represents a governance entity
pub struct Company {
    core.Base
pub mut:
    name string // Company name @[index]
    legal_name string // Legal entity name @[index]
    company_type CompanyType // Type of company
    status CompanyStatus // Current state
    incorporation_date u64 // Unix timestamp
    jurisdiction string // Country/state of incorporation
    registration_number string // Government registration @[index]
    tax_id string // Tax identification
    address string // Primary address
    headquarters string // City/country of HQ
    website string // Company website
    phone string // Contact phone
    email string // Contact email
    shares_authorized u64 // Total authorized shares
    shares_issued u64 // Currently issued shares
    par_value f64 // Par value per share
    currency string // Currency code
    fiscal_year_end string // "MM-DD" format
}