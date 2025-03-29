use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// ShareholderType represents the type of shareholder
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ShareholderType {
    Individual,
    Corporate,
}

/// Shareholder represents a shareholder of a company
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Shareholder {
    pub id: u32,
    pub company_id: u32,
    pub user_id: u32,
    pub name: String,
    pub shares: f64,
    pub percentage: f64,
    pub type_: ShareholderType,
    pub since: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

impl Shareholder {
    /// Returns the keys to be indexed for this shareholder
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("company_id".to_string(), self.company_id.to_string());
        keys.insert("user_id".to_string(), self.user_id.to_string());
        keys
    }
}
