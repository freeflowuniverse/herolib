module models

import time

// Agenda represents a calendar event or meeting
pub struct Agenda {
	BaseModel
pub mut:
	title           string @[required]
	description     string
	agenda_type     AgendaType
	status          AgendaStatus
	priority        Priority
	start_time      time.Time
	end_time        time.Time
	all_day         bool
	location        string
	virtual_link    string
	organizer_id    int    // User who organized the event
	attendees       []Attendee
	required_attendees []int // User IDs who must attend
	optional_attendees []int // User IDs who are optional
	resources       []Resource // Rooms, equipment, etc.
	project_id      int    // Links to Project (optional)
	task_id         int    // Links to Task (optional)
	milestone_id    int    // Links to Milestone (optional)
	sprint_id       int    // Links to Sprint (optional)
	team_id         int    // Links to Team (optional)
	customer_id     int    // Links to Customer (optional)
	recurrence      Recurrence
	reminders       []Reminder
	agenda_items    []AgendaItem
	attachments     []Attachment
	notes           string
	meeting_notes   string
	action_items    []ActionItem
	decisions       []Decision
	recording_url   string
	transcript      string
	follow_up_tasks []int  // Task IDs created from this meeting
	time_zone       string
	visibility      EventVisibility
	booking_type    BookingType
	cost            f64    // Cost of the meeting (room, catering, etc.)
	capacity        int    // Maximum attendees
	waiting_list    []int  // User IDs on waiting list
	tags            []string
	custom_fields   map[string]string
}

// AgendaType for categorizing events
pub enum AgendaType {
	meeting
	appointment
	call
	interview
	presentation
	training
	workshop
	conference
	social
	break
	travel
	focus_time
	review
	planning
	retrospective
	standup
	demo
	one_on_one
	all_hands
	client_meeting
	vendor_meeting
}

// AgendaStatus for event lifecycle
pub enum AgendaStatus {
	draft
	scheduled
	confirmed
	in_progress
	completed
	cancelled
	postponed
	no_show
}

// EventVisibility for privacy settings
pub enum EventVisibility {
	public
	private
	confidential
	team_only
	project_only
}

// BookingType for different booking models
pub enum BookingType {
	fixed
	flexible
	recurring
	tentative
	blocked
}

// Attendee represents a meeting attendee
pub struct Attendee {
pub mut:
	user_id         int
	agenda_id       int
	attendance_type AttendanceType
	response_status ResponseStatus
	response_time   time.Time
	response_note   string
	actual_attendance bool
	check_in_time   time.Time
	check_out_time  time.Time
	role            AttendeeRole
	permissions     []string
	delegate_id     int    // User ID if someone else attends on their behalf
	cost            f64    // Cost for this attendee (travel, accommodation, etc.)
}

// AttendanceType for attendee requirements
pub enum AttendanceType {
	required
	optional
	informational
	presenter
	facilitator
	note_taker
}

// ResponseStatus for meeting responses
pub enum ResponseStatus {
	pending
	accepted
	declined
	tentative
	no_response
}

// AttendeeRole for meeting roles
pub enum AttendeeRole {
	participant
	presenter
	facilitator
	note_taker
	observer
	decision_maker
	subject_matter_expert
}

// Resource represents a bookable resource
pub struct Resource {
pub mut:
	id              int
	name            string
	resource_type   ResourceType
	location        string
	capacity        int
	cost_per_hour   f64
	booking_status  ResourceStatus
	equipment       []string
	requirements    []string
	contact_person  string
	booking_notes   string
}

// ResourceType for categorizing resources
pub enum ResourceType {
	meeting_room
	conference_room
	phone_booth
	desk
	equipment
	vehicle
	catering
	av_equipment
	parking_space
}

// ResourceStatus for resource availability
pub enum ResourceStatus {
	available
	booked
	maintenance
	unavailable
}

