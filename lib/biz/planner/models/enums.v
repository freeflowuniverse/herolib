module models

// Priority levels used across tasks, issues, and projects
pub enum Priority {
	lowest
	low
	medium
	high
	highest
}

// Status for projects
pub enum ProjectStatus {
	planning
	active
	on_hold
	completed
	cancelled
}

// Status for tasks
pub enum TaskStatus {
	todo
	in_progress
	in_review
	testing
	done
	blocked
}

// Task types for different kinds of work items
pub enum TaskType {
	story
	bug
	epic
	spike
	task
	feature
}

// Issue status for problem tracking
pub enum IssueStatus {
	open
	in_progress
	resolved
	closed
	reopened
}

// Issue severity levels
pub enum IssueSeverity {
	low
	medium
	high
	critical
}

// Issue types
pub enum IssueType {
	bug
	feature_request
	improvement
	question
	documentation
	support
}

// Sprint status for Scrum methodology
pub enum SprintStatus {
	planning
	active
	completed
	cancelled
}

// Milestone status
pub enum MilestoneStatus {
	not_started
	in_progress
	completed
	overdue
}

// Condition status for milestone requirements
pub enum ConditionStatus {
	pending
	in_progress
	verified
	failed
}

// Customer types for CRM
pub enum CustomerType {
	individual
	company
	government
	nonprofit
	partner
}

// Customer status in the sales pipeline
pub enum CustomerStatus {
	prospect
	lead
	qualified
	active
	inactive
	archived
}

// User roles in the system
pub enum UserRole {
	admin
	project_manager
	developer
	designer
	tester
	analyst
	client
	viewer
}

// User status
pub enum UserStatus {
	active
	inactive
	suspended
	pending
}

// Agenda/Calendar event types
pub enum AgendaType {
	meeting
	deadline
	milestone
	personal
	project_review
	sprint_planning
	retrospective
	standup
}

// Agenda status
pub enum AgendaStatus {
	scheduled
	in_progress
	completed
	cancelled
	postponed
}

// Chat types
pub enum ChatType {
	direct
	group
	project
	team
	support
}

// Message types in chat
pub enum MessageType {
	text
	file
	image
	system
	notification
	mention
}

// Address types
pub enum AddressType {
	billing
	shipping
	office
	home
	other
}

// Contact types
pub enum ContactType {
	primary
	technical
	billing
	support
	other
}

// Time entry types
pub enum TimeEntryType {
	development
	testing
	meeting
	documentation
	support
	training
	other
}