module calbox

fn test_create_event() {
	mut cal := new('test_calendar')

	// Create an event with all fields
	event := Event{
		CalendarComponent: CalendarComponent{
			uid:         'event1@example.com'
			etag:        '"1"'
			created:     1708070400 // 2024-02-16 09:00:00 UTC
			modified:    1708070400
			summary:     'Team Meeting'
			description: 'Weekly team sync'
			categories:  ['Work', 'Meeting']
			status:      .confirmed
			class:       .public
			location:    'Conference Room'
			alarms:      [
				Alarm{
					action:      .display
					trigger:     '-PT15M'
					description: 'Meeting starts in 15 minutes'
				},
			]
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		end_time:          1708077600 // 2024-02-16 11:00:00 UTC
		transp:            .opaque
		attendees:         [
			Attendee{
				email:    'john@example.com'
				name:     'John Doe'
				role:     .req_participant
				partstat: .accepted
				rsvp:     true
			},
			Attendee{
				email:    'jane@example.com'
				name:     'Jane Smith'
				role:     .req_participant
				partstat: .needs_action
				rsvp:     true
			},
		]
		organizer:         Attendee{
			email:    'boss@example.com'
			name:     'The Boss'
			role:     .chair
			partstat: .accepted
		}
	}

	obj := CalendarItem{
		comp_type: .vevent
		event:     event
	}

	cal.put(obj) or { panic(err) }
	assert cal.len() == 1

	// Verify retrieval
	found := cal.get_by_uid('event1@example.com') or { panic(err) }
	assert found.comp_type == .vevent

	if e := found.event {
		assert e.summary == 'Team Meeting'
		assert e.start_time == 1708074000
		assert e.end_time? == 1708077600
		assert e.attendees.len == 2
		assert e.organizer?.email == 'boss@example.com'
	} else {
		assert false, 'Event not found'
	}
}

fn test_create_recurring_event() {
	mut cal := new('test_calendar')

	// Create a daily recurring event
	event := Event{
		CalendarComponent: CalendarComponent{
			uid:      'recurring@example.com'
			etag:     '"1"'
			created:  1708070400
			modified: 1708070400
			summary:  'Daily Standup'
		}
		start_time:        1708074000 // 2024-02-16 10:00:00 UTC
		duration:          'PT30M'    // 30 minutes
		rrule:             RecurrenceRule{
			frequency: .daily
			interval:  1
			count:     5
		}
	}

	obj := CalendarItem{
		comp_type: .vevent
		event:     event
	}

	cal.put(obj) or { panic(err) }

	// Test time range search
	tr := TimeRange{
		start: 1708160400 // 2024-02-17 10:00:00 UTC
		end:   1708333200 // 2024-02-19 10:00:00 UTC
	}

	results := cal.find_by_time(tr) or { panic(err) }
	assert results.len == 1 // Should find the recurring event
}

fn test_create_todo() {
	mut cal := new('test_calendar')

	// Create a todo with due date
	todo := Todo{
		CalendarComponent: CalendarComponent{
			uid:      'todo1@example.com'
			etag:     '"1"'
			created:  1708070400
			modified: 1708070400
			summary:  'Write Documentation'
			status:   .needs_action
		}
		due_time:          1708160400 // 2024-02-17 10:00:00 UTC
		percent:           0
	}

	obj := CalendarItem{
		comp_type: .vtodo
		todo:      todo
	}

	cal.put(obj) or { panic(err) }

	// Test completion
	mut updated_todo := todo
	updated_todo.status = .completed
	updated_todo.completed = 1708074000
	updated_todo.percent = 100

	updated_obj := CalendarItem{
		comp_type: .vtodo
		todo:      updated_todo
	}

	cal.put(updated_obj) or { panic(err) }

	// Verify update
	found := cal.get_by_uid('todo1@example.com') or { panic(err) }
	if t := found.todo {
		assert t.status == .completed
		assert t.completed? == 1708074000
		assert t.percent? == 100
	} else {
		assert false, 'Todo not found'
	}
}

fn test_create_journal() {
	mut cal := new('test_calendar')

	// Create a journal entry
	journal := Journal{
		CalendarComponent: CalendarComponent{
			uid:         'journal1@example.com'
			etag:        '"1"'
			created:     1708070400
			modified:    1708070400
			summary:     'Project Notes'
			description: 'Today we discussed the new features...'
			categories:  ['Work', 'Notes']
		}
		start_time:        1708070400 // 2024-02-16 09:00:00 UTC
	}

	obj := CalendarItem{
		comp_type: .vjournal
		journal:   journal
	}

	cal.put(obj) or { panic(err) }
	assert cal.len() == 1

	// Test time range search
	tr := TimeRange{
		start: 1708070400 // 2024-02-16 09:00:00 UTC
		end:   1708074000 // 2024-02-16 10:00:00 UTC
	}

	results := cal.find_by_time(tr) or { panic(err) }
	assert results.len == 1
}

fn test_validation() {
	mut cal := new('test_calendar')

	// Test invalid component type
	invalid_type := CalendarItem{
		comp_type: .vevent // Using a valid type but with invalid data
	}
	if _ := cal.put(invalid_type) {
		assert false, 'Should reject invalid component type'
	}

	// Test missing required fields
	invalid_event := CalendarItem{
		comp_type: .vevent
		event:     Event{}
	}
	if _ := cal.put(invalid_event) {
		assert false, 'Should reject event without required fields'
	}

	// Test too many attendees
	mut many_attendees := []Attendee{cap: 200}
	for i in 0 .. 200 {
		many_attendees << Attendee{
			email: 'user${i}@example.com'
			name:  'User ${i}'
		}
	}

	event_many_attendees := CalendarItem{
		comp_type: .vevent
		event:     Event{
			CalendarComponent: CalendarComponent{
				uid: 'many@example.com'
			}
			start_time:        1708070400
			end_time:          1708074000
			attendees:         many_attendees
		}
	}
	if _ := cal.put(event_many_attendees) {
		assert false, 'Should reject event with too many attendees'
	}
}

fn test_read_only() {
	mut cal := new('test_calendar')
	cal.read_only = true

	event := CalendarItem{
		comp_type: .vevent
		event:     Event{
			CalendarComponent: CalendarComponent{
				uid: 'test@example.com'
			}
			start_time:        1708070400
			end_time:          1708074000
		}
	}

	// Test put
	if _ := cal.put(event) {
		assert false, 'Should reject put on read-only calendar'
	}

	// Test delete
	if _ := cal.delete('test@example.com') {
		assert false, 'Should reject delete on read-only calendar'
	}
}
