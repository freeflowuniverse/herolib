module calbox

// Base calendar component fields
@[heap]
pub struct CalendarComponent {
pub mut:
	uid         string
	etag        string // Entity tag for change tracking
	created     i64    // Creation timestamp
	modified    i64    // Last modified timestamp
	summary     string
	description string
	categories  []string
	status      ComponentStatus
	class       ComponentClass
	url         string
	location    string
	geo         ?GeoLocation
	alarms      []Alarm
}

// Geographic location
pub struct GeoLocation {
pub mut:
	latitude  f64
	longitude f64
}

// Calendar component status
pub enum ComponentStatus {
	tentative    // Tentatively scheduled
	confirmed    // Confirmed
	cancelled    // Cancelled/deleted
	needs_action // Todo needs action
	completed    // Todo completed
	in_process   // Todo in progress
	draft        // Journal draft
	final        // Journal final
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
