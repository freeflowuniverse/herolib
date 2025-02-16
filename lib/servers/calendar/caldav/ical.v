module caldav

import calendar.calbox
import time

// Formats a timestamp as an iCalendar date-time string
fn format_datetime(ts i64) string {
	return calbox.format_datetime_utc(ts)
}

// Formats a date-time property with optional parameters
fn format_datetime_property(name string, params map[string]string, ts i64) string {
	return format_property(name, params, calbox.format_datetime_utc(ts))
}

// Formats a date property with optional parameters
fn format_date_property(name string, params map[string]string, ts i64) string {
	return format_property(name, params, calbox.format_date(ts))
}

// Formats a date or date-time property based on has_time flag
fn format_date_or_datetime_property(name string, params map[string]string, ts i64, has_time bool) string {
	return format_property(name, params, calbox.format_date_or_datetime(ts, has_time))
}

// Splits a line into property name, parameters, and value
fn parse_property(line string) !(string, map[string]string, string) {
	// Find the colon that separates name+params from value
	value_start := line.index(':') or {
		return error('Invalid property format: missing colon')
	}
	
	// Split into name+params and value
	name_params := line[..value_start].trim_space()
	value := line[value_start + 1..].trim_space()
	
	// Split name and parameters
	parts := name_params.split(';')
	name := parts[0]
	
	// Parse parameters
	mut params := map[string]string{}
	for i := 1; i < parts.len; i++ {
		param_parts := parts[i].split('=')
		if param_parts.len == 2 {
			params[param_parts[0]] = param_parts[1]
		}
	}
	
	return name, params, value
}

// Parses an iCalendar content line
fn parse_content_line(line string) !string {
	// Handle line unfolding (lines starting with space/tab are continuations)
	if line.starts_with(' ') || line.starts_with('\t') {
		return line[1..]
	}
	return line
}

// Parses an attendee property value
fn parse_attendee(value string, params map[string]string) !calbox.Attendee {
	mut attendee := calbox.Attendee{
		email: value.replace('mailto:', '')
	}
	
	if cn := params['CN'] {
		attendee.name = cn
	}
	if role := params['ROLE'] {
		attendee.role = calbox.parse_attendee_role(role)!
	}
	if partstat := params['PARTSTAT'] {
		attendee.partstat = calbox.parse_attendee_partstat(partstat)!
	}
	if rsvp := params['RSVP'] {
		attendee.rsvp = rsvp == 'TRUE'
	}
	
	return attendee
}

// Parses a recurrence rule
fn parse_rrule(value string) !calbox.RecurrenceRule {
	mut rule := calbox.RecurrenceRule{
		interval: 1 // Default interval
	}
	
	parts := value.split(';')
	for part in parts {
		name_value := part.split('=')
		if name_value.len != 2 {
			continue
		}
		
		name := name_value[0]
		value := name_value[1]
		
		match name {
			'FREQ' { rule.frequency = calbox.parse_recurrence_frequency(value)! }
			'INTERVAL' { rule.interval = value.int() }
			'COUNT' { rule.count = value.int() }
			'UNTIL' { rule.until = calbox.parse_datetime(value)! }
			'BYDAY' { rule.by_day = value.split(',') }
			'BYMONTH' { rule.by_month = value.split(',').map(it.int()) }
			'BYMONTHDAY' { rule.by_monthday = value.split(',').map(it.int()) }
			'WKST' { rule.week_start = value }
			else {}
		}
	}
	
	return rule
}

// Parses an alarm component
fn parse_alarm(lines []string) !calbox.Alarm {
	mut alarm := calbox.Alarm{}
	mut i := 0
	
	while i < lines.len {
		line := lines[i]
		if line == 'END:VALARM' {
			break
		}
		
		name, params, value := parse_property(line)!
		match name {
			'ACTION' { alarm.action = calbox.parse_alarm_action(value)! }
			'TRIGGER' { alarm.trigger = value }
			'DESCRIPTION' { alarm.description = value }
			'SUMMARY' { alarm.summary = value }
			'ATTENDEE' { alarm.attendees << parse_attendee(value, params)! }
			'ATTACH' { alarm.attach << value }
			else {}
		}
		i++
	}
	
	return alarm
}