// Recurrence represents recurring event patterns
pub struct Recurrence {
pub mut:
	pattern         RecurrencePattern
	interval        int    // Every N days/weeks/months
	days_of_week    []int  // 0=Sunday, 1=Monday, etc.
	day_of_month    int    // For monthly recurrence
	week_of_month   int    // First, second, third, fourth, last week
	months          []int  // For yearly recurrence
	end_type        RecurrenceEndType
	end_date        time.Time
	occurrence_count int
	exceptions      []time.Time // Dates to skip
	modifications   []RecurrenceModification
}

// RecurrencePattern for different recurrence types
pub enum RecurrencePattern {
	none
	daily
	weekly
	monthly
	yearly
	custom
}

// RecurrenceEndType for when recurrence ends
pub enum RecurrenceEndType {
	never
	on_date
	after_occurrences
}

// RecurrenceModification for modifying specific occurrences
pub struct RecurrenceModification {
pub mut:
	original_date   time.Time
	new_start_time  time.Time
	new_end_time    time.Time
	cancelled       bool
	title_override  string
	location_override string
}

// AgendaItem represents an item on the meeting agenda
pub struct AgendaItem {
pub mut:
	id              int
	agenda_id       int
	title           string
	description     string
	item_type       AgendaItemType
	presenter_id    int
	duration_minutes int
	order_index     int
	status          AgendaItemStatus
	notes           string
	attachments     []Attachment
	action_items    []ActionItem
	decisions       []Decision
}

// AgendaItemType for categorizing agenda items
pub enum AgendaItemType {
	discussion
	presentation
	decision
	information
	brainstorming
	review
	planning
	update
	demo
	training
	break
}

// AgendaItemStatus for tracking agenda item progress
pub enum AgendaItemStatus {
	pending
	in_progress
	completed
	skipped
	deferred
}

// Decision represents a decision made during a meeting
pub struct Decision {
pub mut:
	id              int
	agenda_id       int
	agenda_item_id  int
	title           string
	description     string
	decision_type   DecisionType
	decision_maker_id int
	participants    []int  // User IDs involved in decision
	rationale       string
	alternatives    []string
	impact          string
	implementation_date time.Time
	review_date     time.Time
	status          DecisionStatus
	follow_up_tasks []int  // Task IDs for implementation
	created_at      time.Time
	created_by      int
}

// DecisionType for categorizing decisions
pub enum DecisionType {
	strategic
	tactical
	operational
	technical
	financial
	personnel
	process
	product
}

// DecisionStatus for tracking decision implementation
pub enum DecisionStatus {
	pending
	approved
	rejected
	deferred
	implemented
	under_review
}

// get_duration returns the event duration in minutes
pub fn (a Agenda) get_duration() int {
	if a.start_time.unix == 0 || a.end_time.unix == 0 {
		return 0
	}
	return int((a.end_time.unix - a.start_time.unix) / 60)
}

// is_past checks if the event is in the past
pub fn (a Agenda) is_past() bool {
	return time.now() > a.end_time
}

// is_current checks if the event is currently happening
pub fn (a Agenda) is_current() bool {
	now := time.now()
	return now >= a.start_time && now <= a.end_time
}

// is_upcoming checks if the event is in the future
pub fn (a Agenda) is_upcoming() bool {
	return time.now() < a.start_time
}

// get_time_until_start returns minutes until the event starts
pub fn (a Agenda) get_time_until_start() int {
	if a.is_past() || a.is_current() {
		return 0
	}
	return int((a.start_time.unix - time.now().unix) / 60)
}

// has_conflicts checks if this event conflicts with another
pub fn (a Agenda) has_conflicts(other Agenda) bool {
	// Check if events overlap
	return a.start_time < other.end_time && a.end_time > other.start_time
}

// get_attendee_count returns the number of attendees
pub fn (a Agenda) get_attendee_count() int {
	return a.attendees.len
}

