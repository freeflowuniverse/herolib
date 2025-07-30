module biz

import freeflowuniverse.herolib.hero.models.core

// Sale represents a transaction linking buyers to products
pub struct Sale {
	core.Base
pub mut:
	company_id     u32
	buyer_id       u32
	transaction_id u32
	total_amount   f64
	status         SaleStatus
	sale_date      u64 // Unix timestamp
	items          []SaleItem
	notes          string
}

// SaleItem captures product details at time of sale
pub struct SaleItem {
pub mut:
	product_id           u32
	name                 string // Product name snapshot
	quantity             i32
	unit_price           f64
	subtotal             f64
	service_active_until u64 // Optional service expiry
}

// SaleStatus tracks transaction state
pub enum SaleStatus {
	pending
	completed
	cancelled
}
