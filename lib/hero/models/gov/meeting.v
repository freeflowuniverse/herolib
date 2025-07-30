module gov

import freeflowuniverse.herolib.hero.models.core

// Attendee represents an attendee of a meeting
pub struct Attendee {
pub mut:
	user_id u32
	name    string
	role    string
	status  AttendanceStatus
	notes   string
}

// Meeting represents a meeting in the governance system
pub struct Meeting {
	core.Base
pub mut:
	company_id  u32 @[index]
	title       string @[index]
	description string
	meeting_type MeetingType
	status      MeetingStatus
	start_time  u64 // Unix timestamp
	end_time    u64 // Unix timestamp
	location    string
	agenda      string
	minutes     string
	attendees   []Attendee
}