use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// Currency represents a monetary value with amount and currency code
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Currency {
    pub amount: f64,
    pub currency_code: String,
}

/// ProductType represents the type of a product
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ProductType {
    Product,
    Service,
}

/// ProductStatus represents the status of a product
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ProductStatus {
    Available,
    Unavailable,
}

/// ProductComponent represents a component of a product
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProductComponent {
    pub id: u32,
    pub name: String,
    pub description: String,
    pub quantity: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

/// Product represents a product or service offered by the Freezone
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Product {
    pub id: u32,
    pub name: String,
    pub description: String,
    pub price: Currency,
    pub type_: ProductType,
    pub category: String,
    pub status: ProductStatus,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub max_amount: u16, // means allows us to define how many max of this there are
    pub purchase_till: DateTime<Utc>,
    pub active_till: DateTime<Utc>, // after this product no longer active if e.g. a service
    pub components: Vec<ProductComponent>,
}

impl Product {
    /// Returns the keys to be indexed for this product
    pub fn index_keys(&self) -> HashMap<String, String> {
        let mut keys = HashMap::new();
        keys.insert("id".to_string(), self.id.to_string());
        keys.insert("name".to_string(), self.name.clone());
        keys
    }
}
