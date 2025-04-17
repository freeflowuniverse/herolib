impl Currency {
    /// Create a new currency with amount and code
    pub fn new(amount: f64, currency_code: String) -> Self {
        Self {
            amount,
            currency_code,
        }
    }

    /// Convert the currency to USD
    pub fn to_usd(&self) -> Option<Currency> {
        if self.currency_code == "USD" {
            return Some(self.clone());
        }

        EXCHANGE_RATE_SERVICE.convert(self.amount, &self.currency_code, "USD")
            .map(|amount| Currency::new(amount, "USD".to_string()))
    }

    /// Convert the currency to another currency
    pub fn to_currency(&self, target_currency: &str) -> Option<Currency> {
        if self.currency_code == target_currency {
            return Some(self.clone());
        }

        EXCHANGE_RATE_SERVICE.convert(self.amount, &self.currency_code, target_currency)
            .map(|amount| Currency::new(amount, target_currency.to_string()))
    }
}