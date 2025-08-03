module circle

import freeflowuniverse.herolib.hero.models.core

// Wallet represents a wallet associated with a circle for financial operations
pub struct Wallet {
	core.Base
pub mut:
	circle_id     u32          // Reference to the circle this wallet belongs to @[index]
	address       string       // Blockchain address for this wallet @[index]
	type          WalletType   // Type of wallet (custodial/non-custodial)
	balance       f64          // Current balance in the wallet
	currency      string       // Currency type (e.g., "USD", "BTC", "ETH")
	is_primary    bool         // Whether this is the primary wallet for the circle
	status        WalletStatus // Current wallet status
	last_activity u64          // Unix timestamp of last transaction
}

// WalletType defines the types of wallets supported
pub enum WalletType {
	custodial
	non_custodial
	hardware
	software
}

// WalletStatus represents the operational status of a wallet
pub enum WalletStatus {
	active
	inactive
	frozen
	archived
}
