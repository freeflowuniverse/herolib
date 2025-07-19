module models

import time

// Issue represents a problem, bug, or concern in the system
pub struct Issue {
	BaseModel
pub mut:
	title                  string @[required]
	description            string
	project_id             int // Links to Project
	task_id                int // Links to Task (optional)
	sprint_id              int // Links to Sprint (optional)
	reporter_id            int // User who reported the issue
	assignee_id            int // User assigned to resolve the issue
	status                 IssueStatus
	priority               Priority
	severity               Severity
	issue_type             IssueType
	category               IssueCategory
	resolution             IssueResolution
	resolution_description string
	environment            string // Environment where issue occurred
	version                string // Version where issue was found
	fixed_version          string // Version where issue was fixed
	component              string // Component/module affected
	labels                 []int  // Label IDs
	affects_versions       []string
	fix_versions           []string
	due_date               time.Time
	resolved_date          time.Time
	closed_date            time.Time
	estimated_hours        f32
	actual_hours           f32
	story_points           int   // For estimation
	watchers               []int // User IDs watching this issue
	linked_issues          []IssueLink
	duplicates             []int // Issue IDs that are duplicates of this
	duplicated_by          int   // Issue ID that this duplicates
	parent_issue_id        int   // For sub-issues
	sub_issues             []int // Sub-issue IDs
	time_entries           []TimeEntry
	comments               []Comment
	attachments            []Attachment
	workarounds            []Workaround
	test_cases             []TestCase
	steps_to_reproduce     []string
	expected_behavior      string
	actual_behavior        string
	additional_info        string
	browser                string
	operating_system       string
	device_info            string
	network_info           string
	user_agent             string
	screen_resolution      string
	logs                   []LogEntry
	stack_trace            string
	error_message          string
	frequency              IssueFrequency
	impact_users           int // Number of users affected
	business_impact        string
	technical_debt         bool // Is this technical debt?
	security_issue         bool // Is this a security issue?
	performance_issue      bool // Is this a performance issue?
	accessibility_issue    bool // Is this an accessibility issue?
	regression             bool // Is this a regression?
	custom_fields          map[string]string
}

// IssueType for categorizing issues
pub enum IssueType {
	bug
	feature_request
	improvement
	task
	epic
	story
	sub_task
	incident
	change_request
	question
	documentation
	test
}

// IssueCategory for further categorization
pub enum IssueCategory {
	frontend
	backend
	database
	api
	ui_ux
	performance
	security
	infrastructure
	deployment
	configuration
	integration
	documentation
	testing
	accessibility
	mobile
	desktop
	web
}

// IssueResolution for tracking how issues were resolved
pub enum IssueResolution {
	unresolved
	fixed
	wont_fix
	duplicate
	invalid
	works_as_designed
	cannot_reproduce
	incomplete
	moved
	deferred
}

// IssueFrequency for tracking how often an issue occurs
pub enum IssueFrequency {
	always
	often
	sometimes
	rarely
	once
	unknown
}

// IssueLink represents a relationship between issues
pub struct IssueLink {
pub mut:
	issue_id        int
	linked_issue_id int
	link_type       IssueLinkType
	created_at      time.Time
	created_by      int
	description     string
}

// IssueLinkType for different types of issue relationships
pub enum IssueLinkType {
	blocks
	blocked_by
	relates_to
	duplicates
	duplicated_by
	causes
	caused_by
	parent_of
	child_of
	depends_on
	depended_by
	follows
	followed_by
}

// Workaround represents a temporary solution for an issue
pub struct Workaround {
pub mut:
	id            int
	issue_id      int
	title         string
	description   string
	steps         []string
	effectiveness f32 // 0.0 to 1.0 scale
	complexity    WorkaroundComplexity
	temporary     bool // Is this a temporary workaround?
	created_at    time.Time
	created_by    int
	tested_by     []int // User IDs who tested this workaround
	success_rate  f32   // Success rate from testing
}

// WorkaroundComplexity for rating workaround complexity
pub enum WorkaroundComplexity {
	simple
	moderate
	complex
	expert_only
}

// TestCase represents a test case related to an issue
pub struct TestCase {
pub mut:
	id              int
	issue_id        int
	title           string
	description     string
	preconditions   []string
	steps           []string
	expected_result string
	test_data       string
	test_type       TestType
	automated       bool
	created_at      time.Time
	created_by      int
	last_executed   time.Time
	last_result     TestResult
}

// TestType for categorizing test cases
pub enum TestType {
	unit
	integration
	system
	acceptance
	regression
	performance
	security
	usability
	compatibility
}

// TestResult for test case results
pub enum TestResult {
	not_executed
	passed
	failed
	blocked
	skipped
}

// LogEntry represents a log entry related to an issue
pub struct LogEntry {
pub mut:
	timestamp       time.Time
	level           LogLevel
	message         string
	source          string
	thread          string
	user_id         int
	session_id      string
	request_id      string
	additional_data map[string]string
}

