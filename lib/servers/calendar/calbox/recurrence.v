module calbox

// Gets the next occurrence after a given timestamp based on a recurrence rule
fn (rule RecurrenceRule) next_occurrence(base_time i64, after i64) ?i64 {
	if rule.until != none && after >= rule.until? {
		return none
	}

	// Calculate interval in seconds based on frequency
	mut interval_seconds := i64(0)
	match rule.frequency {
		.secondly { interval_seconds = rule.interval }
		.minutely { interval_seconds = rule.interval * 60 }
		.hourly { interval_seconds = rule.interval * 3600 }
		.daily { interval_seconds = rule.interval * 86400 }
		.weekly { interval_seconds = rule.interval * 7 * 86400 }
		.monthly { interval_seconds = rule.interval * 30 * 86400 } // Approximate
		.yearly { interval_seconds = rule.interval * 365 * 86400 } // Approximate
	}

	// Calculate number of intervals between base_time and after
	mut intervals := i64(0)
	if after > base_time {
		intervals = ((after - base_time) / interval_seconds) + 1
	}

	// Calculate next occurrence
	mut next := base_time + (intervals * interval_seconds)

	// TODO: Apply BYDAY, BYMONTHDAY etc. rules
	if rule.until != none && next > rule.until? {
		return none
	}
	return next
}

// Expands a recurring event into individual instances within a time range
pub fn expand_recurring_event(event Event, tr TimeRange) ?[]EventInstance {
	mut instances := []EventInstance{}

	// Get event duration
	mut duration := i64(0)
	if end := event.end_time {
		duration = end - event.start_time
	} else if dur_str := event.duration {
		duration = parse_duration(dur_str) or { return none }.seconds
	} else {
		duration = 3600 // Default 1 hour
	}

	// Handle recurrence rule if any
	if rule := event.rrule {
		mut current := event.start_time
		mut total_instances := 0

		// Generate instances until we hit count limit or range end
		for {
			// Add instance if in range and not excluded
			if current >= tr.start && current < tr.end && current !in event.exdate {
				instances << EventInstance{
					original_event: event
					start_time:     current
					end_time:       current + duration
					recurrence_id:  current
					is_override:    false
				}
			}

			total_instances++

			// Check count limit if specified
			if count := rule.count {
				if total_instances >= count {
					break
				}
			}

			// Calculate next occurrence
			mut interval_seconds := rule.interval * match rule.frequency {
				.secondly { 1 }
				.minutely { 60 }
				.hourly { 3600 }
				.daily { 86400 }
				.weekly { 7 * 86400 }
				.monthly { 30 * 86400 } // Approximate
				.yearly { 365 * 86400 } // Approximate
			}
			current += interval_seconds

			// Break if we hit until limit
			if rule.until != none && current > rule.until? {
				break
			}

			// Break if we're past the range and no count limit
			if current >= tr.end && rule.count == none {
				break
			}

			// Break if we're past the range and have enough instances
			if current >= tr.end && total_instances >= (rule.count or { 0 }) {
				break
			}
		}
	}

	// Add any additional dates
	for rdate in event.rdate {
		if rdate >= tr.start && rdate < tr.end && rdate !in event.exdate {
			instances << EventInstance{
				original_event: event
				start_time:     rdate
				end_time:       rdate + duration
				recurrence_id:  rdate
				is_override:    false
			}
		}
	}

	// Sort instances by start time
	instances.sort(a.start_time < b.start_time)

	return instances
}
