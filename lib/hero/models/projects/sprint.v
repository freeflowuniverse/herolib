module projects

import freeflowuniverse.herolib.hero.models.core

// SprintStatus defines the possible states of a sprint
pub enum SprintStatus {
	planning
	active
	completed
	paused
}

// Sprint represents a time-boxed iteration for completing work
// Typically used in agile methodologies (e.g., two-week sprints)
pub struct Sprint {
	core.Base
pub mut:
	name        string @[index]         // Sprint name
	description string                // Sprint description
	status      SprintStatus @[index] // Current sprint status
	goal        string                // Sprint goal/objective
	project_id  u64   @[index]         // Link to parent project
	start_date  u64                   // Sprint start timestamp (Unix)
	end_date    u64                   // Sprint end timestamp (Unix)
	task_ids    []u64 @[index]         // List of task IDs in this sprint
}