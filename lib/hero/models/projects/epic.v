module projects

import freeflowuniverse.herolib.hero.models.core

// Epic represents a large body of work or major feature
// An Epic is broken down into smaller tasks and can be associated with a project
pub struct Epic {
	core.Base
pub mut:
	name            string @[index]         // Epic name
	description     string                // Detailed epic description
	status          Status @[index]        // Current epic status
	project_id      u64   @[index]         // Link to parent project
	start_date      u64                   // Epic start timestamp (Unix)
	due_date        u64                   // Epic due timestamp (Unix)
	tags            []string @[index]       // Epic tags for categorization
	child_task_ids  []u64 @[index]         // List of task IDs belonging to this epic
}