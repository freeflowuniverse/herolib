use crate::shareholder::{Shareholder};
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// CompanyStatus represents the status of a company
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum CompanyStatus {
    Active,
    Inactive,
    Suspended,
}

/// BusinessType represents the type of a business
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum BusinessType {
    Coop,
    Single,
    Twin,
    Starter,
    Global,
}

/// Company represents a company registered in the Freezone
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Company {
    pub id: u32,
    pub name: String,
    pub registration_number: String,
    pub incorporation_date: DateTime<Utc>,
    pub fiscal_year_end: String,
    pub email: String,
    pub phone: String,
    pub website: String,
    pub address: String,
    pub business_type: BusinessType,
    pub industry: String,
    pub description: String,
    pub status: CompanyStatus,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub shareholders: Vec<Shareholder>,
}

impl Company {
    /// Returns the keys to be indexed for this company
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("name".to_string(), self.name.clone());
        keys.insert("registration_number".to_string(), self.registration_number.clone());
        keys
    }
}
