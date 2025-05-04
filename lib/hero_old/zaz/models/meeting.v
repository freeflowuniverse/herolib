module models

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.encoder

// MeetingStatus represents the status of a meeting
pub enum MeetingStatus {
	scheduled
	completed
	cancelled
}

// AttendeeRole represents the role of an attendee in a meeting
pub enum AttendeeRole {
	coordinator
	member
	secretary
	participant
	advisor
	admin
}

// AttendeeStatus represents the status of an attendee's participation
pub enum AttendeeStatus {
	confirmed
	pending
	declined
}

// Meeting represents a board meeting of a company or other meeting
pub struct Meeting {
pub mut:
	id          u32
	company_id  u32
	title       string
	date        ourtime.OurTime
	location    string
	description string
	status      MeetingStatus
	minutes     string
	created_at  ourtime.OurTime
	updated_at  ourtime.OurTime
	attendees   []Attendee
}

// Attendee represents an attendee of a board meeting
pub struct Attendee {
pub mut:
	id         u32
	meeting_id u32
	user_id    u32
	name       string
	role       AttendeeRole
	status     AttendeeStatus
	created_at ourtime.OurTime
}

// dumps serializes the Meeting to a byte array
pub fn (meeting Meeting) dumps() ![]u8 {
	mut enc := encoder.new()

	// Add unique encoding ID to identify this type of data
	enc.add_u16(404) // Unique ID for Meeting type

	// Encode Meeting fields
	enc.add_u32(meeting.id)
	enc.add_u32(meeting.company_id)
	enc.add_string(meeting.title)
	enc.add_string(meeting.date.str())
	enc.add_string(meeting.location)
	enc.add_string(meeting.description)
	enc.add_u8(u8(meeting.status))
	enc.add_string(meeting.minutes)
	enc.add_string(meeting.created_at.str())
	enc.add_string(meeting.updated_at.str())

	// Encode attendees array
	enc.add_u16(u16(meeting.attendees.len))
	for attendee in meeting.attendees {
		enc.add_u32(attendee.id)
		enc.add_u32(attendee.meeting_id)
		enc.add_u32(attendee.user_id)
		enc.add_string(attendee.name)
		enc.add_u8(u8(attendee.role))
		enc.add_u8(u8(attendee.status))
		enc.add_string(attendee.created_at.str())
	}

	return enc.data
}

// loads deserializes a byte array to a Meeting
pub fn meeting_loads(data []u8) !Meeting {
	mut d := encoder.decoder_new(data)
	mut meeting := Meeting{}

	// Check encoding ID to verify this is the correct type of data
	encoding_id := d.get_u16()!
	if encoding_id != 404 {
		return error('Wrong file type: expected encoding ID 404, got ${encoding_id}, for meeting')
	}

	// Decode Meeting fields
	meeting.id = d.get_u32()!
	meeting.company_id = d.get_u32()!
	meeting.title = d.get_string()!

	date_str := d.get_string()!
	meeting.date = ourtime.new(date_str)!

	meeting.location = d.get_string()!
	meeting.description = d.get_string()!
	meeting.status = unsafe { MeetingStatus(d.get_u8()!) }
	meeting.minutes = d.get_string()!

	created_at_str := d.get_string()!
	meeting.created_at = ourtime.new(created_at_str)!

	updated_at_str := d.get_string()!
	meeting.updated_at = ourtime.new(updated_at_str)!

	// Decode attendees array
	attendees_len := d.get_u16()!
	meeting.attendees = []Attendee{len: int(attendees_len)}
	for i in 0 .. attendees_len {
		mut attendee := Attendee{}
		attendee.id = d.get_u32()!
		attendee.meeting_id = d.get_u32()!
		attendee.user_id = d.get_u32()!
		attendee.name = d.get_string()!
		attendee.role = unsafe { AttendeeRole(d.get_u8()!) }
		attendee.status = unsafe { AttendeeStatus(d.get_u8()!) }

		attendee_created_at_str := d.get_string()!
		attendee.created_at = ourtime.new(attendee_created_at_str)!

		meeting.attendees[i] = attendee
	}

	return meeting
}

// index_keys returns the keys to be indexed for this meeting
pub fn (meeting Meeting) index_keys() map[string]string {
	mut keys := map[string]string{}
	keys['id'] = meeting.id.str()
	keys['company_id'] = meeting.company_id.str()
	return keys
}
