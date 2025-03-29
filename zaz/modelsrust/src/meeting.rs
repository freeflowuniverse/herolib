use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// MeetingStatus represents the status of a meeting
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum MeetingStatus {
    Scheduled,
    Completed,
    Cancelled,
}

/// AttendeeRole represents the role of an attendee in a meeting
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum AttendeeRole {
    Coordinator,
    Member,
    Secretary,
    Participant,
    Advisor,
    Admin,
}

/// AttendeeStatus represents the status of an attendee's participation
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum AttendeeStatus {
    Confirmed,
    Pending,
    Declined,
}

/// Attendee represents an attendee of a board meeting
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Attendee {
    pub id: u32,
    pub meeting_id: u32,
    pub user_id: u32,
    pub name: String,
    pub role: AttendeeRole,
    pub status: AttendeeStatus,
    pub created_at: DateTime<Utc>,
}

/// Meeting represents a board meeting of a company or other meeting
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Meeting {
    pub id: u32,
    pub company_id: u32,
    pub title: String,
    pub date: DateTime<Utc>,
    pub location: String,
    pub description: String,
    pub status: MeetingStatus,
    pub minutes: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub attendees: Vec<Attendee>,
}

impl Meeting {
    /// Returns the keys to be indexed for this meeting
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("company_id".to_string(), self.company_id.to_string());
        keys
    }
}
