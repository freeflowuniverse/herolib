module biz

import freeflowuniverse.herolib.hero.models.core

// Product represents goods or services offered by a company
pub struct Product {
    core.Base
pub mut:
    name           string
    description    string
    price          f64
    type_          ProductType
    category       string
    status         ProductStatus
    max_amount     u16
    purchase_till  u64 // Unix timestamp
    active_till    u64 // Unix timestamp
    components     []ProductComponent
}

// ProductComponent represents sub-parts of a complex product
pub struct ProductComponent {
pub mut:
    name        string
    description string
    quantity    u32
}

// ProductType differentiates between products and services
pub enum ProductType {
    product
    service
}

// ProductStatus indicates availability
pub enum ProductStatus {
    available
    unavailable
}