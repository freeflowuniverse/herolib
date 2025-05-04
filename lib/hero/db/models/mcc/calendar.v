module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.hero.db.models.base

// CalendarEvent represents a calendar event with all its properties
pub struct CalendarEvent {
	base.Base
pub mut:
	title       string // Event title
	description string // Event details
	location    string // Event location
	start_time  ourtime.OurTime
	end_time    ourtime.OurTime // End time
	all_day     bool            // True if it's an all-day event
	recurrence  string          // RFC 5545 Recurrence Rule (e.g., "FREQ=DAILY;COUNT=10")
	attendees   []u32        // List of contact id's
	organizer   u32          // The user (see circle) who created the event
	status      string          // "CONFIRMED", "CANCELLED", "TENTATIVE" //TODO: make enum
	color       string          // User-friendly color categorization, e.g., "red", "blue" //TODO: make enum
	reminder    []ourtime.OurTime // Reminder time before the event
}


pub fn (self Asset) index_keys() map[string]string {
	return {
		'name': self.name
	}
}

pub fn (self Asset) ftindex_keys() map[string]string {
	return map[string]string{}
}