// Parses common component properties
fn parse_component(lines []string, mut comp calbox.CalendarComponent) ! {
	for line in lines {
		if line.starts_with('BEGIN:') || line.starts_with('END:') {
			continue
		}
		
		name, params, value := parse_property(line)!
		match name {
			'UID' { comp.uid = value }
			'DTSTAMP' { comp.created = calbox.parse_datetime(value)! }
			'LAST-MODIFIED' { comp.modified = calbox.parse_datetime(value)! }
			'SUMMARY' { comp.summary = value }
			'DESCRIPTION' { comp.description = value }
			'CATEGORIES' { comp.categories = value.split(',') }
			'STATUS' { comp.status = calbox.parse_component_status(value)! }
			'CLASS' { comp.class = calbox.parse_component_class(value)! }
			'URL' { comp.url = value }
			'LOCATION' { comp.location = value }
			'GEO' {
				parts := value.split(';')
				if parts.len == 2 {
					comp.geo = calbox.GeoLocation{
						latitude: parts[0].f64()
						longitude: parts[1].f64()
					}
				}
			}
			else {}
		}
	}
}

// Parses an iCalendar string into a calendar object
pub fn from_ical(ical string) !calbox.CalendarObject {
	lines := ical.split_into_lines().map(parse_content_line)!
	
	mut obj := calbox.CalendarObject{}
	mut in_component := false
	mut component_lines := []string{}
	
	for line in lines {
		if line.starts_with('BEGIN:V') {
			if line == 'BEGIN:VCALENDAR' {
				continue
			}
			in_component = true
			obj.comp_type = line.replace('BEGIN:', '')
			continue
		}
		
		if line.starts_with('END:V') {
			if line == 'END:VCALENDAR' {
				continue
			}
			in_component = false
			
			// Parse the collected component
			match obj.comp_type {
				'VEVENT' {
					mut event := calbox.Event{}
					parse_component(component_lines, mut event.CalendarComponent)!
					for line in component_lines {
						name, params, value := parse_property(line)!
						match name {
							'DTSTART' { event.start_time = calbox.parse_datetime(value)! }
							'DTEND' { event.end_time = calbox.parse_datetime(value)! }
							'DURATION' { event.duration = value }
							'RRULE' { event.rrule = parse_rrule(value)! }
							'RDATE' { event.rdate << calbox.parse_datetime(value)! }
							'EXDATE' { event.exdate << calbox.parse_datetime(value)! }
							'TRANSP' { event.transp = calbox.parse_event_transp(value)! }
							'ATTENDEE' { event.attendees << parse_attendee(value, params)! }
							'ORGANIZER' { event.organizer = parse_attendee(value, params)! }
							else {}
						}
					}
					obj.event = event
				}
				'VTODO' {
					mut todo := calbox.Todo{}
					parse_component(component_lines, mut todo.CalendarComponent)!
					for line in component_lines {
						name, params, value := parse_property(line)!
						match name {
							'DTSTART' { todo.start_time = calbox.parse_datetime(value)! }
							'DUE' { todo.due_time = calbox.parse_datetime(value)! }
							'DURATION' { todo.duration = value }
							'COMPLETED' { todo.completed = calbox.parse_datetime(value)! }
							'PERCENT-COMPLETE' { todo.percent = value.int() }
							'RRULE' { todo.rrule = parse_rrule(value)! }
							'ATTENDEE' { todo.attendees << parse_attendee(value, params)! }
							'ORGANIZER' { todo.organizer = parse_attendee(value, params)! }
							else {}
						}
					}
					obj.todo = todo
				}
				'VJOURNAL' {
					mut journal := calbox.Journal{}
					parse_component(component_lines, mut journal.CalendarComponent)!
					for line in component_lines {
						name, params, value := parse_property(line)!
						match name {
							'DTSTART' { journal.start_time = calbox.parse_datetime(value)! }
							'ATTENDEE' { journal.attendees << parse_attendee(value, params)! }
							'ORGANIZER' { journal.organizer = parse_attendee(value, params)! }
							else {}
						}
					}
					obj.journal = journal
				}
				else {}
			}
			
			component_lines.clear()
			continue
		}
		
		if in_component {
			component_lines << line
		}
	}
	
	return obj
}