// get_confirmed_attendees returns attendees who have accepted
pub fn (a Agenda) get_confirmed_attendees() []Attendee {
	return a.attendees.filter(it.response_status == .accepted)
}

// get_attendance_rate returns the percentage of attendees who actually attended
pub fn (a Agenda) get_attendance_rate() f32 {
	if a.attendees.len == 0 {
		return 0
	}
	
	attended := a.attendees.filter(it.actual_attendance).len
	return f32(attended) / f32(a.attendees.len) * 100
}

// add_attendee adds an attendee to the event
pub fn (mut a Agenda) add_attendee(user_id int, attendance_type AttendanceType, role AttendeeRole, by_user_id int) {
	// Check if attendee already exists
	for i, attendee in a.attendees {
		if attendee.user_id == user_id {
			// Update existing attendee
			a.attendees[i].attendance_type = attendance_type
			a.attendees[i].role = role
			a.update_timestamp(by_user_id)
			return
		}
	}
	
	// Add new attendee
	a.attendees << Attendee{
		user_id: user_id
		agenda_id: a.id
		attendance_type: attendance_type
		response_status: .pending
		role: role
	}
	a.update_timestamp(by_user_id)
}

// remove_attendee removes an attendee from the event
pub fn (mut a Agenda) remove_attendee(user_id int, by_user_id int) {
	for i, attendee in a.attendees {
		if attendee.user_id == user_id {
			a.attendees.delete(i)
			a.update_timestamp(by_user_id)
			return
		}
	}
}

// respond_to_invitation responds to a meeting invitation
pub fn (mut a Agenda) respond_to_invitation(user_id int, response ResponseStatus, note string, by_user_id int) {
	for i, mut attendee in a.attendees {
		if attendee.user_id == user_id {
			a.attendees[i].response_status = response
			a.attendees[i].response_time = time.now()
			a.attendees[i].response_note = note
			a.update_timestamp(by_user_id)
			return
		}
	}
}

// check_in marks an attendee as present
pub fn (mut a Agenda) check_in(user_id int, by_user_id int) {
	for i, mut attendee in a.attendees {
		if attendee.user_id == user_id {
			a.attendees[i].actual_attendance = true
			a.attendees[i].check_in_time = time.now()
			a.update_timestamp(by_user_id)
			return
		}
	}
}

// check_out marks an attendee as leaving
pub fn (mut a Agenda) check_out(user_id int, by_user_id int) {
	for i, mut attendee in a.attendees {
		if attendee.user_id == user_id {
			a.attendees[i].check_out_time = time.now()
			a.update_timestamp(by_user_id)
			return
		}
	}
}

// add_resource adds a resource to the event
pub fn (mut a Agenda) add_resource(resource Resource, by_user_id int) {
	a.resources << resource
	a.update_timestamp(by_user_id)
}

// add_agenda_item adds an item to the meeting agenda
pub fn (mut a Agenda) add_agenda_item(title string, description string, item_type AgendaItemType, presenter_id int, duration_minutes int, by_user_id int) {
	a.agenda_items << AgendaItem{
		id: a.agenda_items.len + 1
		agenda_id: a.id
		title: title
		description: description
		item_type: item_type
		presenter_id: presenter_id
		duration_minutes: duration_minutes
		order_index: a.agenda_items.len
		status: .pending
	}
	a.update_timestamp(by_user_id)
}

// complete_agenda_item marks an agenda item as completed
pub fn (mut a Agenda) complete_agenda_item(item_id int, notes string, by_user_id int) {
	for i, mut item in a.agenda_items {
		if item.id == item_id {
			a.agenda_items[i].status = .completed
			a.agenda_items[i].notes = notes
			a.update_timestamp(by_user_id)
			return
		}
	}
}

