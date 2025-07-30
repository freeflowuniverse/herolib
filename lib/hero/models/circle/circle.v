module circle

import freeflowuniverse.herolib.hero.models.core

// Circle represents a circle entity with configuration and metadata
pub struct Circle {
	core.Base
pub mut:
	name        string       // Human-readable name of the circle
	description string       // Detailed description of the circle's purpose
	domain      string       // Primary domain name for the circle @[index]
	config      CircleConfig // Configuration settings for the circle
	status      CircleStatus // Current operational status
}

// CircleConfig holds configuration settings for a circle
pub struct CircleConfig {
pub mut:
	max_members  u32    // Maximum number of members allowed
	allow_guests bool   // Whether to allow guest access
	auto_approve bool   // Whether new members are auto-approved
	theme        string // Visual theme identifier
}

// CircleStatus represents the operational status of a circle
pub enum CircleStatus {
	active
	inactive
	suspended
	archived
}
