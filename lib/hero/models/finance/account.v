module finance

import freeflowuniverse.herolib.hero.models.core

// Account represents a financial account for tracking balances and transactions
// Supports multiple account types (checking, savings, investment, etc.)
pub struct Account {
	core.Base
pub mut:
	name         string // User-friendly account name
	account_type AccountType
	balance      f64    // Current balance in the account's currency
	currency     string // Currency code (USD, EUR, etc.)
	description  string // Optional description of the account
	is_active    bool   // Whether the account is currently active
}

// AccountType defines the different types of financial accounts
pub enum AccountType {
	checking
	savings
	investment
	credit
	loan
	crypto
	other
}
