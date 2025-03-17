module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// CalendarEvent represents a calendar event with all its properties
pub struct CalendarEvent {
pub mut:
	id          u32    // Unique identifier
	title       string // Event title
	description string // Event details
	location    string // Event location
	start_time  ourtime.OurTime
	end_time    ourtime.OurTime // End time
	all_day     bool            // True if it's an all-day event
	recurrence  string          // RFC 5545 Recurrence Rule (e.g., "FREQ=DAILY;COUNT=10")
	attendees   []string        // List of emails or user IDs
	organizer   string          // Organizer email
	status      string          // "CONFIRMED", "CANCELLED", "TENTATIVE"
	caldav_uid  string          // CalDAV UID for syncing
	sync_token  string          // Sync token for tracking changes
	etag        string          // ETag for caching
	color       string          // User-friendly color categorization
}

// dumps serializes the CalendarEvent to a byte array
pub fn (event CalendarEvent) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(302) // Unique ID for CalendarEvent type

	// Encode CalendarEvent fields
	enc.add_u32(event.id)
	enc.add_string(event.title)
	enc.add_string(event.description)
	enc.add_string(event.location)

	// Encode start_time and end_time as strings
	enc.add_string(event.start_time.str())
	enc.add_string(event.end_time.str())

	// Encode all_day as u8 (0 or 1)
	enc.add_u8(if event.all_day { u8(1) } else { u8(0) })

	enc.add_string(event.recurrence)

	// Encode attendees array
	enc.add_u16(u16(event.attendees.len))
	for attendee in event.attendees {
		enc.add_string(attendee)
	}

	enc.add_string(event.organizer)
	enc.add_string(event.status)
	enc.add_string(event.caldav_uid)
	enc.add_string(event.sync_token)
	enc.add_string(event.etag)
	enc.add_string(event.color)

	return enc.data
}

// loads deserializes a byte array to a CalendarEvent
pub fn calendar_event_loads(data []u8) !CalendarEvent {
	mut d := encoder.decoder_new(data)
	mut event := CalendarEvent{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 302 {
		return error('Wrong file type: expected encoding ID 302, got ${encoding_id}, for calendar event')
	}

	// Decode CalendarEvent fields
	event.id = d.get_u32()!
	event.title = d.get_string()!
	event.description = d.get_string()!
	event.location = d.get_string()!

	// Decode start_time and end_time from strings
	start_time_str := d.get_string()!
	event.start_time = ourtime.new(start_time_str)!

	end_time_str := d.get_string()!
	event.end_time = ourtime.new(end_time_str)!

	// Decode all_day from u8
	event.all_day = d.get_u8()! == 1

	event.recurrence = d.get_string()!

	// Decode attendees array
	attendees_len := d.get_u16()!
	event.attendees = []string{len: int(attendees_len)}
	for i in 0 .. attendees_len {
		event.attendees[i] = d.get_string()!
	}

	event.organizer = d.get_string()!
	event.status = d.get_string()!
	event.caldav_uid = d.get_string()!
	event.sync_token = d.get_string()!
	event.etag = d.get_string()!
	event.color = d.get_string()!

	return event
}

// index_keys returns the keys to be indexed for this event
pub fn (event CalendarEvent) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = event.id.str()
	// if event.caldav_uid != '' {
	//     keys['caldav_uid'] = event.caldav_uid
	// }
	return keys
}
