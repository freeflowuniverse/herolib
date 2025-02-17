module caldav

import calendar.calbox

// Represents a CalDAV collection
pub struct Collection {
pub mut:
	path        string
	cal         &calbox.CalBox
	props       map[string]string
	acl         ACL
	parent      ?&Collection
	children    map[string]&Collection
	is_calendar bool
}

// Creates a new collection
pub fn new_collection(path string, is_calendar bool) &Collection {
	mut col := &Collection{
		path:        path
		props:       map[string]string{}
		acl:         new_acl()
		children:    map[string]&Collection{}
		is_calendar: is_calendar
	}

	if is_calendar {
		col.cal = calbox.new(path.all_after_last('/'))
	}

	return col
}

// Gets a child collection by name
pub fn (c Collection) get_child(name string) ?&Collection {
	return c.children[name]
}

// Adds a child collection
pub fn (mut c Collection) add_child(name string, child &Collection) {
	c.children[name] = child
	child.parent = c
}

// Removes a child collection
pub fn (mut c Collection) remove_child(name string) {
	c.children.delete(name)
}

// Gets all child collections
pub fn (c Collection) list_children() []&Collection {
	mut children := []&Collection{}
	for _, child in c.children {
		children << child
	}
	return children
}

// Gets all calendar collections
pub fn (c Collection) list_calendars() []&Collection {
	mut calendars := []&Collection{}
	for _, child in c.children {
		if child.is_calendar {
			calendars << child
		}
		calendars << child.list_calendars()
	}
	return calendars
}

// Gets all calendar collections for a principal
pub fn (c Collection) list_principal_calendars(principal Principal) []&Collection {
	mut calendars := []&Collection{}
	for cal in c.list_calendars() {
		if cal.acl.can_read(principal) {
			calendars << cal
		}
	}
	return calendars
}

// Gets a collection by path
pub fn (c Collection) find_by_path(path string) ?&Collection {
	if c.path == path {
		return c
	}

	parts := path.trim_left('/').split('/')
	mut current := &c

	for part in parts {
		if child := current.get_child(part) {
			current = child
		} else {
			return none
		}
	}

	return current
}

// Gets a calendar object by href
pub fn (c Collection) get_object_by_href(href string) ?calbox.CalendarObject {
	if !c.is_calendar {
		return none
	}

	uid := href.all_after_last('/')
	return c.cal.get_by_uid(uid)
}

// Gets all calendar objects
pub fn (c Collection) list_objects() []calbox.CalendarObject {
	if !c.is_calendar {
		return []calbox.CalendarObject{}
	}

	return c.cal.list() or { []calbox.CalendarObject{} }
}

// Gets all calendar objects matching a filter
pub fn (c Collection) find_objects(filter CalendarQueryFilter) []calbox.CalendarObject {
	if !c.is_calendar {
		return []calbox.CalendarObject{}
	}

	return c.cal.find_by_filter(filter) or { []calbox.CalendarObject{} }
}

// Gets free/busy information
pub fn (c Collection) get_freebusy(tr calbox.TimeRange) []calbox.TimeRange {
	if !c.is_calendar {
		return []calbox.TimeRange{}
	}

	return c.cal.get_freebusy(tr) or { []calbox.TimeRange{} }
}

// Adds/updates a calendar object
pub fn (mut c Collection) put_object(obj calbox.CalendarObject) ! {
	if !c.is_calendar {
		return error('Not a calendar collection')
	}

	c.cal.put(obj)!
}

// Deletes a calendar object
pub fn (mut c Collection) delete_object(uid string) ! {
	if !c.is_calendar {
		return error('Not a calendar collection')
	}

	c.cal.delete(uid)!
}
