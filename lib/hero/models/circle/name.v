module circle

import freeflowuniverse.herolib.hero.models.core

// Name represents a domain name configuration for a circle
pub struct Name {
	core.Base
pub mut:
	circle_id   u32      // Reference to the circle this name belongs to @[index]
	domain      string   // The actual domain name @[index]
	subdomain   string   // Optional subdomain
	record_type NameType // Type of DNS record
	value       string   // DNS record value/target
	priority    u32      // Priority for MX records
	ttl         u32      // Time to live in seconds
	is_active   bool     // Whether this record is currently active
}

// NameType defines the supported DNS record types
pub enum NameType {
	a
	aaaa
	cname
	mx
	txt
	srv
}