// add_decision records a decision made during the meeting
pub fn (mut a Agenda) add_decision(title string, description string, decision_type DecisionType, decision_maker_id int, participants []int, rationale string, by_user_id int) {
	a.decisions << Decision{
		id: a.decisions.len + 1
		agenda_id: a.id
		title: title
		description: description
		decision_type: decision_type
		decision_maker_id: decision_maker_id
		participants: participants
		rationale: rationale
		status: .pending
		created_at: time.now()
		created_by: by_user_id
	}
	a.update_timestamp(by_user_id)
}

// start_meeting starts the meeting
pub fn (mut a Agenda) start_meeting(by_user_id int) {
	a.status = .in_progress
	a.update_timestamp(by_user_id)
}

// end_meeting ends the meeting
pub fn (mut a Agenda) end_meeting(meeting_notes string, by_user_id int) {
	a.status = .completed
	a.meeting_notes = meeting_notes
	a.update_timestamp(by_user_id)
}

// cancel_meeting cancels the meeting
pub fn (mut a Agenda) cancel_meeting(by_user_id int) {
	a.status = .cancelled
	a.update_timestamp(by_user_id)
}

// postpone_meeting postpones the meeting
pub fn (mut a Agenda) postpone_meeting(new_start_time time.Time, new_end_time time.Time, by_user_id int) {
	a.status = .postponed
	a.start_time = new_start_time
	a.end_time = new_end_time
	a.update_timestamp(by_user_id)
}

// add_reminder adds a reminder for the event
pub fn (mut a Agenda) add_reminder(reminder_type ReminderType, minutes_before int, by_user_id int) {
	a.reminders << Reminder{
		reminder_type: reminder_type
		minutes_before: minutes_before
		sent: false
		created_at: time.now()
		created_by: by_user_id
	}
	a.update_timestamp(by_user_id)
}

// calculate_cost calculates the total cost of the meeting
pub fn (a Agenda) calculate_cost() f64 {
	mut total_cost := a.cost
	
	// Add attendee costs
	for attendee in a.attendees {
		total_cost += attendee.cost
	}
	
	// Add resource costs
	duration_hours := f64(a.get_duration()) / 60.0
	for resource in a.resources {
		total_cost += resource.cost_per_hour * duration_hours
	}
	
	return total_cost
}

// get_next_occurrence returns the next occurrence for recurring events
pub fn (a Agenda) get_next_occurrence() ?time.Time {
	if a.recurrence.pattern == .none {
		return none
	}
	
	// Simple implementation - in practice this would be more complex
	match a.recurrence.pattern {
		.daily {
			return time.Time{unix: a.start_time.unix + (86400 * a.recurrence.interval)}
		}
		.weekly {
			return time.Time{unix: a.start_time.unix + (86400 * 7 * a.recurrence.interval)}
		}
		.monthly {
			// Simplified - would need proper month calculation
			return time.Time{unix: a.start_time.unix + (86400 * 30 * a.recurrence.interval)}
		}
		else {
			return none
		}
	}
}

// is_overbooked checks if the event has more attendees than capacity
pub fn (a Agenda) is_overbooked() bool {
	return a.capacity > 0 && a.get_attendee_count() > a.capacity
}

// get_effectiveness_score calculates meeting effectiveness
pub fn (a Agenda) get_effectiveness_score() f32 {
	if a.status != .completed {
		return 0
	}
	
	mut score := f32(1.0)
	
	// Attendance rate (30% weight)
	attendance_rate := a.get_attendance_rate()
	score *= 0.3 + (0.7 * attendance_rate / 100)
	
	// Agenda completion (40% weight)
	if a.agenda_items.len > 0 {
		completed_items := a.agenda_items.filter(it.status == .completed).len
		completion_rate := f32(completed_items) / f32(a.agenda_items.len)
		score *= 0.4 + (0.6 * completion_rate)
	}
	
	// Decision making (30% weight)
	if a.decisions.len > 0 {
		approved_decisions := a.decisions.filter(it.status == .approved).len
		decision_rate := f32(approved_decisions) / f32(a.decisions.len)
		score *= 0.3 + (0.7 * decision_rate)
	}
	
	return score
}