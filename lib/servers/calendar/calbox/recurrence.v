module calbox

// Represents a single instance of a recurring event
pub struct EventInstance {
pub:
	original_event Event    // Reference to original event
	start_time    i64      // Start time of this instance
	end_time      i64      // End time of this instance
	recurrence_id i64      // RECURRENCE-ID for this instance
	is_override   bool     // Whether this is an overridden instance
}

// Gets the next occurrence after a given timestamp based on a recurrence rule
fn (rule RecurrenceRule) next_occurrence(base_time i64, after i64) ?i64 {
	if rule.until != none && after >= rule.until? {
		return none
	}
	
	// Calculate interval in seconds based on frequency
	mut interval_seconds := i64(0)
	match rule.frequency {
		'SECONDLY' { interval_seconds = rule.interval }
		'MINUTELY' { interval_seconds = rule.interval * 60 }
		'HOURLY' { interval_seconds = rule.interval * 3600 }
		'DAILY' { interval_seconds = rule.interval * 86400 }
		'WEEKLY' { interval_seconds = rule.interval * 7 * 86400 }
		'MONTHLY' { interval_seconds = rule.interval * 30 * 86400 } // Approximate
		'YEARLY' { interval_seconds = rule.interval * 365 * 86400 } // Approximate
		else { return none }
	}
	
	// Find next occurrence
	mut next := base_time
	for {
		next += interval_seconds
		if next > after {
			// TODO: Apply BYDAY, BYMONTHDAY etc. rules
			if rule.until != none && next > rule.until? {
				return none
			}
			return next
		}
	}
	return none
}

// Expands a recurring event into individual instances within a time range
pub fn expand_recurring_event(event Event, tr TimeRange) ![]EventInstance {
	mut instances := []EventInstance{}
	
	// Get event duration
	mut duration := i64(0)
	if end := event.end_time {
		duration = end - event.start_time
	} else if dur_str := event.duration {
		duration = parse_duration(dur_str)!.seconds
	} else {
		duration = 3600 // Default 1 hour
	}
	
	// Add base instance if it falls in range
	if event.start_time >= tr.start && event.start_time < tr.end {
		instances << EventInstance{
			original_event: event
			start_time: event.start_time
			end_time: event.start_time + duration
			recurrence_id: event.start_time
			is_override: false
		}
	}
	
	// Handle recurrence rule if any
	if rule := event.rrule {
		mut current := event.start_time
		
		for {
			// Get next occurrence
			current = rule.next_occurrence(event.start_time, current) or { break }
			if current >= tr.end {
				break
			}
			
			// Check count limit if specified
			if rule.count != none && instances.len >= rule.count? {
				break
			}
			
			// Add instance if not excluded
			if current !in event.exdate {
				instances << EventInstance{
					original_event: event
					start_time: current
					end_time: current + duration
					recurrence_id: current
					is_override: false
				}
			}
		}
	}
	
	// Add any additional dates
	for rdate in event.rdate {
		if rdate >= tr.start && rdate < tr.end && rdate !in event.exdate {
			instances << EventInstance{
				original_event: event
				start_time: rdate
				end_time: rdate + duration
				recurrence_id: rdate
				is_override: false
			}
		}
	}
	
	// Sort instances by start time
	instances.sort(a.start_time < b.start_time)
	
	return instances
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
					start_time: event.start_time
					end_time: end_time
					recurrence_id: event.start_time
					is_override: false
				}
			]
		}
		return []
	}
	
	// Expand recurring event
	return expand_recurring_event(event, tr)!
}
