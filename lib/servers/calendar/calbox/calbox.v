module calbox

// Represents a calendar attendee
@[heap]
pub struct Attendee {
pub mut:
	email         string
	name          string
	role          AttendeeRole
	partstat      AttendeePartStat
	rsvp          bool
	delegated_to  []string
	delegated_from []string
}

// Represents a recurrence rule
@[heap]
pub struct RecurrenceRule {
pub mut:
	frequency    RecurrenceFrequency
	interval     int       // How often the recurrence rule repeats
	count        ?int      // Number of occurrences
	until        ?i64      // End date timestamp
	by_second    []int
	by_minute    []int
	by_hour      []int
	by_day       []string  // MO, TU, WE, TH, FR, SA, SU with optional +/-prefix
	by_monthday  []int
	by_yearday   []int
	by_weekno    []int
	by_month     []int
	by_setpos    []int
	week_start   string    // MO, TU, WE, TH, FR, SA, SU
}

// Represents an alarm/reminder
@[heap]
pub struct Alarm {
pub mut:
	action       AlarmAction
	trigger      string    // When the alarm triggers (relative or absolute)
	description  string    // Used for DISPLAY and EMAIL
	summary      string    // Used for EMAIL
	attendees    []Attendee // Used for EMAIL
	attach      []string   // Used for AUDIO and EMAIL attachments
}

// Base calendar component fields
@[heap]
pub struct CalendarComponent {
pub mut:
	uid          string
	etag         string    // Entity tag for change tracking
	created      i64       // Creation timestamp
	modified     i64       // Last modified timestamp
	summary      string
	description  string
	categories   []string
	status       ComponentStatus
	class        ComponentClass
	url          string
	location     string
	geo          ?GeoLocation
	alarms       []Alarm
}

// Geographic location
pub struct GeoLocation {
pub mut:
	latitude     f64
	longitude    f64
}

// Represents an event
@[heap]
pub struct Event {
pub mut:
	CalendarComponent
	start_time   i64
	end_time     ?i64      // Either end_time or duration must be set
	duration     ?string   // ISO 8601 duration format
	rrule        ?RecurrenceRule
	rdate        []i64     // Additional recurrence dates
	exdate       []i64     // Dates to exclude
	transp       EventTransp
	attendees    []Attendee
	organizer    ?Attendee
}

// Represents a todo/task
@[heap]
pub struct Todo {
pub mut:
	CalendarComponent
	start_time   ?i64      // Optional start time
	due_time     ?i64      // When the todo is due
	duration     ?string   // Estimated duration
	completed    ?i64      // When the todo was completed
	percent      ?int      // Percent complete (0-100)
	rrule        ?RecurrenceRule
	attendees    []Attendee
	organizer    ?Attendee
}

// Represents a journal entry
@[heap]
pub struct Journal {
pub mut:
	CalendarComponent
	start_time   i64       // Date of the journal entry
	attendees    []Attendee
	organizer    ?Attendee
}

// Represents a calendar object resource (event, todo, journal)
@[heap]
pub struct CalendarObject {
pub mut:
	comp_type    string    // VEVENT, VTODO, VJOURNAL
	event        ?Event    // Set if comp_type is VEVENT
	todo         ?Todo     // Set if comp_type is VTODO  
	journal      ?Journal  // Set if comp_type is VJOURNAL
}

// Represents a calendar collection
@[heap]
pub struct CalBox {
mut:
	name        string
	objects     []CalendarObject
	description string
	timezone    string // Calendar timezone as iCalendar VTIMEZONE
	read_only   bool   // Whether calendar is read-only
	
	// Properties from CalDAV spec
	supported_components []string // e.g. ["VEVENT", "VTODO"]
	min_date_time       string   // Earliest date allowed
	max_date_time       string   // Latest date allowed
	max_instances       int      // Max recurrence instances
	max_attendees       int      // Max attendees per instance
	max_resource_size   int      // Max size of calendar object
}

// Creates a new calendar collection
pub fn new(name string) &CalBox {
	return &CalBox{
		name: name
		objects: []CalendarObject{}
		supported_components: ['VEVENT', 'VTODO', 'VJOURNAL']
		min_date_time: '19000101T000000Z'
		max_date_time: '20491231T235959Z'
		max_instances: 1000
		max_attendees: 100
		max_resource_size: 1024 * 1024 // 1MB
	}
}

