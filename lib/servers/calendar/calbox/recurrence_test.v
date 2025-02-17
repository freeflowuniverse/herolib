module calbox

fn test_simple_recurrence() {
	// Create a daily recurring event
	event := Event{
		CalendarComponent: CalendarComponent{
			uid: 'daily@example.com'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		duration:          'PT1H'
		rrule:             RecurrenceRule{
			frequency: .daily
			interval:  1
			count:     3
		}
	}

	// Search for instances over 3 days
	tr := TimeRange{
		start: 1708074000 // 2024-02-16 10:00:00 UTC
		end:   1708333200 // 2024-02-19 10:00:00 UTC
	}

	instances := event.get_instances(tr)!
	assert instances.len == 3

	// Verify instance times
	assert instances[0].start_time == 1708074000 // Feb 16 10:00
	assert instances[1].start_time == 1708160400 // Feb 17 10:00
	assert instances[2].start_time == 1708246800 // Feb 18 10:00

	// Verify duration
	for instance in instances {
		duration := instance.end_time - instance.start_time
		assert duration == 3600 // 1 hour
	}
}

fn test_recurrence_with_until() {
	// Create event recurring daily until a specific time
	event := Event{
		CalendarComponent: CalendarComponent{
			uid: 'until@example.com'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		duration:          'PT1H'
		rrule:             RecurrenceRule{
			frequency: .daily
			interval:  1
			until:     1708246800 // 2024-02-18 10:00:00 UTC
		}
	}

	// Search beyond the until date
	tr := TimeRange{
		start: 1708074000 // 2024-02-16 10:00:00 UTC
		end:   1708333200 // 2024-02-19 10:00:00 UTC
	}

	instances := event.get_instances(tr)!
	assert instances.len == 3 // Should include the until date
}

fn test_recurrence_with_interval() {
	// Create event recurring every 2 days
	event := Event{
		CalendarComponent: CalendarComponent{
			uid: 'interval@example.com'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		duration:          'PT1H'
		rrule:             RecurrenceRule{
			frequency: .daily
			interval:  2
			count:     3
		}
	}

	// Search for a week
	tr := TimeRange{
		start: 1708074000 // 2024-02-16 10:00:00 UTC
		end:   1708592400 // 2024-02-22 10:00:00 UTC
	}

	instances := event.get_instances(tr)!
	assert instances.len == 3

	// Verify instance times (every 2 days)
	assert instances[0].start_time == 1708074000 // Feb 16 10:00
	assert instances[1].start_time == 1708246800 // Feb 18 10:00
	assert instances[2].start_time == 1708419600 // Feb 20 10:00
}

fn test_recurrence_with_exclusions() {
	// Create daily event with exclusions
	event := Event{
		CalendarComponent: CalendarComponent{
			uid: 'exclude@example.com'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		duration:          'PT1H'
		rrule:             RecurrenceRule{
			frequency: .daily
			interval:  1
			count:     5
		}
		exdate:            [i64(1708246800)] // Exclude Feb 18 10:00
	}

	// Search for a week
	tr := TimeRange{
		start: 1708074000 // 2024-02-16 10:00:00 UTC
		end:   1708592400 // 2024-02-22 10:00:00 UTC
	}

	instances := event.get_instances(tr)!
	assert instances.len == 4 // 5 occurrences - 1 exclusion

	// Verify excluded date is not present
	for instance in instances {
		assert instance.start_time != 1708246800
	}
}

fn test_recurrence_with_additional_dates() {
	// Create event with additional dates
	event := Event{
		CalendarComponent: CalendarComponent{
			uid: 'rdate@example.com'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		duration:          'PT1H'
		rrule:             RecurrenceRule{
			frequency: .daily
			interval:  1
			count:     2
		}
		rdate:             [
			i64(1708333200), // Feb 19 10:00
			i64(1708419600), // Feb 20 10:00
		]
	}

	// Search for a week
	tr := TimeRange{
		start: 1708074000 // 2024-02-16 10:00:00 UTC
		end:   1708592400 // 2024-02-22 10:00:00 UTC
	}

	instances := event.get_instances(tr)!
	assert instances.len == 4 // 2 regular + 2 additional

	// Verify additional dates are included
	mut found_additional := false
	for instance in instances {
		if instance.start_time == 1708333200 || instance.start_time == 1708419600 {
			found_additional = true
		}
	}
	assert found_additional
}

fn test_non_recurring_event() {
	// Create single event
	event := Event{
		CalendarComponent: CalendarComponent{
			uid: 'single@example.com'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		end_time:          1708077600 // 2024-02-16 11:00:00 UTC
	}

	// Search including event time
	tr := TimeRange{
		start: 1708070400 // 2024-02-16 09:00:00 UTC
		end:   1708084800 // 2024-02-16 12:00:00 UTC
	}

	instances := event.get_instances(tr)!
	assert instances.len == 1

	// Search outside event time
	tr_outside := TimeRange{
		start: 1708333200 // 2024-02-19 10:00:00 UTC
		end:   1708336800 // 2024-02-19 11:00:00 UTC
	}

	outside_instances := event.get_instances(tr_outside)!
	assert outside_instances.len == 0
}
