module calendar

import freeflowuniverse.herolib.hero.models.core

// Contact represents a contact or address book entry
pub struct Contact {
    core.Base
pub mut:
    name        string @[index]
    email       string @[index]
    phone       string
    address     string
    company     string
    job_title   string
    notes       string
    tags        []string
    birthday    u64
    is_favorite bool
}

// ContactGroup represents a group of contacts
pub struct ContactGroup {
    core.Base
pub mut:
    name        string @[index]
    description string
    color       string
}

// ContactGroupMembership links contacts to groups
pub struct ContactGroupMembership {
    core.Base
pub mut:
    contact_id u32 @[index]
    group_id  u32 @[index]
}