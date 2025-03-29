use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// User represents a user in the Freezone Manager system
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: u32,
    pub name: String,
    pub email: String,
    pub password: String,
    pub company: String, // here its just a best effort
    pub role: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

impl User {
    /// Returns the keys to be indexed for this user
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("email".to_string(), self.email.clone());
        keys
    }
}
