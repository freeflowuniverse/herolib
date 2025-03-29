# Zaz Models (Rust)

This project is a Rust port of the Zaz models originally implemented in V.

## Overview

This library provides data models for the Zaz application, focusing on core business entities. It includes models for:

- Users
- Companies
- Shareholders
- Meetings
- Products
- Sales
- Votes

## Models

Each model includes:
- Type-safe struct definitions
- Proper enums for status fields
- Serde serialization/deserialization support
- Index key functionality for database operations

## Usage

Add this to your `Cargo.toml`:

```toml
[dependencies]
zaz_models = { path = "path/to/zaz/modelsrust" }
```

Example usage:

```rust
use zaz_models::{User, Company, Vote, VoteStatus};
use chrono::Utc;

// Create a new user
let user = User {
    id: 1,
    name: "John Doe".to_string(),
    email: "john@example.com".to_string(),
    password: "secure_hash".to_string(),
    company: "Acme Inc".to_string(),
    role: "Admin".to_string(),
    created_at: Utc::now(),
    updated_at: Utc::now(),
};

// Access index keys
let keys = user.index_keys();
assert_eq!(keys.get("id").unwrap(), "1");
assert_eq!(keys.get("email").unwrap(), "john@example.com");

// Use with serde for JSON serialization
let json = serde_json::to_string(&user).unwrap();
println!("{}", json);

// Deserialize from JSON
let deserialized_user: User = serde_json::from_str(&json).unwrap();
assert_eq!(deserialized_user.name, "John Doe");
```

## Notes

This port focuses on the data structures only. The original encoding/decoding functionality has been replaced with serde serialization/deserialization.
