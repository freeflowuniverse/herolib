module caldav

import calendar.calbox

fn test_format_event() {
	// Create a test event with all fields
	event := calbox.Event{
		CalendarComponent: calbox.CalendarComponent{
			uid: 'test@example.com'
			created: 1708074000  // 2024-02-16 10:00:00 UTC
			modified: 1708074000
			summary: 'Test Event'
			description: 'Test Description'
			categories: ['Work', 'Meeting']
			status: .confirmed
			class: .public
			location: 'Conference Room'
			alarms: [
				calbox.Alarm{
					action: .display
					trigger: '-PT15M'
					description: 'Meeting starts in 15 minutes'
				}
			]
		}
		start_time: 1708074000
		end_time: 1708077600  // 1 hour later
		transp: .opaque
		attendees: [
			calbox.Attendee{
				email: 'john@example.com'
				name: 'John Doe'
				role: .req_participant
				partstat: .accepted
				rsvp: true
			}
		]
		organizer: calbox.Attendee{
			email: 'boss@example.com'
			name: 'The Boss'
			role: .chair
			partstat: .accepted
		}
	}
	
	obj := calbox.CalendarObject{
		comp_type: 'VEVENT'
		event: event
	}
	
	ical := to_ical(obj)
	
	// Verify required fields
	assert ical.contains('BEGIN:VCALENDAR')
	assert ical.contains('VERSION:2.0')
	assert ical.contains('BEGIN:VEVENT')
	assert ical.contains('UID:test@example.com')
	assert ical.contains('DTSTART:20240216T100000Z')
	assert ical.contains('DTEND:20240216T110000Z')
	assert ical.contains('SUMMARY:Test Event')
	assert ical.contains('STATUS:CONFIRMED')
	assert ical.contains('CLASS:PUBLIC')
	assert ical.contains('TRANSP:OPAQUE')
	assert ical.contains('END:VEVENT')
	assert ical.contains('END:VCALENDAR')
	
	// Parse back
	parsed := from_ical(ical)!
	assert parsed.comp_type == 'VEVENT'
	
	if e := parsed.event {
		assert e.uid == event.uid
		assert e.summary == event.summary
		assert e.start_time == event.start_time
		assert e.end_time? == event.end_time?
		assert e.status == event.status
		assert e.class == event.class
		assert e.transp == event.transp
		assert e.attendees.len == event.attendees.len
		assert e.attendees[0].role == event.attendees[0].role
		assert e.attendees[0].partstat == event.attendees[0].partstat
		assert e.organizer?.role == event.organizer?.role
	} else {
		assert false, 'Failed to parse event'
	}
}

fn test_format_recurring_event() {
	// Create a recurring event
	event := calbox.Event{
		CalendarComponent: calbox.CalendarComponent{
			uid: 'recurring@example.com'
			created: 1708074000
			summary: 'Daily Meeting'
			status: .confirmed
			class: .public
		}
		start_time: 1708074000
		duration: 'PT1H'
		transp: .opaque
		rrule: calbox.RecurrenceRule{
			frequency: .daily
			interval: 1
			count: 5
			by_day: ['MO', 'WE', 'FR']
		}
	}
	
	obj := calbox.CalendarObject{
		comp_type: 'VEVENT'
		event: event
	}
	
	ical := to_ical(obj)
	
	// Verify recurrence fields
	assert ical.contains('RRULE:FREQ=DAILY;INTERVAL=1;COUNT=5;BYDAY=MO,WE,FR')
	assert ical.contains('DURATION:PT1H')
	
	// Parse back
	parsed := from_ical(ical)!
	if e := parsed.event {
		assert e.duration? == event.duration?
		if rule := e.rrule {
			assert rule.frequency == .daily
			assert rule.interval == 1
			assert rule.count? == 5
			assert rule.by_day == ['MO', 'WE', 'FR']
		} else {
			assert false, 'Failed to parse recurrence rule'
		}
	} else {
		assert false, 'Failed to parse event'
	}
}

fn test_format_todo() {
	// Create a todo
	todo := calbox.Todo{
		CalendarComponent: calbox.CalendarComponent{
			uid: 'todo@example.com'
			created: 1708074000
			summary: 'Test Todo'
			status: .needs_action
			class: .private
		}
		due_time: 1708160400  // Next day
		percent: 0
	}
	
	obj := calbox.CalendarObject{
		comp_type: 'VTODO'
		todo: todo
	}
	
	ical := to_ical(obj)
	
	// Verify todo fields
	assert ical.contains('BEGIN:VTODO')
	assert ical.contains('DUE:20240217T100000Z')
	assert ical.contains('PERCENT-COMPLETE:0')
	assert ical.contains('STATUS:NEEDS-ACTION')
	assert ical.contains('CLASS:PRIVATE')
	
	// Parse back
	parsed := from_ical(ical)!
	if t := parsed.todo {
		assert t.uid == todo.uid
		assert t.summary == todo.summary
		assert t.due_time? == todo.due_time?
		assert t.percent? == todo.percent?
		assert t.status == todo.status
		assert t.class == todo.class
	} else {
		assert false, 'Failed to parse todo'
	}
}

