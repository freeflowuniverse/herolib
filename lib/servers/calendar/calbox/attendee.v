module calbox

// Represents a calendar attendee
@[heap]
pub struct Attendee {
pub mut:
	email          string
	name           string
	role           AttendeeRole
	partstat       AttendeePartStat
	rsvp           bool
	delegated_to   []string
	delegated_from []string
}

// Attendee role types
pub enum AttendeeRole {
	chair           // Meeting chair/organizer
	req_participant // Required participant
	opt_participant // Optional participant
	non_participant // Non-participant (e.g. room, resource)
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
	needs_action // No response yet
	accepted     // Accepted invitation
	declined     // Declined invitation
	tentative    // Tentatively accepted
	delegated    // Delegated to another
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
