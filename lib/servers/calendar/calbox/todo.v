module calbox

// Represents a todo/task
@[heap]
pub struct Todo {
	CalendarComponent
pub mut:
	start_time ?i64    // Optional start time
	due_time   ?i64    // When the todo is due
	duration   ?string // Estimated duration
	completed  ?i64    // When the todo was completed
	percent    ?int    // Percent complete (0-100)
	rrule      ?RecurrenceRule
	attendees  []Attendee
	organizer  ?Attendee
}

// Checks if a todo overlaps with a time range
fn (todo Todo) overlaps(tr TimeRange) bool {
	if start := todo.start_time {
		if is_in_range(start, tr) {
			return true
		}
	}

	if due := todo.due_time {
		if is_in_range(due, tr) {
			return true
		}
	}

	if completed := todo.completed {
		if is_in_range(completed, tr) {
			return true
		}
	}

	return false
}
