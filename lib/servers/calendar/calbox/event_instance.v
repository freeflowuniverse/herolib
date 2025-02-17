module calbox

// Represents a single instance of a recurring event
pub struct EventInstance {
pub:
	original_event Event // Reference to original event
	start_time     i64   // Start time of this instance
	end_time       i64   // End time of this instance
	recurrence_id  i64   // RECURRENCE-ID for this instance
	is_override    bool  // Whether this is an overridden instance
}