// LogLevel for log entry severity
pub enum LogLevel {
	trace
	debug
	info
	warn
	error
	fatal
}

// is_overdue checks if the issue is past its due date
pub fn (i Issue) is_overdue() bool {
	if i.due_date.unix == 0 || i.status in [.resolved, .closed, .cancelled] {
		return false
	}
	return time.now() > i.due_date
}

// is_open checks if the issue is in an open state
pub fn (i Issue) is_open() bool {
	return i.status !in [.resolved, .closed, .cancelled]
}

// is_critical checks if the issue is critical
pub fn (i Issue) is_critical() bool {
	return i.priority == .critical || i.severity == .blocker
}

// get_age returns the age of the issue in days
pub fn (i Issue) get_age() int {
	return int((time.now().unix - i.created_at.unix) / 86400)
}

// get_resolution_time returns the time to resolve in hours
pub fn (i Issue) get_resolution_time() f32 {
	if i.resolved_date.unix == 0 {
		return 0
	}
	return f32((i.resolved_date.unix - i.created_at.unix) / 3600)
}

// get_time_to_close returns the time to close in hours
pub fn (i Issue) get_time_to_close() f32 {
	if i.closed_date.unix == 0 {
		return 0
	}
	return f32((i.closed_date.unix - i.created_at.unix) / 3600)
}

// assign_to assigns the issue to a user
pub fn (mut i Issue) assign_to(user_id int, by_user_id int) {
	i.assignee_id = user_id
	i.update_timestamp(by_user_id)
}

// unassign removes the assignee from the issue
pub fn (mut i Issue) unassign(by_user_id int) {
	i.assignee_id = 0
	i.update_timestamp(by_user_id)
}

// add_watcher adds a user to watch this issue
pub fn (mut i Issue) add_watcher(user_id int, by_user_id int) {
	if user_id !in i.watchers {
		i.watchers << user_id
		i.update_timestamp(by_user_id)
	}
}

// remove_watcher removes a user from watching this issue
pub fn (mut i Issue) remove_watcher(user_id int, by_user_id int) {
	i.watchers = i.watchers.filter(it != user_id)
	i.update_timestamp(by_user_id)
}

// start_work starts work on the issue
pub fn (mut i Issue) start_work(by_user_id int) {
	i.status = .in_progress
	i.update_timestamp(by_user_id)
}

// resolve_issue resolves the issue
pub fn (mut i Issue) resolve_issue(resolution IssueResolution, resolution_description string, fixed_version string, by_user_id int) {
	i.status = .resolved
	i.resolution = resolution
	i.resolution_description = resolution_description
	i.fixed_version = fixed_version
	i.resolved_date = time.now()
	i.update_timestamp(by_user_id)
}

// close_issue closes the issue
pub fn (mut i Issue) close_issue(by_user_id int) {
	i.status = .closed
	i.closed_date = time.now()
	i.update_timestamp(by_user_id)
}

// reopen_issue reopens a resolved/closed issue
pub fn (mut i Issue) reopen_issue(by_user_id int) {
	i.status = .open
	i.resolution = .unresolved
	i.resolution_description = ''
	i.resolved_date = time.Time{}
	i.closed_date = time.Time{}
	i.update_timestamp(by_user_id)
}

// cancel_issue cancels the issue
pub fn (mut i Issue) cancel_issue(by_user_id int) {
	i.status = .cancelled
	i.update_timestamp(by_user_id)
}

// add_link adds a link to another issue
pub fn (mut i Issue) add_link(linked_issue_id int, link_type IssueLinkType, description string, by_user_id int) {
	// Check if link already exists
	for link in i.linked_issues {
		if link.linked_issue_id == linked_issue_id && link.link_type == link_type {
			return
		}
	}

	i.linked_issues << IssueLink{
		issue_id:        i.id
		linked_issue_id: linked_issue_id
		link_type:       link_type
		description:     description
		created_at:      time.now()
		created_by:      by_user_id
	}
	i.update_timestamp(by_user_id)
}

// remove_link removes a link to another issue
pub fn (mut i Issue) remove_link(linked_issue_id int, link_type IssueLinkType, by_user_id int) {
	for idx, link in i.linked_issues {
		if link.linked_issue_id == linked_issue_id && link.link_type == link_type {
			i.linked_issues.delete(idx)
			i.update_timestamp(by_user_id)
			return
		}
	}
}

// mark_as_duplicate marks this issue as a duplicate of another
pub fn (mut i Issue) mark_as_duplicate(original_issue_id int, by_user_id int) {
	i.duplicated_by = original_issue_id
	i.resolution = .duplicate
	i.status = .resolved
	i.resolved_date = time.now()
	i.update_timestamp(by_user_id)
}

// add_duplicate adds an issue as a duplicate of this one
pub fn (mut i Issue) add_duplicate(duplicate_issue_id int, by_user_id int) {
	if duplicate_issue_id !in i.duplicates {
		i.duplicates << duplicate_issue_id
		i.update_timestamp(by_user_id)
	}
}