// Returns all calendar objects
pub fn (mut self CalBox) list() ![]CalendarObject {
	return self.objects
}

// Gets a calendar object by UID
pub fn (mut self CalBox) get_by_uid(uid string) !CalendarObject {
	for obj in self.objects {
		match obj.comp_type {
			'VEVENT' { if obj.event?.uid == uid { return obj } }
			'VTODO' { if obj.todo?.uid == uid { return obj } }
			'VJOURNAL' { if obj.journal?.uid == uid { return obj } }
			else {}
		}
	}
	return error('Calendar object with UID ${uid} not found')
}

// Deletes a calendar object by UID
pub fn (mut self CalBox) delete(uid string) ! {
	if self.read_only {
		return error('Calendar is read-only')
	}
	
	for i, obj in self.objects {
		mut found := false
		match obj.comp_type {
			'VEVENT' { found = obj.event?.uid == uid }
			'VTODO' { found = obj.todo?.uid == uid }
			'VJOURNAL' { found = obj.journal?.uid == uid }
			else {}
		}
		if found {
			self.objects.delete(i)
			return
		}
	}
	return error('Calendar object with UID ${uid} not found')
}

// Validates a calendar object
fn (mut self CalBox) validate(obj CalendarObject) ! {
	// Validate component type is supported
	if obj.comp_type !in self.supported_components {
		return error('Calendar component type ${obj.comp_type} not supported')
	}
	
	// Validate based on component type
	match obj.comp_type {
		'VEVENT' {
			event := obj.event or { return error('VEVENT component missing') }
			
			// Validate required fields
			if event.uid.len == 0 {
				return error('UID is required')
			}
			if event.start_time == 0 {
				return error('Start time is required')
			}
			if event.end_time == none && event.duration == none {
				return error('Either end time or duration is required')
			}
			
			// Validate attendees count
			if event.attendees.len > self.max_attendees {
				return error('Exceeds maximum attendees limit of ${self.max_attendees}')
			}
			
			// Validate recurrence
			if event.rrule != none {
				// TODO: Validate max instances once recurrence expansion is implemented
			}
		}
		'VTODO' {
			todo := obj.todo or { return error('VTODO component missing') }
			
			// Validate required fields
			if todo.uid.len == 0 {
				return error('UID is required')
			}
			
			// Validate attendees count
			if todo.attendees.len > self.max_attendees {
				return error('Exceeds maximum attendees limit of ${self.max_attendees}')
			}
		}
		'VJOURNAL' {
			journal := obj.journal or { return error('VJOURNAL component missing') }
			
			// Validate required fields
			if journal.uid.len == 0 {
				return error('UID is required')
			}
			if journal.start_time == 0 {
				return error('Start time is required')
			}
			
			// Validate attendees count
			if journal.attendees.len > self.max_attendees {
				return error('Exceeds maximum attendees limit of ${self.max_attendees}')
			}
		}
		else {}
	}
}

// Adds or updates a calendar object
pub fn (mut self CalBox) put(obj CalendarObject) ! {
	if self.read_only {
		return error('Calendar is read-only')
	}
	
	// Validate the object
	self.validate(obj) or { return err }
	
	mut found := false
	for i, existing in self.objects {
		mut match_uid := false
		match obj.comp_type {
			'VEVENT' { match_uid = obj.event?.uid == existing.event?.uid }
			'VTODO' { match_uid = obj.todo?.uid == existing.todo?.uid }
			'VJOURNAL' { match_uid = obj.journal?.uid == existing.journal?.uid }
			else {}
		}
		if match_uid {
			self.objects[i] = obj
			found = true
			break
		}
	}
	
	if !found {
		self.objects << obj
	}
}

@[params]
pub struct TimeRange {
pub mut:
	start i64 // UTC timestamp
	end   i64 // UTC timestamp
}

// Checks if a timestamp falls within a time range
fn is_in_range(ts i64, tr TimeRange) bool {
	return ts >= tr.start && ts < tr.end
}

