module biz

import freeflowuniverse.herolib.hero.models.core

// Payment handles financial transactions for companies
pub struct Payment {
    core.Base
pub mut:
    payment_intent_id string // Stripe payment intent ID @[index: 'payment_intent_idx']
    company_id        u32    // Associated company @[index: 'payment_company_idx']
    payment_plan      string // monthly/yearly/two_year
    setup_fee         f64
    monthly_fee       f64
    total_amount      f64
    currency          string // Default: usd
    status            PaymentStatus
    stripe_customer_id string
    completed_at      u64    // Unix timestamp
}

// PaymentStatus tracks the lifecycle of a payment
pub enum PaymentStatus {
    pending
    processing
    completed
    failed
    refunded
}