// Folds a line according to iCalendar spec (max 75 chars)
fn fold_line(line string) string {
	if line.len <= 75 {
		return line
	}
	
	mut result := []string{}
	mut current := line[0..75]
	mut remaining := line[75..]
	result << current
	
	for remaining.len > 0 {
		if remaining.len <= 74 {
			result << ' ${remaining}'
			break
		}
		current = remaining[0..74]
		remaining = remaining[74..]
		result << ' ${current}'
	}
	
	return result.join('\r\n')
}

// Formats a property with optional parameters
fn format_property(name string, params map[string]string, value string) string {
	mut param_str := ''
	if params.len > 0 {
		param_parts := params.keys().map(fn (k string, v map[string]string) string {
			return '${k}=${v[k]}'
		})
		param_str = ';${param_parts.join(";")}'
	}
	
	line := '${name}${param_str}:${value}'
	return fold_line(line)
}

// Formats attendee properties
fn format_attendee(a calbox.Attendee) string {
	mut params := map[string]string{}
	mut props := []string{}
	
	props << 'ROLE=${a.role.str()}'
	props << 'PARTSTAT=${a.partstat.str()}'
	
	if a.rsvp {
		props << 'RSVP=TRUE'
	}
	if a.name != '' {
		props << 'CN=${a.name}'
	}
	
	params := if props.len > 0 { ';${props.join(";")}' } else { '' }
	return 'ATTENDEE${params}:mailto:${a.email}'
}

// Formats a recurrence rule
fn format_rrule(r calbox.RecurrenceRule) string {
	mut parts := []string{}
	parts << 'FREQ=${r.frequency.str()}'
	
	if r.interval > 1 {
		parts << 'INTERVAL=${r.interval}'
	}
	
	if count := r.count {
		parts << 'COUNT=${count}'
	}
	
	if until := r.until {
		parts << 'UNTIL=${format_datetime(until)}'
	}
	
	if r.by_day.len > 0 {
		parts << 'BYDAY=${r.by_day.join(",")}'
	}
	
	if r.by_month.len > 0 {
		parts << 'BYMONTH=${r.by_month.map(it.str()).join(",")}'
	}
	
	if r.by_monthday.len > 0 {
		parts << 'BYMONTHDAY=${r.by_monthday.map(it.str()).join(",")}'
	}
	
	if r.week_start != '' {
		parts << 'WKST=${r.week_start}'
	}
	
	return 'RRULE:${parts.join(";")}'
}

// Formats alarm properties
fn format_alarm(a calbox.Alarm) string {
	mut lines := []string{}
	lines << 'BEGIN:VALARM'
	lines << 'ACTION:${a.action.str()}'
	lines << 'TRIGGER:${a.trigger}'
	
	if a.description != '' {
		lines << 'DESCRIPTION:${a.description}'
	}
	
	if a.summary != '' {
		lines << 'SUMMARY:${a.summary}'
	}
	
	for attendee in a.attendees {
		lines << format_attendee(attendee)
	}
	
	for attach in a.attach {
		lines << 'ATTACH:${attach}'
	}
	
	lines << 'END:VALARM'
	return lines.join('\r\n')
}

// Formats common component properties
fn format_component(c calbox.CalendarComponent) []string {
	mut lines := []string{}
	
	lines << 'UID:${c.uid}'
	lines << 'DTSTAMP:${format_datetime(c.created)}'
	
	if c.summary != '' {
		lines << 'SUMMARY:${c.summary}'
	}
	
	if c.description != '' {
		lines << 'DESCRIPTION:${c.description}'
	}
	
	if c.categories.len > 0 {
		lines << 'CATEGORIES:${c.categories.join(",")}'
	}
	
	lines << 'STATUS:${c.status.str()}'
	lines << 'CLASS:${c.class.str()}'
	
	if c.url != '' {
		lines << 'URL:${c.url}'
	}
	
	if c.location != '' {
		lines << 'LOCATION:${c.location}'
	}
	
	if geo := c.geo {
		lines << 'GEO:${geo.latitude};${geo.longitude}'
	}
	
	for alarm in c.alarms {
		lines << format_alarm(alarm)
	}
	
	return lines
}

