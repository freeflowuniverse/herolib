module calbox

// Represents a calendar collection
@[heap]
pub struct Calendar {
mut:
	name        string
	objects     []CalendarItem
	description string
	timezone    string // Calendar timezone as iCalendar VTIMEZONE
	read_only   bool   // Whether calendar is read-only

	// Properties from CalDAV spec
	supported_components []ComponentType // e.g. [.vevent, .vtodo]
	min_date_time        string          // Earliest date allowed
	max_date_time        string          // Latest date allowed
	max_instances        int             // Max recurrence instances
	max_attendees        int             // Max attendees per instance
	max_resource_size    int             // Max size of calendar object
}

// Creates a new calendar collection
pub fn new(name string) &Calendar {
	return &Calendar{
		name:                 name
		objects:              []CalendarItem{}
		supported_components: [ComponentType.vevent, ComponentType.vtodo, ComponentType.vjournal]
		min_date_time:        '19000101T000000Z'
		max_date_time:        '20491231T235959Z'
		max_instances:        1000
		max_attendees:        100
		max_resource_size:    1024 * 1024 // 1MB
	}
}

// Returns all calendar objects
pub fn (mut self Calendar) list() ![]CalendarItem {
	return self.objects
}

// Gets a calendar object by UID
pub fn (mut self Calendar) get_by_uid(uid string) ?CalendarItem {
	for obj in self.objects {
		match obj.comp_type {
			.vevent {
				if obj.event?.uid == uid {
					return obj
				}
			}
			.vtodo {
				if obj.todo?.uid == uid {
					return obj
				}
			}
			.vjournal {
				if obj.journal?.uid == uid {
					return obj
				}
			}
		}
	}
	return none
}

// Deletes a calendar object by UID
pub fn (mut self Calendar) delete(uid string) ! {
	if self.read_only {
		return error('Calendar is read-only')
	}

	for i, obj in self.objects {
		mut found := false
		match obj.comp_type {
			.vevent {
				if event := obj.event {
					found = event.uid == uid
				}
			}
			.vtodo {
				if todo := obj.todo {
					found = todo.uid == uid
				}
			}
			.vjournal {
				if journal := obj.journal {
					found = journal.uid == uid
				}
			}
		}
		if found {
			self.objects.delete(i)
			return
		}
	}
	return error('Calendar object with UID ${uid} not found')
}

// Validates a calendar object
fn (mut self Calendar) validate(obj CalendarItem) ! {
	// Validate component type is supported
	if obj.comp_type !in self.supported_components {
		return error('Calendar component type ${obj.comp_type} not supported')
	}

	// Validate based on component type
	match obj.comp_type {
		.vevent {
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
		.vtodo {
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
		.vjournal {
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
	}
}

// Adds or updates a calendar object
pub fn (mut self Calendar) put(obj CalendarItem) ! {
	if self.read_only {
		return error('Calendar is read-only')
	}

	// Validate the object
	self.validate(obj) or { return err }

	mut found := false
	for i, existing in self.objects {
		mut match_uid := false
		match obj.comp_type {
			.vevent {
				if e1 := obj.event {
					if e2 := existing.event {
						match_uid = e1.uid == e2.uid
					}
				}
			}
			.vtodo {
				if t1 := obj.todo {
					if t2 := existing.todo {
						match_uid = t1.uid == t2.uid
					}
				}
			}
			.vjournal {
				if j1 := obj.journal {
					if j2 := existing.journal {
						match_uid = j1.uid == j2.uid
					}
				}
			}
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

// Checks if a journal entry overlaps with a time range
fn (journal Journal) overlaps(tr TimeRange) bool {
	return is_in_range(journal.start_time, tr)
}

// Finds calendar objects in the given time range
pub fn (mut self Calendar) find_by_time(tr TimeRange) ![]CalendarItem {
	mut results := []CalendarItem{}

	for obj in self.objects {
		match obj.comp_type {
			.vevent {
				if event := obj.event {
					// Get all instances in the time range
					instances := event.get_instances(tr)!
					if instances.len > 0 {
						results << obj
					}
				}
			}
			.vtodo {
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
			.vjournal {
				if journal := obj.journal {
					// Journal entries are point-in-time
					if is_in_range(journal.start_time, tr) {
						results << obj
					}
				}
			}
		}
	}

	return results
}

// Gets all instances of calendar objects in a time range
pub fn (mut self Calendar) get_instances(tr TimeRange) ![]EventInstance {
	mut instances := []EventInstance{}

	for obj in self.objects {
		if obj.comp_type == .vevent {
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
pub fn (mut self Calendar) get_freebusy(tr TimeRange) ![]TimeRange {
	mut busy_ranges := []TimeRange{}

	// Get all event instances in the range
	instances := self.get_instances(tr)!

	// Convert instances to busy time ranges
	for instance in instances {
		// Skip transparent events
		if instance.original_event.transp == .transparent {
			continue
		}

		// Skip cancelled events
		if instance.original_event.status == .cancelled {
			continue
		}

		busy_ranges << TimeRange{
			start: instance.start_time
			end:   instance.end_time
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
pub fn (mut self Calendar) len() int {
	return self.objects.len
}
