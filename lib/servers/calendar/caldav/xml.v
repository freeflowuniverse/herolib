module caldav

import calendar.calbox
import encoding.xml

// XML namespace for CalDAV
const caldav_ns = 'urn:ietf:params:xml:ns:caldav'

// Parses a MKCALENDAR request body
pub fn parse_mkcalendar(body string) !map[string]string {
	doc := xml.parse(body) or { return error('Invalid XML') }
	
	mut props := map[string]string{}
	
	// Find set element
	set := doc.get_element('set') or { return error('Missing set element') }
	
	// Find prop element
	prop := set.get_element('prop') or { return error('Missing prop element') }
	
	// Parse properties
	for child in prop.children {
		match child.name {
			'displayname' { props['displayname'] = child.text() }
			'calendar-description' { props['calendar-description'] = child.text() }
			'calendar-timezone' { props['calendar-timezone'] = child.text() }
			'supported-calendar-component-set' {
				mut components := []string{}
				for comp in child.children {
					if comp.name == 'comp' {
						if name := comp.attributes['name'] {
							components << name
						}
					}
				}
				props['supported-calendar-component-set'] = components.join(',')
			}
			else {}
		}
	}
	
	return props
}

// Parses a calendar-query REPORT request body
pub fn parse_calendar_query(body string) !CalendarQueryFilter {
	doc := xml.parse(body) or { return error('Invalid XML') }
	
	mut filter := CalendarQueryFilter{}
	
	// Find filter element
	filter_elem := doc.get_element('filter') or { return error('Missing filter element') }
	
	// Parse filter
	if comp := filter_elem.get_element('comp-filter') {
		filter.comp_type = comp.attributes['name'] or { '' }
		
		// Check for time-range
		if tr := comp.get_element('time-range') {
			start := tr.attributes['start'] or { '' }
			end := tr.attributes['end'] or { '' }
			if start != '' && end != '' {
				filter.time_range = calbox.TimeRange{
					start: calbox.parse_datetime(start)!
					end: calbox.parse_datetime(end)!
				}
			}
		}
		
		// Check for property filter
		if prop := comp.get_element('prop-filter') {
			filter.prop_name = prop.attributes['name'] or { '' }
			
			// Check for text match
			if tm := prop.get_element('text-match') {
				filter.text_match = tm.text()
			}
		}
	}
	
	return filter
}

// Parses a calendar-multiget REPORT request body
pub fn parse_calendar_multiget(body string) ![]string {
	doc := xml.parse(body) or { return error('Invalid XML') }
	
	mut hrefs := []string{}
	
	// Find href elements
	for href in doc.find_all_elements('href') {
		hrefs << href.text()
	}
	
	return hrefs
}

// Parses a free-busy-query REPORT request body
pub fn parse_freebusy_query(body string) !calbox.TimeRange {
	doc := xml.parse(body) or { return error('Invalid XML') }
	
	// Find time-range element
	tr := doc.get_element('time-range') or { return error('Missing time-range element') }
	
	start := tr.attributes['start'] or { return error('Missing start attribute') }
	end := tr.attributes['end'] or { return error('Missing end attribute') }
	
	return calbox.TimeRange{
		start: calbox.parse_datetime(start)!
		end: calbox.parse_datetime(end)!
	}
}

// Generates XML response for MKCALENDAR
pub fn generate_mkcalendar_response() string {
	return '<?xml version="1.0" encoding="utf-8" ?>\n<mkcalendar-response xmlns="urn:ietf:params:xml:ns:caldav"/>'
}

// Generates XML response for calendar-query REPORT
pub fn generate_calendar_query_response(objects []calbox.CalendarObject) string {
	mut response := '<?xml version="1.0" encoding="utf-8" ?>\n<multistatus xmlns="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">\n'
	
	for obj in objects {
		response += '  <response>\n'
		response += '    <href>${obj.uid}</href>\n'
		response += '    <propstat>\n'
		response += '      <prop>\n'
		response += '        <getetag>${obj.etag}</getetag>\n'
		response += '        <C:calendar-data>${obj.to_ical()}</C:calendar-data>\n'
		response += '      </prop>\n'
		response += '      <status>HTTP/1.1 200 OK</status>\n'
		response += '    </propstat>\n'
		response += '  </response>\n'
	}
	
	response += '</multistatus>'
	return response
}

// Generates XML response for calendar-multiget REPORT
pub fn generate_calendar_multiget_response(objects []calbox.CalendarObject) string {
	// Same format as calendar-query response
	return generate_calendar_query_response(objects)
}

// Generates XML response for free-busy-query REPORT
pub fn generate_freebusy_response(ranges []calbox.TimeRange) string {
	mut response := 'BEGIN:VCALENDAR\r\n'
	response += 'VERSION:2.0\r\n'
	response += 'PRODID:-//Example Corp.//CalDAV Server//EN\r\n'
	response += 'BEGIN:VFREEBUSY\r\n'
	
	for r in ranges {
		response += 'FREEBUSY:${calbox.format_datetime_utc(r.start)}/${calbox.format_datetime_utc(r.end)}\r\n'
	}
	
	response += 'END:VFREEBUSY\r\n'
	response += 'END:VCALENDAR\r\n'
	return response
}
