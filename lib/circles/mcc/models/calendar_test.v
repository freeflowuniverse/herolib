module models

import freeflowuniverse.herolib.data.ourtime
import time

fn test_calendar_event_serialization() {
	// Create a test event
	mut start := ourtime.now()
	mut end := ourtime.now()
	// Warp end time by 1 hour
	end.warp('+1h') or { panic(err) }
	
	mut event := CalendarEvent{
		id: 1234
		title: 'Test Meeting'
		description: 'This is a test meeting description'
		location: 'Virtual Room 1'
		start_time: start
		end_time: end
		all_day: false
		recurrence: 'FREQ=WEEKLY;COUNT=5'
		attendees: ['user1@example.com', 'user2@example.com']
		organizer: 'organizer@example.com'
		status: 'CONFIRMED'
		caldav_uid: 'test-uid-123456'
		sync_token: 'sync-token-123'
		etag: 'etag-123'
		color: 'blue'
	}

	// Test serialization
	serialized := event.dumps() or {
		assert false, 'Failed to serialize CalendarEvent: ${err}'
		return
	}

	// Test deserialization
	deserialized := calendar_event_loads(serialized) or {
		assert false, 'Failed to deserialize CalendarEvent: ${err}'
		return
	}

	// Verify all fields match
	assert deserialized.id == event.id
	assert deserialized.title == event.title
	assert deserialized.description == event.description
	assert deserialized.location == event.location
	assert deserialized.start_time.str() == event.start_time.str()
	assert deserialized.end_time.str() == event.end_time.str()
	assert deserialized.all_day == event.all_day
	assert deserialized.recurrence == event.recurrence
	assert deserialized.attendees.len == event.attendees.len
	
	// Check each attendee
	for i, attendee in event.attendees {
		assert deserialized.attendees[i] == attendee
	}
	
	assert deserialized.organizer == event.organizer
	assert deserialized.status == event.status
	assert deserialized.caldav_uid == event.caldav_uid
	assert deserialized.sync_token == event.sync_token
	assert deserialized.etag == event.etag
	assert deserialized.color == event.color
}

fn test_index_keys() {
	// Test with caldav_uid
	mut event := CalendarEvent{
		id: 5678
		caldav_uid: 'test-caldav-uid'
	}
	
	mut keys := event.index_keys()
	assert keys['id'] == '5678'
	// The caldav_uid is no longer included in index_keys as it's commented out in the model.v file
	// assert keys['caldav_uid'] == 'test-caldav-uid'
	assert 'caldav_uid' !in keys
	
	// Test without caldav_uid
	event.caldav_uid = ''
	keys = event.index_keys()
	assert keys['id'] == '5678'
	assert 'caldav_uid' !in keys
}

// Test creating an event with all fields
fn test_create_complete_event() {
	mut start_time := ourtime.new('2025-04-15 09:00:00') or { panic(err) }
	mut end_time := ourtime.new('2025-04-17 17:00:00') or { panic(err) }
	
	event := CalendarEvent{
		id: 9999
		title: 'Annual Conference'
		description: 'Annual company conference with all departments'
		location: 'Conference Center'
		start_time: start_time
		end_time: end_time
		all_day: true
		recurrence: 'FREQ=YEARLY'
		attendees: ['dept1@example.com', 'dept2@example.com', 'dept3@example.com']
		organizer: 'ceo@example.com'
		status: 'CONFIRMED'
		caldav_uid: 'annual-conf-2025'
		sync_token: 'sync-token-annual-2025'
		etag: 'etag-annual-2025'
		color: 'red'
	}
	
	assert event.id == 9999
	assert event.title == 'Annual Conference'
	assert event.all_day == true
	assert event.attendees.len == 3
	assert event.color == 'red'
}
