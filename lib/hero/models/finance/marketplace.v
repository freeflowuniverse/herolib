module finance

import freeflowuniverse.herolib.hero.models.core

// Marketplace represents a platform for buying and selling goods/services
// Can be internal or external marketplace configurations
pub struct Marketplace {
	core.Base
pub mut:
	name             string // Marketplace name (e.g., "Amazon", "eBay") @[index]
	marketplace_type MarketplaceType
	api_endpoint     string // API endpoint for marketplace integration
	api_key          string // Authentication key for API access
	currency         string // Default currency for transactions
	fee_percentage   f64    // Marketplace fee as percentage (0.0-100.0)
	is_active        bool   // Whether marketplace is currently enabled
	description      string // Detailed marketplace description
	support_email    string // Contact email for support issues
}

// MarketplaceType defines the type of marketplace platform
pub enum MarketplaceType {
	centralized
	decentralized
	peer_to_peer
	auction
	classified
	other
}
