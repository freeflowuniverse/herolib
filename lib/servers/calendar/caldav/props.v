module caldav

// CalDAV property names
pub const (
	calendar_description = 'calendar-description'
	calendar_timezone = 'calendar-timezone'
	supported_calendar_component_set = 'supported-calendar-component-set'
	supported_calendar_data = 'supported-calendar-data'
	max_resource_size = 'max-resource-size'
	min_date_time = 'min-date-time'
	max_date_time = 'max-date-time'
	max_instances = 'max-instances'
	max_attendees_per_instance = 'max-attendees-per-instance'
	calendar_home_set = 'calendar-home-set'
)

// Property validation errors
pub const (
	err_invalid_timezone = 'Invalid timezone: must be a valid iCalendar object containing a single VTIMEZONE component'
	err_invalid_component_set = 'Invalid component set: must contain at least one component type'
	err_invalid_calendar_data = 'Invalid calendar data: must specify a supported media type'
	err_invalid_resource_size = 'Invalid resource size: must be a positive integer'
	err_invalid_date_time = 'Invalid date/time: must be a valid UTC date-time value'
	err_invalid_instances = 'Invalid instances value: must be a positive integer'
	err_invalid_attendees = 'Invalid attendees value: must be a positive integer'
)

// Property validation functions

// Validates a calendar timezone property value
pub fn validate_calendar_timezone(value string) ! {
	// TODO: Implement timezone validation
	// Should parse value as iCalendar and verify it contains exactly one VTIMEZONE
	if value.len == 0 {
		return error(err_invalid_timezone)
	}
}

// Validates a supported calendar component set property value
pub fn validate_supported_component_set(components []string) ! {
	if components.len == 0 {
		return error(err_invalid_component_set)
	}
	
	valid := ['VEVENT', 'VTODO', 'VJOURNAL', 'VFREEBUSY']
	for comp in components {
		if comp !in valid {
			return error(err_invalid_component_set)
		}
	}
}

// Validates a supported calendar data property value
pub fn validate_calendar_data(content_type string, version string) ! {
	if content_type != 'text/calendar' || version != '2.0' {
		return error(err_invalid_calendar_data)
	}
}

// Validates a max resource size property value
pub fn validate_max_resource_size(size int) ! {
	if size <= 0 {
		return error(err_invalid_resource_size)
	}
}

// Validates a min/max date time property value
pub fn validate_date_time(value string) ! {
	// TODO: Implement UTC date-time validation
	if value.len == 0 {
		return error(err_invalid_date_time)
	}
}

// Validates a max instances property value
pub fn validate_max_instances(count int) ! {
	if count <= 0 {
		return error(err_invalid_instances)
	}
}

// Validates a max attendees per instance property value
pub fn validate_max_attendees(count int) ! {
	if count <= 0 {
		return error(err_invalid_attendees)
	}
}

// Property value getters/setters

// Gets a property value as string
pub fn get_prop_string(props map[string]string, name string) ?string {
	return props[name]
}

// Gets a property value as int
pub fn get_prop_int(props map[string]string, name string) ?int {
	if value := props[name] {
		return value.int()
	}
	return none
}

// Gets a property value as string array
pub fn get_prop_array(props map[string]string, name string) ?[]string {
	if value := props[name] {
		return value.split(',')
	}
	return none
}

// Sets a property value
pub fn set_prop(mut props map[string]string, name string, value string) {
	props[name] = value
}

// Removes a property
pub fn remove_prop(mut props map[string]string, name string) {
	props.delete(name)
}
