module gov

pub enum CompanyStatus {
	active
	inactive
	dissolved
	suspended
	pending
}

pub enum ShareholderType {
	individual
	corporate
	trust
	partnership
	government
	other
}

pub enum CommitteeRole {
	chair
	vice_chair
	secretary
	treasurer
	member
	observer
	advisor
}

pub enum MeetingStatus {
	scheduled
	in_progress
	completed
	cancelled
}

pub enum MeetingType {
	board_meeting
	committee_meeting
	general_assembly
	annual_general_meeting
	extraordinary_general_meeting
	other
}

pub enum AttendanceStatus {
	invited
	confirmed
	declined
	attended
	absent
}

pub enum ResolutionStatus {
	draft
	proposed
	approved
	rejected
	expired
}

pub enum ResolutionType {
	ordinary
	special
	unanimous
	written
	other
}

pub enum VoteStatus {
	draft
	open
	closed
	cancelled
}

pub enum VoteOption {
	yes
	no
	abstain
	custom
}