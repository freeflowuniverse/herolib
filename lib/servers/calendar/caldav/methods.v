module caldav

import calendar.calbox

// Handles MKCALENDAR request
pub fn handle_mkcalendar(path string, props map[string]string, principal Principal) !&calbox.CalBox {
	// Check preconditions
	check_mkcalendar_preconditions(path, props)!
	
	// Create calendar collection
	mut cal := calbox.new(props['displayname'] or { path.all_after_last('/') })
	
	// Set properties
	if desc := props[calendar_description] {
		cal.description = desc
	}
	if tz := props[calendar_timezone] {
		cal.timezone = tz
	}
	if components := get_prop_array(props, supported_calendar_component_set) {
		cal.supported_components = components
	}
	
	// Set ACL
	cal.acl = new_acl()
	cal.acl.add_entry(principal, [admin], false, true)
	
	return cal
}

// Handles PUT request
pub fn handle_put(cal &calbox.CalBox, obj calbox.CalendarObject, principal Principal) !bool {
	// Check privileges
	if !cal.acl.can_write(principal) {
		return error(err_no_privilege)
	}
	
	// Check preconditions
	check_put_preconditions(cal, obj)!
	
	// Add/update object
	cal.put(obj)!
	
	return true
}

// Handles DELETE request
pub fn handle_delete(cal &calbox.CalBox, uid string, principal Principal) !bool {
	// Check privileges
	if !cal.acl.can_unbind(principal) {
		return error(err_no_privilege)
	}
	
	// Delete object
	cal.delete(uid)!
	
	return true
}

// Handles COPY request
pub fn handle_copy(src_cal &calbox.CalBox, dst_cal &calbox.CalBox, uid string, principal Principal) !bool {
	// Check source privileges
	if !src_cal.acl.can_read(principal) {
		return error(err_no_privilege)
	}
	
	// Check destination privileges
	if !dst_cal.acl.can_bind(principal) {
		return error(err_no_privilege)
	}
	
	// Get source object
	obj := src_cal.get_by_uid(uid) or { return error(err_resource_not_found) }
	
	// Check preconditions
	check_copy_move_preconditions(src_cal, dst_cal, obj)!
	
	// Copy object
	dst_cal.put(obj)!
	
	return true
}

// Handles MOVE request
pub fn handle_move(src_cal &calbox.CalBox, dst_cal &calbox.CalBox, uid string, principal Principal) !bool {
	// Check source privileges
	if !src_cal.acl.can_unbind(principal) {
		return error(err_no_privilege)
	}
	
	// Check destination privileges
	if !dst_cal.acl.can_bind(principal) {
		return error(err_no_privilege)
	}
	
	// Get source object
	obj := src_cal.get_by_uid(uid) or { return error(err_resource_not_found) }
	
	// Check preconditions
	check_copy_move_preconditions(src_cal, dst_cal, obj)!
	
	// Move object
	dst_cal.put(obj)!
	src_cal.delete(uid)!
	
	return true
}

// Handles PROPFIND request
pub fn handle_propfind(cal &calbox.CalBox, props []string, principal Principal) !map[string]string {
	// Check privileges
	if !cal.acl.can_read(principal) {
		return error(err_no_privilege)
	}
	
	mut result := map[string]string{}
	
	// Get requested properties
	for prop in props {
		if value := get_prop_string(cal.props, prop) {
			result[prop] = value
		}
	}
	
	return result
}

// Handles PROPPATCH request
pub fn handle_proppatch(mut cal &calbox.CalBox, props map[string]string, principal Principal) !bool {
	// Check privileges
	if !cal.acl.can_write_props(principal) {
		return error(err_no_privilege)
	}
	
	// Validate and set properties
	for name, value in props {
		match name {
			calendar_timezone { validate_calendar_timezone(value)! }
			supported_calendar_component_set { validate_supported_component_set(value.split(','))! }
			else {}
		}
		set_prop(mut cal.props, name, value)
	}
	
	return true
}
