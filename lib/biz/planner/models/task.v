module models

import time

// Task represents a work item in the system
pub struct Task {
	BaseModel
pub mut:
	title           string @[required]
	description     string
	project_id      int    // Links to Project
	sprint_id       int    // Links to Sprint (optional)
	milestone_id    int    // Links to Milestone (optional)
	parent_task_id  int    // For subtasks
	assignee_id     int    // User ID of assignee
	reporter_id     int    // User ID who created the task
	status          TaskStatus
	priority        Priority
	task_type       TaskType
	story_points    int    // For Scrum estimation
	estimated_hours f32
	actual_hours    f32
	remaining_hours f32
	start_date      time.Time
	due_date        time.Time
	completed_date  time.Time
	dependencies    []TaskDependency // Tasks this depends on
	blocked_by      []int           // Task IDs that block this task
	blocks          []int           // Task IDs that this task blocks
	subtasks        []int           // Subtask IDs
	watchers        []int           // User IDs watching this task
	time_entries    []TimeEntry
	comments        []Comment
	attachments     []Attachment
	acceptance_criteria []string
	definition_of_done  []string
	labels          []int           // Label IDs
	epic_id         int            // Links to Epic (if applicable)
	component       string         // Component/module this task relates to
	version         string         // Target version/release
	environment     string         // Environment (dev, staging, prod)
	severity        Severity       // For bug tasks
	reproducible    bool          // For bug tasks
	steps_to_reproduce []string   // For bug tasks
	expected_result string        // For bug tasks
	actual_result   string        // For bug tasks
	browser         string        // For web-related tasks
	os              string        // Operating system
	device          string        // Device type
	custom_fields   map[string]string
}

// TaskDependency represents a dependency relationship between tasks
pub struct TaskDependency {
pub mut:
	task_id           int
	depends_on_task_id int
	dependency_type   DependencyType
	created_at        time.Time
	created_by        int
}

// DependencyType for task dependencies
pub enum DependencyType {
	finish_to_start  // Task B cannot start until Task A finishes
	start_to_start   // Task B cannot start until Task A starts
	finish_to_finish // Task B cannot finish until Task A finishes
	start_to_finish  // Task B cannot finish until Task A starts
}

// Severity for bug tasks
pub enum Severity {
	trivial
	minor
	major
	critical
	blocker
}

// is_overdue checks if the task is past its due date
pub fn (t Task) is_overdue() bool {
	if t.due_date.unix == 0 || t.status in [.done, .cancelled] {
		return false
	}
	return time.now() > t.due_date
}

// is_blocked checks if the task is blocked by other tasks
pub fn (t Task) is_blocked() bool {
	return t.blocked_by.len > 0
}

// get_duration returns the planned duration in hours
pub fn (t Task) get_duration() f32 {
	if t.start_date.unix == 0 || t.due_date.unix == 0 {
		return t.estimated_hours
	}
	hours := f32((t.due_date.unix - t.start_date.unix) / 3600) // 3600 seconds in an hour
	return hours
}

// get_actual_duration returns the actual duration in hours
pub fn (t Task) get_actual_duration() f32 {
	return t.actual_hours
}

// get_progress returns the task progress as a percentage (0.0 to 1.0)
pub fn (t Task) get_progress() f32 {
	if t.estimated_hours == 0 {
		match t.status {
			.done { return 1.0 }
			.in_progress { return 0.5 }
			else { return 0.0 }
		}
	}
	
	if t.actual_hours >= t.estimated_hours {
		return 1.0
	}
	
	return t.actual_hours / t.estimated_hours
}

// get_remaining_work returns the estimated remaining work in hours
pub fn (t Task) get_remaining_work() f32 {
	if t.remaining_hours > 0 {
		return t.remaining_hours
	}
	
	if t.estimated_hours > t.actual_hours {
		return t.estimated_hours - t.actual_hours
	}
	
	return 0
}

// add_dependency adds a dependency to this task
pub fn (mut t Task) add_dependency(depends_on_task_id int, dep_type DependencyType, by_user_id int) {
	// Check if dependency already exists
	for dep in t.dependencies {
		if dep.depends_on_task_id == depends_on_task_id {
			return
		}
	}
	
	t.dependencies << TaskDependency{
		task_id: t.id
		depends_on_task_id: depends_on_task_id
		dependency_type: dep_type
		created_at: time.now()
		created_by: by_user_id
	}
	t.update_timestamp(by_user_id)
}

// remove_dependency removes a dependency from this task
pub fn (mut t Task) remove_dependency(depends_on_task_id int, by_user_id int) bool {
	for i, dep in t.dependencies {
		if dep.depends_on_task_id == depends_on_task_id {
			t.dependencies.delete(i)
			t.update_timestamp(by_user_id)
			return true
		}
	}
	return false
}

// add_blocker adds a task that blocks this task
pub fn (mut t Task) add_blocker(blocker_task_id int, by_user_id int) {
	if blocker_task_id !in t.blocked_by {
		t.blocked_by << blocker_task_id
		t.update_timestamp(by_user_id)
	}
}

// remove_blocker removes a blocking task
pub fn (mut t Task) remove_blocker(blocker_task_id int, by_user_id int) {
	t.blocked_by = t.blocked_by.filter(it != blocker_task_id)
	t.update_timestamp(by_user_id)
}

// add_subtask adds a subtask to this task
pub fn (mut t Task) add_subtask(subtask_id int, by_user_id int) {
	if subtask_id !in t.subtasks {
		t.subtasks << subtask_id
		t.update_timestamp(by_user_id)
	}
}

