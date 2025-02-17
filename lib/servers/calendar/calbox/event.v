module calbox

// Represents an event
@[heap]
pub struct Event {
	CalendarComponent
pub mut:
	start_time i64
	end_time   ?i64    // Either end_time or duration must be set
	duration   ?string // ISO 8601 duration format
	rrule      ?RecurrenceRule
	rdate      []i64 // Additional recurrence dates
	exdate     []i64 // Dates to exclude
	transp     EventTransp
	attendees  []Attendee
	organizer  ?Attendee
}

// Event transparency (busy time)
pub enum EventTransp {
	opaque      // Blocks time (shows as busy)
	transparent // Does not block time (shows as free)
}

// String representation of event transparency
pub fn (t EventTransp) str() string {
	return match t {
		.opaque { 'OPAQUE' }
		.transparent { 'TRANSPARENT' }
	}
}

// Parse event transparency from string
pub fn parse_event_transp(s string) !EventTransp {
	return match s {
		'OPAQUE' { EventTransp.opaque }
		'TRANSPARENT' { EventTransp.transparent }
		else { error('Invalid event transparency: ${s}') }
	}
}

// Checks if an event overlaps with a time range
fn (event Event) overlaps(tr TimeRange) bool {
	// Get end time from either end_time or duration
	mut end_ts := event.end_time or {
		// TODO: Add duration parsing to get actual end time
		event.start_time + 3600 // Default 1 hour if no end/duration
	}

	// Check basic overlap
	if is_in_range(event.start_time, tr) || is_in_range(end_ts, tr) {
		return true
	}

	// Check recurrences if any
	if rule := event.rrule {
		// TODO: Implement recurrence expansion
		// For now just check if the rule's until date (if any) is after range start
		if until := rule.until {
			return until >= tr.start
		}
		return true // Infinite recurrence overlaps everything
	}

	return false
}

// Gets the effective end time of an event
pub fn (event Event) get_effective_end_time() !i64 {
	if end := event.end_time {
		return end
	}
	if dur_str := event.duration {
		duration := parse_duration(dur_str)!
		return duration.add_to(event.start_time)
	}
	// Default 1 hour duration
	return event.start_time + 3600
}

// Gets all instances of an event that overlap with a time range
pub fn (event Event) get_instances(tr TimeRange) ![]EventInstance {
	// For non-recurring events, just check if it overlaps
	if event.rrule == none && event.rdate.len == 0 {
		end_time := event.get_effective_end_time()!
		if event.start_time < tr.end && end_time > tr.start {
			return [
				EventInstance{
					original_event: event
					start_time:     event.start_time
					end_time:       end_time
					recurrence_id:  event.start_time
					is_override:    false
				},
			]
		}
		return []
	}

	// Expand recurring event
	if instances := expand_recurring_event(event, tr) {
		return instances
	}
	return []
}
