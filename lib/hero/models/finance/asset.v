module finance

import freeflowuniverse.herolib.hero.models.core

// Asset represents any valuable resource owned by an entity
// Can be financial (stocks, bonds) or physical (real estate, commodities)
pub struct Asset {
    core.Base
pub mut:
    name          string // Asset name or identifier
    symbol        string // Trading symbol or identifier @[index]
    asset_type    AssetType
    quantity      f64    // Amount of the asset held
    unit_price    f64    // Price per unit in the asset's currency
    total_value   f64    // total_value = quantity * unit_price
    currency      string // Currency for pricing (USD, EUR, etc.)
    category      string // Asset category (stocks, bonds, crypto, etc.)
    exchange      string // Exchange where asset is traded
    description   string // Detailed description of the asset
    is_active     bool   // Whether the asset is currently tracked
    purchase_date u64    // Unix timestamp of purchase/acquisition
}

// AssetType defines the classification of assets
pub enum AssetType {
    stock
    bond
    crypto
    commodity
    real_estate
    currency
    nft
    other
}