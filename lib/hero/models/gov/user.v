module gov

import freeflowuniverse.herolib.hero.models.core

// User represents a user in the governance system
pub struct User {
	core.Base
pub mut:
	name  string @[index]
	email string @[index]
	role  string
}
