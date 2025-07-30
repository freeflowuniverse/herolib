module biz

import freeflowuniverse.herolib.hero.models.core

// Company represents a business entity with all necessary details
pub struct Company {
    core.Base
pub mut:
    name                  string // Company legal name @[index: 'company_name_idx']
    registration_number   string // Official registration number @[index: 'company_reg_idx']
    incorporation_date    u64    // Unix timestamp
    fiscal_year_end      string // Format: MM-DD
    email                 string
    phone                string
    website              string
    address              string
    business_type        BusinessType
    industry             string // Industry classification
    description          string // Company description
    status               CompanyStatus
}

// CompanyStatus tracks the operational state of a company
pub enum CompanyStatus {
    pending_payment
    active
    suspended
    inactive
}

// BusinessType categorizes the company structure
pub enum BusinessType {
    coop
    single
    twin
    starter
    global
}