module calbox

// Represents a journal entry
@[heap]
pub struct Journal {
	CalendarComponent
pub mut:
	start_time i64 // Date of the journal entry
	attendees  []Attendee
	organizer  ?Attendee
}
