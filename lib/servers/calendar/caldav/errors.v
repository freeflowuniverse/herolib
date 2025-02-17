module caldav

// Error codes
pub const err_not_found = 404
pub const err_forbidden = 403
pub const err_conflict = 409
pub const err_precondition_failed = 412
pub const err_insufficient_storage = 507

// Error types
pub const err_calendar_not_found = 'Calendar collection not found'
pub const err_resource_not_found = 'Calendar object resource not found'
pub const err_calendar_exists = 'Calendar collection already exists'
pub const err_resource_exists = 'Calendar object resource already exists'
pub const err_invalid_calendar = 'Invalid calendar collection'
pub const err_invalid_resource = 'Invalid calendar object resource'
pub const err_uid_conflict = 'UID already in use'
pub const err_no_privilege = 'Insufficient privileges'
pub const err_storage_full = 'Insufficient storage space'

// Precondition errors
pub const err_supported_calendar_data = 'Unsupported calendar data format'
pub const err_valid_calendar_data = 'Invalid calendar data'
pub const err_valid_calendar_object = 'Invalid calendar object'
pub const err_supported_component = 'Unsupported calendar component'
pub const err_calendar_collection_location = 'Invalid calendar collection location'
pub const err_resource_must_be_null = 'Resource already exists'
pub const err_valid_calendar_timezone = 'Invalid calendar timezone'

// CalDAV error with code and message
pub struct CalDAVError {
pub:
	code    int
	message string
	href    string // Optional resource href for errors like UID conflicts
}

// Creates a new CalDAV error
pub fn new_error(code int, message string) CalDAVError {
	return CalDAVError{
		code:    code
		message: message
	}
}

// Creates a new CalDAV error with href
pub fn new_error_with_href(code int, message string, href string) CalDAVError {
	return CalDAVError{
		code:    code
		message: message
		href:    href
	}
}

// Common error constructors

// Resource not found error
pub fn err_not_found_error(message string) CalDAVError {
	return new_error(err_not_found, message)
}

// Permission denied error
pub fn err_forbidden_error(message string) CalDAVError {
	return new_error(err_forbidden, message)
}

// Resource conflict error
pub fn err_conflict_error(message string) CalDAVError {
	return new_error(err_conflict, message)
}

// Precondition failed error
pub fn err_precondition_error(message string) CalDAVError {
	return new_error(err_precondition_failed, message)
}

// Storage full error
pub fn err_storage_error(message string) CalDAVError {
	return new_error(err_insufficient_storage, message)
}

// UID conflict error with href
pub fn err_uid_conflict_error(href string) CalDAVError {
	return new_error_with_href(err_conflict, err_uid_conflict, href)
}

// Generates XML error response
pub fn (err CalDAVError) to_xml() string {
	mut xml := '<?xml version="1.0" encoding="utf-8" ?>\n'
	xml += '<D:error xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">\n'

	match err.code {
		err_forbidden {
			xml += '  <D:need-privileges>\n'
			xml += '    <D:resource>\n'
			xml += '      <D:privilege>${err.message}</D:privilege>\n'
			xml += '    </D:resource>\n'
			xml += '  </D:need-privileges>\n'
		}
		err_conflict {
			if err.message == err_uid_conflict && err.href != '' {
				xml += '  <C:no-uid-conflict><D:href>${err.href}</D:href></C:no-uid-conflict>\n'
			} else {
				xml += '  <D:resource-must-be-null/>\n'
			}
		}
		err_precondition_failed {
			xml += '  <C:supported-calendar-data/>\n'
			xml += '  <C:valid-calendar-data/>\n'
			xml += '  <C:valid-calendar-object/>\n'
			xml += '  <C:supported-calendar-component/>\n'
			xml += '  <C:calendar-collection-location-ok/>\n'
			xml += '  <C:max-resource-size/>\n'
			xml += '  <C:min-date-time/>\n'
			xml += '  <C:max-date-time/>\n'
			xml += '  <C:max-instances/>\n'
			xml += '  <C:max-attendees-per-instance/>\n'
		}
		else {
			xml += '  <D:error><![CDATA[${err.message}]]></D:error>\n'
		}
	}

	xml += '</D:error>'
	return xml
}