// log_time adds a time entry to the issue
pub fn (mut i Issue) log_time(user_id int, hours f32, description string, date time.Time, by_user_id int) {
	i.time_entries << TimeEntry{
		user_id:     user_id
		hours:       hours
		description: description
		date:        date
		created_at:  time.now()
		created_by:  by_user_id
	}
	i.actual_hours += hours
	i.update_timestamp(by_user_id)
}

// add_comment adds a comment to the issue
pub fn (mut i Issue) add_comment(user_id int, content string, by_user_id int) {
	i.comments << Comment{
		user_id:    user_id
		content:    content
		created_at: time.now()
		created_by: by_user_id
	}
	i.update_timestamp(by_user_id)
}

// add_attachment adds an attachment to the issue
pub fn (mut i Issue) add_attachment(filename string, file_path string, file_size int, mime_type string, by_user_id int) {
	i.attachments << Attachment{
		filename:    filename
		file_path:   file_path
		file_size:   file_size
		mime_type:   mime_type
		uploaded_at: time.now()
		uploaded_by: by_user_id
	}
	i.update_timestamp(by_user_id)
}

// add_workaround adds a workaround for the issue
pub fn (mut i Issue) add_workaround(title string, description string, steps []string, effectiveness f32, complexity WorkaroundComplexity, temporary bool, by_user_id int) {
	i.workarounds << Workaround{
		id:            i.workarounds.len + 1
		issue_id:      i.id
		title:         title
		description:   description
		steps:         steps
		effectiveness: effectiveness
		complexity:    complexity
		temporary:     temporary
		created_at:    time.now()
		created_by:    by_user_id
	}
	i.update_timestamp(by_user_id)
}

// add_test_case adds a test case for the issue
pub fn (mut i Issue) add_test_case(title string, description string, preconditions []string, steps []string, expected_result string, test_type TestType, automated bool, by_user_id int) {
	i.test_cases << TestCase{
		id:              i.test_cases.len + 1
		issue_id:        i.id
		title:           title
		description:     description
		preconditions:   preconditions
		steps:           steps
		expected_result: expected_result
		test_type:       test_type
		automated:       automated
		created_at:      time.now()
		created_by:      by_user_id
	}
	i.update_timestamp(by_user_id)
}

// add_log_entry adds a log entry to the issue
pub fn (mut i Issue) add_log_entry(timestamp time.Time, level LogLevel, message string, source string, thread string, user_id int, session_id string, request_id string, additional_data map[string]string) {
	i.logs << LogEntry{
		timestamp:       timestamp
		level:           level
		message:         message
		source:          source
		thread:          thread
		user_id:         user_id
		session_id:      session_id
		request_id:      request_id
		additional_data: additional_data
	}
}

// set_due_date sets the due date for the issue
pub fn (mut i Issue) set_due_date(due_date time.Time, by_user_id int) {
	i.due_date = due_date
	i.update_timestamp(by_user_id)
}

// escalate escalates the issue priority
pub fn (mut i Issue) escalate(new_priority Priority, by_user_id int) {
	i.priority = new_priority
	i.update_timestamp(by_user_id)
}

// calculate_priority_score calculates a priority score based on various factors
pub fn (i Issue) calculate_priority_score() f32 {
	mut score := f32(0)

	// Base priority score
	match i.priority {
		.critical { score += 100 }
		.high { score += 75 }
		.medium { score += 50 }
		.low { score += 25 }
	}

	// Severity modifier
	match i.severity {
		.blocker { score += 50 }
		.critical { score += 40 }
		.major { score += 30 }
		.minor { score += 10 }
		.trivial { score += 0 }
	}

	// Age factor (older issues get higher priority)
	age := i.get_age()
	if age > 30 {
		score += 20
	} else if age > 14 {
		score += 10
	} else if age > 7 {
		score += 5
	}

	// User impact factor
	if i.impact_users > 1000 {
		score += 30
	} else if i.impact_users > 100 {
		score += 20
	} else if i.impact_users > 10 {
		score += 10
	}

	// Special issue type modifiers
	if i.security_issue {
		score += 25
	}
	if i.performance_issue {
		score += 15
	}
	if i.regression {
		score += 20
	}

	return score
}

// get_sla_status returns SLA compliance status
pub fn (i Issue) get_sla_status() string {
	age := i.get_age()

	// Define SLA based on priority
	mut sla_days := 0
	match i.priority {
		.critical { sla_days = 1 }
		.high { sla_days = 3 }
		.medium { sla_days = 7 }
		.low { sla_days = 14 }
	}

	if i.status in [.resolved, .closed] {
		resolution_days := int(i.get_resolution_time() / 24)
		if resolution_days <= sla_days {
			return 'Met'
		} else {
			return 'Missed'
		}
	} else {
		if age <= sla_days {
			return 'On Track'
		} else {
			return 'Breached'
		}
	}
}
