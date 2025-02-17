module caldav

import calendar.calbox

// Represents a CalDAV server instance
pub struct Server {
mut:
	collections map[string]&calbox.CalBox // Map of calendar collections by path
}

// Creates a new CalDAV server instance
pub fn new() &Server {
	return &Server{
		collections: map[string]&calbox.CalBox{}
	}
}

// Adds a calendar collection to the server
pub fn (mut s Server) add_collection(path string, cal &calbox.CalBox) {
	s.collections[path] = cal
}

// Gets a calendar collection by path
pub fn (s Server) get_collection(path string) ?&calbox.CalBox {
	return s.collections[path] or { none }
}

// Handles a MKCALENDAR request
pub fn (mut s Server) handle_mkcalendar(path string, props map[string]string) !&calbox.CalBox {
	// Create new calendar collection
	mut cal := calbox.new(props['displayname'] or { path.all_after_last('/') })

	// Set optional properties
	if desc := props['calendar-description'] {
		cal.description = desc
	}
	if tz := props['calendar-timezone'] {
		cal.timezone = tz
	}
	if components := props['supported-calendar-component-set'] {
		cal.supported_components = components.split(',')
	}

	// Add to server
	s.add_collection(path, cal)

	return cal
}

// Handles a calendar-query REPORT request
pub fn (s Server) handle_calendar_query(path string, filter CalendarQueryFilter) ![]calbox.CalendarObject {
	// Get calendar collection
	cal := s.get_collection(path) or { return error('Calendar not found') }

	// Apply filter
	mut results := []calbox.CalendarObject{}

	if filter.time_range != none {
		tr := filter.time_range or { return error('Invalid time range') }
		results = cal.find_by_time(calbox.TimeRange{
			start: tr.start
			end:   tr.end
		})!
	} else {
		results = cal.list()!
	}

	return results
}

// Handles a calendar-multiget REPORT request
pub fn (s Server) handle_calendar_multiget(path string, hrefs []string) ![]calbox.CalendarObject {
	// Get calendar collection
	cal := s.get_collection(path) or { return error('Calendar not found') }

	mut results := []calbox.CalendarObject{}

	// Get requested resources
	for href in hrefs {
		obj_path := href.all_after(path)
		if obj := cal.get_by_uid(obj_path) {
			results << obj
		}
	}

	return results
}

// Handles a free-busy-query REPORT request
pub fn (s Server) handle_freebusy_query(path string, tr calbox.TimeRange) ![]calbox.TimeRange {
	// Get calendar collection
	cal := s.get_collection(path) or { return error('Calendar not found') }

	// Get free/busy info
	return cal.get_freebusy(tr)
}

// Filter for calendar-query REPORT
pub struct CalendarQueryFilter {
pub mut:
	time_range ?calbox.TimeRange
	comp_type  string
	prop_name  string
	text_match string
}
