use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// VoteStatus represents the status of a vote
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum VoteStatus {
    Open,
    Closed,
    Cancelled,
}

/// Vote represents a voting item in the Freezone
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Vote {
    pub id: u32,
    pub company_id: u32,
    pub title: String,
    pub description: String,
    pub start_date: DateTime<Utc>,
    pub end_date: DateTime<Utc>,
    pub status: VoteStatus,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub options: Vec<VoteOption>,
    pub ballots: Vec<Ballot>,
    pub private_group: Vec<u32>, // user id's only people who can vote
}

/// VoteOption represents an option in a vote
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct VoteOption {
    pub id: u8,
    pub vote_id: u32,
    pub text: String,
    pub count: i32,
    pub min_valid: i32, // min votes we need to make total vote count
}

/// The vote as done by the user
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Ballot {
    pub id: u32,
    pub vote_id: u32,
    pub user_id: u32,
    pub vote_option_id: u8,
    pub shares_count: i32,
    pub created_at: DateTime<Utc>,
}

impl Vote {
    /// Returns the keys to be indexed for this vote
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("company_id".to_string(), self.company_id.to_string());
        keys
    }
}
