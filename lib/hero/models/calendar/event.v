module calendar

import freeflowuniverse.herolib.hero.models.core

// EventStatus represents the current status of an event
pub enum EventStatus {
    scheduled
    ongoing
    completed
    cancelled
    postponed
}

// EventType categorizes different types of events
pub enum EventType {
    meeting
    appointment
    reminder
    task
    call
    conference
}

// Event represents a calendar event
pub struct Event {
    core.Base
pub mut:
    calendar_id  u32    @[index]
    title        string @[index]
    description  string
    start_time   u64    @[index]
    end_time     u64    @[index]
    location     string
    status       EventStatus
    event_type   EventType
    priority     u8 // 1-5 scale
    is_all_day   bool
    recurrence_rule string // RFC 5545 recurrence rule
    parent_event_id u32 // for recurring events
}

// EventParticipant represents a participant in an event
pub struct EventParticipant {
    core.Base
pub mut:
    event_id  u32 @[index]
    user_id   u32 @[index]
    email     string @[index]
    name      string
    role      string // attendee, organizer, optional
    status    string // accepted, declined, tentative, pending
    response_time u64
}