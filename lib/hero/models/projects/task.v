module projects

import freeflowuniverse.herolib.hero.models.core

// TaskStatus defines the possible states of a task
pub enum TaskStatus {
	todo
	in_progress
	in_review
	done
	blocked
	backlog
}

// TaskPriority defines the priority levels for tasks
pub enum TaskPriority {
	low
	medium
	high
	urgent
}

// Task represents the most granular unit of work
// Tasks can be linked to projects, epics, and sprints
pub struct Task {
	core.Base
pub mut:
	title               string @[index]         // Task title
	description         string                // Task description
	status              TaskStatus @[index]   // Current task status
	priority            TaskPriority @[index]  // Task priority level
	assignee_id         u64   @[index]         // User ID of task assignee
	reporter_id         u64   @[index]         // User ID of task reporter
	parent_task_id      u64                   // For subtasks - parent task ID
	epic_id             u64   @[index]         // Link to parent epic
	sprint_id           u64   @[index]         // Link to parent sprint
	project_id          u64   @[index]         // Link to parent project
	due_date              u64                   // Task due timestamp (Unix)
	estimated_time_hours f32                 // Estimated hours to complete
	logged_time_hours     f32                 // Actual hours logged
	tags                  []string @[index]      // Task tags for categorization
}