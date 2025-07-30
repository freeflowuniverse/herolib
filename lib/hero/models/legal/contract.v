module legal

import freeflowuniverse.herolib.hero.models.core

// ContractStatus represents the current state of a legal contract
pub enum ContractStatus {
    draft
    pending
    active
    expired
    terminated
    cancelled
}

// ContractType categorizes the type of legal agreement
pub enum ContractType {
    service
    sales
    lease
    employment
    partnership
    nda
    other
}

// Contract represents a legal agreement between parties
// This model stores essential information about contracts including parties, terms, and status
pub struct Contract {
    core.Base
pub mut:
    title string // Human-readable title of the contract @[index]
    contract_type ContractType // Type/category of the contract
    status ContractStatus // Current status of the contract
    party_a string // First party identifier (company, individual, etc.) @[index]
    party_b string // Second party identifier @[index]
    effective_date u64 // Unix timestamp when contract becomes effective
    
    expiration_date u64 // Unix timestamp when contract expires
    
    total_value f64 // Monetary value of the contract
    
    currency string // Currency code (USD, EUR, etc.)
    
    terms string // Full text of the contract terms
    
    signature_date u64 // Unix timestamp when contract was signed
    
    
    version string // Version identifier for contract revisions
    
    parent_contract_id ?u32 // Optional reference to parent contract for amendments @[index]
    
    attachment_urls []string // URLs or paths to attached documents
    
    notes string // Additional notes and comments
}