// remove_subtask removes a subtask from this task
pub fn (mut t Task) remove_subtask(subtask_id int, by_user_id int) {
	t.subtasks = t.subtasks.filter(it != subtask_id)
	t.update_timestamp(by_user_id)
}

// assign_to assigns the task to a user
pub fn (mut t Task) assign_to(user_id int, by_user_id int) {
	t.assignee_id = user_id
	t.update_timestamp(by_user_id)
}

// unassign removes the assignee from the task
pub fn (mut t Task) unassign(by_user_id int) {
	t.assignee_id = 0
	t.update_timestamp(by_user_id)
}

// add_watcher adds a user to watch this task
pub fn (mut t Task) add_watcher(user_id int, by_user_id int) {
	if user_id !in t.watchers {
		t.watchers << user_id
		t.update_timestamp(by_user_id)
	}
}

// remove_watcher removes a user from watching this task
pub fn (mut t Task) remove_watcher(user_id int, by_user_id int) {
	t.watchers = t.watchers.filter(it != user_id)
	t.update_timestamp(by_user_id)
}

// start_work starts work on the task
pub fn (mut t Task) start_work(by_user_id int) {
	t.status = .in_progress
	if t.start_date.unix == 0 {
		t.start_date = time.now()
	}
	t.update_timestamp(by_user_id)
}

// complete_task marks the task as completed
pub fn (mut t Task) complete_task(by_user_id int) {
	t.status = .done
	t.completed_date = time.now()
	t.remaining_hours = 0
	t.update_timestamp(by_user_id)
}

// reopen_task reopens a completed task
pub fn (mut t Task) reopen_task(by_user_id int) {
	t.status = .todo
	t.completed_date = time.Time{}
	t.update_timestamp(by_user_id)
}

// cancel_task cancels the task
pub fn (mut t Task) cancel_task(by_user_id int) {
	t.status = .cancelled
	t.update_timestamp(by_user_id)
}

// log_time adds a time entry to the task
pub fn (mut t Task) log_time(user_id int, hours f32, description string, date time.Time, by_user_id int) {
	t.time_entries << TimeEntry{
		user_id: user_id
		hours: hours
		description: description
		date: date
		created_at: time.now()
		created_by: by_user_id
	}
	t.actual_hours += hours
	t.update_timestamp(by_user_id)
}

// update_remaining_hours updates the remaining work estimate
pub fn (mut t Task) update_remaining_hours(hours f32, by_user_id int) {
	t.remaining_hours = hours
	t.update_timestamp(by_user_id)
}

// add_comment adds a comment to the task
pub fn (mut t Task) add_comment(user_id int, content string, by_user_id int) {
	t.comments << Comment{
		user_id: user_id
		content: content
		created_at: time.now()
		created_by: by_user_id
	}
	t.update_timestamp(by_user_id)
}

// add_attachment adds an attachment to the task
pub fn (mut t Task) add_attachment(filename string, file_path string, file_size int, mime_type string, by_user_id int) {
	t.attachments << Attachment{
		filename: filename
		file_path: file_path
		file_size: file_size
		mime_type: mime_type
		uploaded_at: time.now()
		uploaded_by: by_user_id
	}
	t.update_timestamp(by_user_id)
}

// add_acceptance_criteria adds acceptance criteria to the task
pub fn (mut t Task) add_acceptance_criteria(criteria string, by_user_id int) {
	t.acceptance_criteria << criteria
	t.update_timestamp(by_user_id)
}

// remove_acceptance_criteria removes acceptance criteria from the task
pub fn (mut t Task) remove_acceptance_criteria(index int, by_user_id int) {
	if index >= 0 && index < t.acceptance_criteria.len {
		t.acceptance_criteria.delete(index)
		t.update_timestamp(by_user_id)
	}
}

// set_story_points sets the story points for the task
pub fn (mut t Task) set_story_points(points int, by_user_id int) {
	t.story_points = points
	t.update_timestamp(by_user_id)
}

// set_due_date sets the due date for the task
pub fn (mut t Task) set_due_date(due_date time.Time, by_user_id int) {
	t.due_date = due_date
	t.update_timestamp(by_user_id)
}

// calculate_velocity returns the velocity (story points / actual hours)
pub fn (t Task) calculate_velocity() f32 {
	if t.actual_hours == 0 || t.story_points == 0 {
		return 0
	}
	return f32(t.story_points) / t.actual_hours
}

// is_bug checks if the task is a bug
pub fn (t Task) is_bug() bool {
	return t.task_type == .bug
}

// is_story checks if the task is a user story
pub fn (t Task) is_story() bool {
	return t.task_type == .story
}

// is_epic checks if the task is an epic
pub fn (t Task) is_epic() bool {
	return t.task_type == .epic
}

// get_age returns the age of the task in days
pub fn (t Task) get_age() int {
	return int((time.now().unix - t.created_at.unix) / 86400)
}

// get_cycle_time returns the cycle time (time from start to completion) in hours
pub fn (t Task) get_cycle_time() f32 {
	if t.start_date.unix == 0 || t.completed_date.unix == 0 {
		return 0
	}
	return f32((t.completed_date.unix - t.start_date.unix) / 3600)
}

// get_lead_time returns the lead time (time from creation to completion) in hours
pub fn (t Task) get_lead_time() f32 {
	if t.completed_date.unix == 0 {
		return 0
	}
	return f32((t.completed_date.unix - t.created_at.unix) / 3600)
}