// Checks if an event overlaps with a time range
fn (event Event) overlaps(tr TimeRange) bool {
	// Get end time from either end_time or duration
	mut end_ts := event.end_time or {
		// TODO: Add duration parsing to get actual end time
		event.start_time + 3600 // Default 1 hour if no end/duration
	}
	
	// Check basic overlap
	if is_in_range(event.start_time, tr) || is_in_range(end_ts, tr) {
		return true
	}
	
	// Check recurrences if any
	if rule := event.rrule {
		// TODO: Implement recurrence expansion
		// For now just check if the rule's until date (if any) is after range start
		if until := rule.until {
			return until >= tr.start
		}
		return true // Infinite recurrence overlaps everything
	}
	
	return false
}

// Checks if a todo overlaps with a time range
fn (todo Todo) overlaps(tr TimeRange) bool {
	if start := todo.start_time {
		if is_in_range(start, tr) {
			return true
		}
	}
	
	if due := todo.due_time {
		if is_in_range(due, tr) {
			return true
		}
	}
	
	if completed := todo.completed {
		if is_in_range(completed, tr) {
			return true
		}
	}
	
	return false
}

// Checks if a journal entry overlaps with a time range
fn (journal Journal) overlaps(tr TimeRange) bool {
	return is_in_range(journal.start_time, tr)
}

// Finds calendar objects in the given time range
pub fn (mut self CalBox) find_by_time(tr TimeRange) ![]CalendarObject {
	mut results := []CalendarObject{}
	
	for obj in self.objects {
		match obj.comp_type {
			'VEVENT' {
				if event := obj.event {
					// Get all instances in the time range
					instances := event.get_instances(tr)!
					if instances.len > 0 {
						results << obj
					}
				}
			}
			'VTODO' {
				if todo := obj.todo {
					// Check todo timing
					mut overlaps := false
					
					// Check start time if set
					if start := todo.start_time {
						if is_in_range(start, tr) {
							overlaps = true
						}
					}
					
					// Check due time if set
					if due := todo.due_time {
						if is_in_range(due, tr) {
							overlaps = true
						}
					}
					
					// Check completed time if set
					if completed := todo.completed {
						if is_in_range(completed, tr) {
							overlaps = true
						}
					}
					
					// If no timing info, include if created in range
					if todo.start_time == none && todo.due_time == none && todo.completed == none {
						if is_in_range(todo.created, tr) {
							overlaps = true
						}
					}
					
					if overlaps {
						results << obj
					}
				}
			}
			'VJOURNAL' {
				if journal := obj.journal {
					// Journal entries are point-in-time
					if is_in_range(journal.start_time, tr) {
						results << obj
					}
				}
			}
			else {}
		}
	}
	
	return results
}

// Gets all instances of calendar objects in a time range
pub fn (mut self CalBox) get_instances(tr TimeRange) ![]EventInstance {
	mut instances := []EventInstance{}
	
	for obj in self.objects {
		if obj.comp_type == 'VEVENT' {
			if event := obj.event {
				event_instances := event.get_instances(tr)!
				instances << event_instances
			}
		}
	}
	
	// Sort by start time
	instances.sort(a.start_time < b.start_time)
	
	return instances
}

// Gets free/busy time in a given range
pub fn (mut self CalBox) get_freebusy(tr TimeRange) ![]TimeRange {
	mut busy_ranges := []TimeRange{}
	
	// Get all event instances in the range
	instances := self.get_instances(tr)!
	
	// Convert instances to busy time ranges
	for instance in instances {
		// Skip transparent events
		if instance.original_event.transp == 'TRANSPARENT' {
			continue
		}
		
		// Skip cancelled events
		if instance.original_event.status == 'CANCELLED' {
			continue
		}
		
		busy_ranges << TimeRange{
			start: instance.start_time
			end: instance.end_time
		}
	}
	
	// Merge overlapping ranges
	if busy_ranges.len > 0 {
		busy_ranges.sort(a.start < b.start)
		mut merged := []TimeRange{}
		mut current := busy_ranges[0]
		
		for i := 1; i < busy_ranges.len; i++ {
			if busy_ranges[i].start <= current.end {
				// Ranges overlap, extend current range
				if busy_ranges[i].end > current.end {
					current.end = busy_ranges[i].end
				}
			} else {
				// No overlap, start new range
				merged << current
				current = busy_ranges[i]
			}
		}
		merged << current
		return merged
	}
	
	return busy_ranges
}

// Returns number of calendar objects
pub fn (mut self CalBox) len() int {
	return self.objects.len
}
