module models

import freeflowuniverse.herolib.data.encoder

pub struct Contact {
pub mut:
	// Database ID
	id u32 // Database ID (assigned by DBHandler)
	// Content fields
	created_at  i64 // Unix epoch timestamp
	modified_at i64 // Unix epoch timestamp
	first_name  string
	last_name   string
	email       string
	group       string
}

// dumps serializes the CalendarEvent to a byte array
pub fn (event Contact) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(303) // Unique ID for CalendarEvent type

	enc.add_u32(event.id)
	enc.add_i64(event.created_at)
	enc.add_i64(event.modified_at)
	enc.add_string(event.first_name)
	enc.add_string(event.last_name)
	enc.add_string(event.email)
	enc.add_string(event.group)

	return enc.data
}

// loads deserializes a byte array to a Contact
pub fn contact_event_loads(data []u8) !Contact {
	mut d := encoder.decoder_new(data)
	mut event := Contact{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 303 {
		return error('Wrong file type: expected encoding ID 303, got ${encoding_id}, for calendar event')
	}

	// Decode Contact fields
	event.id = d.get_u32()!
	event.created_at = d.get_i64()!
	event.modified_at = d.get_i64()!
	event.first_name = d.get_string()!
	event.last_name = d.get_string()!
	event.email = d.get_string()!
	event.group = d.get_string()!

	return event
}

// index_keys returns the keys to be indexed for this event
pub fn (event Contact) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = event.id.str()
	// if event.caldav_uid != '' {
	//     keys['caldav_uid'] = event.caldav_uid
	// }
	return keys
}