fn test_format_journal() {
	// Create a journal entry
	journal := calbox.Journal{
		CalendarComponent: calbox.CalendarComponent{
			uid: 'journal@example.com'
			created: 1708074000
			summary: 'Test Journal'
			description: 'Today we discussed...'
			categories: ['Notes', 'Work']
			status: .draft
			class: .confidential
		}
		start_time: 1708074000
	}
	
	obj := calbox.CalendarObject{
		comp_type: 'VJOURNAL'
		journal: journal
	}
	
	ical := to_ical(obj)
	
	// Verify journal fields
	assert ical.contains('BEGIN:VJOURNAL')
	assert ical.contains('DTSTART:20240216T100000Z')
	assert ical.contains('CATEGORIES:Notes,Work')
	assert ical.contains('STATUS:DRAFT')
	assert ical.contains('CLASS:CONFIDENTIAL')
	
	// Parse back
	parsed := from_ical(ical)!
	if j := parsed.journal {
		assert j.uid == journal.uid
		assert j.summary == journal.summary
		assert j.description == journal.description
		assert j.categories == journal.categories
		assert j.start_time == journal.start_time
		assert j.status == journal.status
		assert j.class == journal.class
	} else {
		assert false, 'Failed to parse journal'
	}
}

fn test_parse_attendees() {
	ical := 'BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:test@example.com
DTSTAMP:20240216T100000Z
DTSTART:20240216T100000Z
DTEND:20240216T110000Z
SUMMARY:Test Event
ATTENDEE;CN=John Doe;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;RSVP=TRUE:mailto:john@example.com
ORGANIZER;CN=The Boss;ROLE=CHAIR;PARTSTAT=ACCEPTED:mailto:boss@example.com
END:VEVENT
END:VCALENDAR'
	
	obj := from_ical(ical)!
	if event := obj.event {
		assert event.attendees.len == 1
		attendee := event.attendees[0]
		assert attendee.email == 'john@example.com'
		assert attendee.name == 'John Doe'
		assert attendee.role == .req_participant
		assert attendee.partstat == .accepted
		assert attendee.rsvp == true
		
		if org := event.organizer {
			assert org.email == 'boss@example.com'
			assert org.name == 'The Boss'
			assert org.role == .chair
			assert org.partstat == .accepted
		} else {
			assert false, 'Failed to parse organizer'
		}
	} else {
		assert false, 'Failed to parse event'
	}
}

fn test_parse_alarms() {
	ical := 'BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:test@example.com
DTSTAMP:20240216T100000Z
DTSTART:20240216T100000Z
DTEND:20240216T110000Z
SUMMARY:Test Event
BEGIN:VALARM
ACTION:DISPLAY
TRIGGER:-PT15M
DESCRIPTION:Meeting starts in 15 minutes
END:VALARM
END:VEVENT
END:VCALENDAR'
	
	obj := from_ical(ical)!
	if event := obj.event {
		assert event.alarms.len == 1
		alarm := event.alarms[0]
		assert alarm.action == .display
		assert alarm.trigger == '-PT15M'
		assert alarm.description == 'Meeting starts in 15 minutes'
	} else {
		assert false, 'Failed to parse event'
	}
}

fn test_line_folding() {
	// Test long description that should be folded
	event := calbox.Event{
		CalendarComponent: calbox.CalendarComponent{
			uid: 'test@example.com'
			created: 1708074000
			summary: 'Test Event'
			description: 'This is a very long description that should be folded into multiple lines according to the iCalendar specification which states that lines longer than 75 characters should be folded'
			status: .confirmed
			class: .public
		}
		start_time: 1708074000
		end_time: 1708077600
		transp: .opaque
	}
	
	obj := calbox.CalendarObject{
		comp_type: 'VEVENT'
		event: event
	}
	
	ical := to_ical(obj)
	lines := ical.split_into_lines()
	
	// Verify no line is longer than 75 characters
	for line in lines {
		assert line.len <= 75, 'Line exceeds 75 characters: ${line}'
	}
	
	// Parse back and verify description is reconstructed
	parsed := from_ical(ical)!
	if e := parsed.event {
		assert e.description == event.description
	} else {
		assert false, 'Failed to parse event'
	}
}
