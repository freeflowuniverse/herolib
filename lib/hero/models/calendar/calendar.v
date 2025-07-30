module calendar

import freeflowuniverse.herolib.hero.models.core

// Calendar represents a calendar with events and scheduling capabilities
pub struct Calendar {
    core.Base
pub mut:
    name        string @[index]
    description string
    color       string // hex color code
    timezone    string
    owner_id    u32    @[index]
    is_public   bool
}