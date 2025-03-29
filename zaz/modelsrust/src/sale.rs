use crate::product::Currency;
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// SaleStatus represents the status of a sale
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum SaleStatus {
    Pending,
    Completed,
    Cancelled,
}

/// SaleItem represents an item in a sale
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SaleItem {
    pub id: u32,
    pub sale_id: u32,
    pub product_id: u32,
    pub name: String,
    pub quantity: i32,
    pub unit_price: Currency,
    pub subtotal: Currency,
    pub active_till: DateTime<Utc>, // after this product no longer active if e.g. a service
}

/// Sale represents a sale of products or services
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Sale {
    pub id: u32,
    pub company_id: u32,
    pub buyer_name: String,
    pub buyer_email: String,
    pub total_amount: Currency,
    pub status: SaleStatus,
    pub sale_date: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub items: Vec<SaleItem>,
}

impl Sale {
    /// Returns the keys to be indexed for this sale
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("company_id".to_string(), self.company_id.to_string());
        keys
    }
}
