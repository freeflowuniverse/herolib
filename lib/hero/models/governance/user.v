module governance

import freeflowuniverse.herolib.hero.models.core

// UserType defines user categories
pub enum UserType {
	individual
	corporate
	system
}

// UserStatus tracks user state
pub enum UserStatus {
	active
	inactive
	suspended
	pending
}

// UserRole defines governance roles
pub enum UserRole {
	shareholder
	director
	officer
	employee
	auditor
	consultant
	administrator
}

// User represents a governance participant
pub struct User {
	core.Base
pub mut:
	username        string     // Unique username @[index]
	email           string     // Email address @[index]
	first_name      string     // First name
	last_name       string     // Last name
	display_name    string     // Preferred display name
	user_type       UserType   // Type of user
	status          UserStatus // Current state
	roles           []UserRole // Governance roles
	company_id      u32        // Primary company @[index]
	phone           string     // Contact phone
	address         string     // Contact address
	profile_picture string     // Profile picture URL
	last_login      u64        // Last login timestamp
}
