module calbox

// Attendee role types
pub enum AttendeeRole {
	chair            // Meeting chair/organizer
	req_participant  // Required participant
	opt_participant  // Optional participant
	non_participant  // Non-participant (e.g. room, resource)
}

// String representation of attendee role
pub fn (r AttendeeRole) str() string {
	return match r {
		.chair { 'CHAIR' }
		.req_participant { 'REQ-PARTICIPANT' }
		.opt_participant { 'OPT-PARTICIPANT' }
		.non_participant { 'NON-PARTICIPANT' }
	}
}

// Parse attendee role from string
pub fn parse_attendee_role(s string) !AttendeeRole {
	return match s {
		'CHAIR' { AttendeeRole.chair }
		'REQ-PARTICIPANT' { AttendeeRole.req_participant }
		'OPT-PARTICIPANT' { AttendeeRole.opt_participant }
		'NON-PARTICIPANT' { AttendeeRole.non_participant }
		else { error('Invalid attendee role: ${s}') }
	}
}

// Attendee participation status
pub enum AttendeePartStat {
	needs_action  // No response yet
	accepted      // Accepted invitation
	declined      // Declined invitation
	tentative     // Tentatively accepted
	delegated     // Delegated to another
}

// String representation of participation status
pub fn (p AttendeePartStat) str() string {
	return match p {
		.needs_action { 'NEEDS-ACTION' }
		.accepted { 'ACCEPTED' }
		.declined { 'DECLINED' }
		.tentative { 'TENTATIVE' }
		.delegated { 'DELEGATED' }
	}
}

// Parse participation status from string
pub fn parse_attendee_partstat(s string) !AttendeePartStat {
	return match s {
		'NEEDS-ACTION' { AttendeePartStat.needs_action }
		'ACCEPTED' { AttendeePartStat.accepted }
		'DECLINED' { AttendeePartStat.declined }
		'TENTATIVE' { AttendeePartStat.tentative }
		'DELEGATED' { AttendeePartStat.delegated }
		else { error('Invalid participation status: ${s}') }
	}
}

// Recurrence frequency types
pub enum RecurrenceFrequency {
	secondly
	minutely
	hourly
	daily
	weekly
	monthly
	yearly
}

// String representation of recurrence frequency
pub fn (f RecurrenceFrequency) str() string {
	return match f {
		.secondly { 'SECONDLY' }
		.minutely { 'MINUTELY' }
		.hourly { 'HOURLY' }
		.daily { 'DAILY' }
		.weekly { 'WEEKLY' }
		.monthly { 'MONTHLY' }
		.yearly { 'YEARLY' }
	}
}

// Parse recurrence frequency from string
pub fn parse_recurrence_frequency(s string) !RecurrenceFrequency {
	return match s {
		'SECONDLY' { RecurrenceFrequency.secondly }
		'MINUTELY' { RecurrenceFrequency.minutely }
		'HOURLY' { RecurrenceFrequency.hourly }
		'DAILY' { RecurrenceFrequency.daily }
		'WEEKLY' { RecurrenceFrequency.weekly }
		'MONTHLY' { RecurrenceFrequency.monthly }
		'YEARLY' { RecurrenceFrequency.yearly }
		else { error('Invalid recurrence frequency: ${s}') }
	}
}

// Alarm action types
pub enum AlarmAction {
	audio    // Play a sound
	display  // Display a message
	email    // Send an email
}

// String representation of alarm action
pub fn (a AlarmAction) str() string {
	return match a {
		.audio { 'AUDIO' }
		.display { 'DISPLAY' }
		.email { 'EMAIL' }
	}
}

// Parse alarm action from string
pub fn parse_alarm_action(s string) !AlarmAction {
	return match s {
		'AUDIO' { AlarmAction.audio }
		'DISPLAY' { AlarmAction.display }
		'EMAIL' { AlarmAction.email }
		else { error('Invalid alarm action: ${s}') }
	}
}

// Calendar component status
pub enum ComponentStatus {
	tentative   // Tentatively scheduled
	confirmed   // Confirmed
	cancelled   // Cancelled/deleted
	needs_action // Todo needs action
	completed   // Todo completed
	in_process  // Todo in progress
	draft       // Journal draft
	final       // Journal final
}

// String representation of component status
pub fn (s ComponentStatus) str() string {
	return match s {
		.tentative { 'TENTATIVE' }
		.confirmed { 'CONFIRMED' }
		.cancelled { 'CANCELLED' }
		.needs_action { 'NEEDS-ACTION' }
		.completed { 'COMPLETED' }
		.in_process { 'IN-PROCESS' }
		.draft { 'DRAFT' }
		.final { 'FINAL' }
	}
}

// Parse component status from string
pub fn parse_component_status(s string) !ComponentStatus {
	return match s {
		'TENTATIVE' { ComponentStatus.tentative }
		'CONFIRMED' { ComponentStatus.confirmed }
		'CANCELLED' { ComponentStatus.cancelled }
		'NEEDS-ACTION' { ComponentStatus.needs_action }
		'COMPLETED' { ComponentStatus.completed }
		'IN-PROCESS' { ComponentStatus.in_process }
		'DRAFT' { ComponentStatus.draft }
		'FINAL' { ComponentStatus.final }
		else { error('Invalid component status: ${s}') }
	}
}

// Calendar component class (visibility/privacy)
pub enum ComponentClass {
	public       // Visible to everyone
	private      // Only visible to owner
	confidential // Limited visibility
}

// String representation of component class
pub fn (c ComponentClass) str() string {
	return match c {
		.public { 'PUBLIC' }
		.private { 'PRIVATE' }
		.confidential { 'CONFIDENTIAL' }
	}
}

// Parse component class from string
pub fn parse_component_class(s string) !ComponentClass {
	return match s {
		'PUBLIC' { ComponentClass.public }
		'PRIVATE' { ComponentClass.private }
		'CONFIDENTIAL' { ComponentClass.confidential }
		else { error('Invalid component class: ${s}') }
	}
}

// Event transparency (busy time)
pub enum EventTransp {
	opaque       // Blocks time (shows as busy)
	transparent  // Does not block time (shows as free)
}

// String representation of event transparency
pub fn (t EventTransp) str() string {
	return match t {
		.opaque { 'OPAQUE' }
		.transparent { 'TRANSPARENT' }
	}
}

// Parse event transparency from string
pub fn parse_event_transp(s string) !EventTransp {
	return match s {
		'OPAQUE' { EventTransp.opaque }
		'TRANSPARENT' { EventTransp.transparent }
		else { error('Invalid event transparency: ${s}') }
	}
}