// Converts an event to iCalendar format
pub fn to_ical_event(event calbox.Event) string {
	mut lines := []string{}
	lines << 'BEGIN:VEVENT'
	
	// Add common properties
	lines << format_component(event.CalendarComponent)
	
	// Add event-specific properties
	lines << format_datetime_property('DTSTART', map[string]string{}, event.start_time)
	
	if end := event.end_time {
		lines << format_datetime_property('DTEND', map[string]string{}, end)
	} else if dur := event.duration {
		lines << format_property('DURATION', map[string]string{}, dur)
	}
	
	lines << 'TRANSP:${event.transp.str()}'
	
	if rule := event.rrule {
		lines << format_rrule(rule)
	}
	
	for ts in event.rdate {
		lines << 'RDATE:${format_datetime(ts)}'
	}
	
	for ts in event.exdate {
		lines << 'EXDATE:${format_datetime(ts)}'
	}
	
	for attendee in event.attendees {
		lines << format_attendee(attendee)
	}
	
	if organizer := event.organizer {
		lines << format_attendee(organizer).replace('ATTENDEE:', 'ORGANIZER:')
	}
	
	lines << 'END:VEVENT'
	return lines.join('\r\n')
}

// Converts a todo to iCalendar format
pub fn to_ical_todo(todo calbox.Todo) string {
	mut lines := []string{}
	lines << 'BEGIN:VTODO'
	
	// Add common properties
	lines << format_component(todo.CalendarComponent)
	
	// Add todo-specific properties
	if start := todo.start_time {
		lines << format_datetime_property('DTSTART', map[string]string{}, start)
	}
	
	if due := todo.due_time {
		lines << format_datetime_property('DUE', map[string]string{}, due)
	}
	
	if dur := todo.duration {
		lines << format_property('DURATION', map[string]string{}, dur)
	}
	
	if completed := todo.completed {
		lines << format_datetime_property('COMPLETED', map[string]string{}, completed)
	}
	
	if percent := todo.percent {
		lines << 'PERCENT-COMPLETE:${percent}'
	}
	
	if rule := todo.rrule {
		lines << format_rrule(rule)
	}
	
	for attendee in todo.attendees {
		lines << format_attendee(attendee)
	}
	
	if organizer := todo.organizer {
		lines << format_attendee(organizer).replace('ATTENDEE:', 'ORGANIZER:')
	}
	
	lines << 'END:VTODO'
	return lines.join('\r\n')
}

// Converts a journal entry to iCalendar format
pub fn to_ical_journal(journal calbox.Journal) string {
	mut lines := []string{}
	lines << 'BEGIN:VJOURNAL'
	
	// Add common properties
	lines << format_component(journal.CalendarComponent)
	
	// Add journal-specific properties
	lines << 'DTSTART:${format_datetime(journal.start_time)}'
	
	for attendee in journal.attendees {
		lines << format_attendee(attendee)
	}
	
	if organizer := journal.organizer {
		lines << format_attendee(organizer).replace('ATTENDEE:', 'ORGANIZER:')
	}
	
	lines << 'END:VJOURNAL'
	return lines.join('\r\n')
}

// Converts a calendar object to iCalendar format
pub fn to_ical(obj calbox.CalendarObject) string {
	mut lines := []string{}
	lines << 'BEGIN:VCALENDAR'
	lines << 'VERSION:2.0'
	lines << 'PRODID:-//HeroLib//CalDAV Client//EN'
	
	match obj.comp_type {
		'VEVENT' {
			if event := obj.event {
				lines << to_ical_event(event)
			}
		}
		'VTODO' {
			if todo := obj.todo {
				lines << to_ical_todo(todo)
			}
		}
		'VJOURNAL' {
			if journal := obj.journal {
				lines << to_ical_journal(journal)
			}
		}
		else {}
	}
	
	lines << 'END:VCALENDAR'
	return lines.join('\r\n')
}
