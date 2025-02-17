module caldav

import calendar.calbox

// Report types
pub const calendar_query = 'calendar-query'
pub const calendar_multiget = 'calendar-multiget'
pub const freebusy_query = 'free-busy-query'

// Report request parameters
pub struct ReportParams {
pub mut:
	depth      int                 // Depth header value
	props      []string            // Properties to return
	filter     CalendarQueryFilter // Query filter
	hrefs      []string            // Resource hrefs for multiget
	timezone   string              // Timezone for floating time conversion
	expand     bool                // Whether to expand recurrences
	limit_set  bool                // Whether to limit recurrence/freebusy set
	time_range ?calbox.TimeRange   // Time range for limiting results
}

// Report response
pub struct ReportResponse {
pub mut:
	status  int                     // HTTP status code
	objects []calbox.CalendarObject // Calendar objects
	ranges  []calbox.TimeRange      // Free/busy ranges
	error   ?CalDAVError            // Error if any
}

// Handles a calendar-query REPORT
pub fn handle_calendar_query(cal &calbox.CalBox, params ReportParams) ReportResponse {
	mut response := ReportResponse{
		status: 207 // Multi-Status
	}

	// Check privileges
	if !cal.acl.can_read(params.principal) {
		response.status = 403
		response.error = err_forbidden_error(err_no_privilege)
		return response
	}

	// Apply filter
	objects := cal.find_by_filter(params.filter) or {
		response.status = 500
		response.error = new_error(500, err.str())
		return response
	}

	// Apply time range if specified
	if tr := params.time_range {
		for obj in objects {
			if obj.overlaps(tr) {
				response.objects << obj
			}
		}
	} else {
		response.objects = objects
	}

	// Expand recurrences if requested
	if params.expand {
		response.objects = expand_recurrences(response.objects, params.time_range)
	}

	// Limit recurrence set if requested
	if params.limit_set {
		response.objects = limit_recurrence_set(response.objects, params.time_range)
	}

	return response
}

// Handles a calendar-multiget REPORT
pub fn handle_calendar_multiget(cal &calbox.CalBox, params ReportParams) ReportResponse {
	mut response := ReportResponse{
		status: 207 // Multi-Status
	}

	// Check privileges
	if !cal.acl.can_read(params.principal) {
		response.status = 403
		response.error = err_forbidden_error(err_no_privilege)
		return response
	}

	// Get requested resources
	for href in params.hrefs {
		if obj := cal.get_by_href(href) {
			response.objects << obj
		}
	}

	// Expand recurrences if requested
	if params.expand {
		response.objects = expand_recurrences(response.objects, params.time_range)
	}

	// Limit recurrence set if requested
	if params.limit_set {
		response.objects = limit_recurrence_set(response.objects, params.time_range)
	}

	return response
}

// Handles a free-busy-query REPORT
pub fn handle_freebusy_query(cal &calbox.CalBox, params ReportParams) ReportResponse {
	mut response := ReportResponse{
		status: 200 // OK
	}

	// Check privileges
	if !cal.acl.can_read_freebusy(params.principal) {
		response.status = 403
		response.error = err_forbidden_error(err_no_privilege)
		return response
	}

	// Get time range
	tr := params.time_range or {
		response.status = 400
		response.error = new_error(400, 'Missing time range')
		return response
	}

	// Get free/busy ranges
	ranges := cal.get_freebusy(tr) or {
		response.status = 500
		response.error = new_error(500, err.str())
		return response
	}

	response.ranges = ranges
	return response
}

// Helper functions

fn expand_recurrences(objects []calbox.CalendarObject, tr ?calbox.TimeRange) []calbox.CalendarObject {
	mut expanded := []calbox.CalendarObject{}

	for obj in objects {
		if obj.is_recurring() {
			if range := tr {
				expanded << obj.expand(range)
			} else {
				expanded << obj.expand_all()
			}
		} else {
			expanded << obj
		}
	}

	return expanded
}

fn limit_recurrence_set(objects []calbox.CalendarObject, tr ?calbox.TimeRange) []calbox.CalendarObject {
	if tr == none {
		return objects
	}

	mut limited := []calbox.CalendarObject{}
	range := tr or { return objects }

	for obj in objects {
		if obj.overlaps(range) {
			limited << obj
		}
	}

	return limited
}
