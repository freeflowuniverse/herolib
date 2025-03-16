module db

import freeflowuniverse.herolib.circles.base { DBHandler, SessionState, new_dbhandler }
import freeflowuniverse.herolib.circles.mcc.models { CalendarEvent, calendar_event_loads }

@[heap]
pub struct CalendarDB {
pub mut:
	db DBHandler[CalendarEvent]
}

pub fn new_calendardb(session_state SessionState) !CalendarDB {
	return CalendarDB{
		db: new_dbhandler[CalendarEvent]('calendar', session_state)
	}
}

pub fn (mut c CalendarDB) new() CalendarEvent {
	return CalendarEvent{}
}

// set adds or updates a calendar event
pub fn (mut c CalendarDB) set(event CalendarEvent) !CalendarEvent {
	return c.db.set(event)!
}

// get retrieves a calendar event by its ID
pub fn (mut c CalendarDB) get(id u32) !CalendarEvent {
	return c.db.get(id)!
}

// list returns all calendar event IDs
pub fn (mut c CalendarDB) list() ![]u32 {
	return c.db.list()!
}

pub fn (mut c CalendarDB) getall() ![]CalendarEvent {
	return c.db.getall()!
}

// delete removes a calendar event by its ID
pub fn (mut c CalendarDB) delete(id u32) ! {
	c.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_caldav_uid retrieves a calendar event by its CalDAV UID
pub fn (mut c CalendarDB) get_by_caldav_uid(caldav_uid string) !CalendarEvent {
	return c.db.get_by_key('caldav_uid', caldav_uid)!
}

// get_events_by_date retrieves all events that occur on a specific date
pub fn (mut c CalendarDB) get_events_by_date(date string) ![]CalendarEvent {
	// Get all events
	all_events := c.getall()!
	
	// Filter events by date
	mut result := []CalendarEvent{}
	for event in all_events {
		// Check if the event occurs on the specified date
		event_start_date := event.start_time.day()
		event_end_date := event.end_time.day()
		
		if event_start_date <= date && date <= event_end_date {
			result << event
		}
	}
	
	return result
}

// get_events_by_organizer retrieves all events organized by a specific person
pub fn (mut c CalendarDB) get_events_by_organizer(organizer string) ![]CalendarEvent {
	// Get all events
	all_events := c.getall()!
	
	// Filter events by organizer
	mut result := []CalendarEvent{}
	for event in all_events {
		if event.organizer == organizer {
			result << event
		}
	}
	
	return result
}

// get_events_by_attendee retrieves all events that a specific person is attending
pub fn (mut c CalendarDB) get_events_by_attendee(attendee string) ![]CalendarEvent {
	// Get all events
	all_events := c.getall()!
	
	// Filter events by attendee
	mut result := []CalendarEvent{}
	for event in all_events {
		for a in event.attendees {
			if a == attendee {
				result << event
				break
			}
		}
	}
	
	return result
}

// search_events_by_title searches for events with a specific title substring
pub fn (mut c CalendarDB) search_events_by_title(title string) ![]CalendarEvent {
	// Get all events
	all_events := c.getall()!
	
	// Filter events by title
	mut result := []CalendarEvent{}
	for event in all_events {
		if event.title.to_lower().contains(title.to_lower()) {
			result << event
		}
	}
	
	return result
}

// update_status updates the status of an event
pub fn (mut c CalendarDB) update_status(id u32, status string) !CalendarEvent {
	// Get the event by ID
	mut event := c.get(id)!
	
	// Update the status
	event.status = status
	
	// Save the updated event
	return c.set(event)!
}

// delete_by_caldav_uid removes an event by its CalDAV UID
pub fn (mut c CalendarDB) delete_by_caldav_uid(caldav_uid string) ! {
	// Get the event by CalDAV UID
	event := c.get_by_caldav_uid(caldav_uid) or {
		// Event not found, nothing to delete
		return
	}
	
	// Delete the event by ID
	c.delete(event.id)!
}
