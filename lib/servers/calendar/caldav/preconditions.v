module caldav

import calendar.calbox

// Checks preconditions for MKCALENDAR
pub fn check_mkcalendar_preconditions(path string, props map[string]string) !bool {
	// Resource must not exist
	if resource_exists(path) {
		return error(err_resource_must_be_null)
	}

	// Valid calendar timezone
	if tz := props[calendar_timezone] {
		validate_calendar_timezone(tz)!
	}

	// Valid component set
	if comp_set := get_prop_array(props, supported_calendar_component_set) {
		validate_supported_component_set(comp_set)!
	}

	return true
}

// Checks preconditions for PUT
pub fn check_put_preconditions(cal &calbox.CalBox, obj calbox.CalendarObject) !bool {
	// Supported calendar data
	validate_calendar_data('text/calendar', '2.0')!

	// Valid calendar data
	if !is_valid_calendar_data(obj) {
		return error(err_valid_calendar_data)
	}

	// Valid calendar object
	if !is_valid_calendar_object(obj) {
		return error(err_valid_calendar_object)
	}

	// Supported component
	if !cal.supports_component(obj.comp_type) {
		return error(err_supported_component)
	}

	// Resource size
	if max_size := cal.max_resource_size {
		if obj.size() > max_size {
			return error('Resource size exceeds maximum allowed')
		}
	}

	// Date range
	if !check_date_range(cal, obj) {
		return error('Date/time outside allowed range')
	}

	// Instance count
	if !check_instance_count(cal, obj) {
		return error('Too many recurrence instances')
	}

	// Attendee count
	if !check_attendee_count(cal, obj) {
		return error('Too many attendees')
	}

	// UID conflict
	if existing := cal.find_by_uid(obj.uid()) {
		if existing.uid() != obj.uid() {
			return error_with_href(err_uid_conflict, existing.href())
		}
	}

	return true
}

// Checks preconditions for COPY/MOVE
pub fn check_copy_move_preconditions(src_cal &calbox.CalBox, dst_cal &calbox.CalBox, obj calbox.CalendarObject) !bool {
	// Valid calendar collection location
	if !is_valid_calendar_location(dst_cal.path) {
		return error(err_calendar_collection_location)
	}

	// Check PUT preconditions on destination
	check_put_preconditions(dst_cal, obj)!

	return true
}

// Helper functions

fn resource_exists(path string) bool {
	// TODO: Implement resource existence check
	return false
}

fn is_valid_calendar_data(obj calbox.CalendarObject) bool {
	// TODO: Implement calendar data validation
	return true
}

fn is_valid_calendar_object(obj calbox.CalendarObject) bool {
	// TODO: Implement calendar object validation
	return true
}

fn is_valid_calendar_location(path string) bool {
	// TODO: Implement calendar location validation
	return true
}

fn check_date_range(cal &calbox.CalBox, obj calbox.CalendarObject) bool {
	// TODO: Implement date range check
	return true
}

fn check_instance_count(cal &calbox.CalBox, obj calbox.CalendarObject) bool {
	// TODO: Implement instance count check
	return true
}

fn check_attendee_count(cal &calbox.CalBox, obj calbox.CalendarObject) bool {
	// TODO: Implement attendee count check
	return true
}
