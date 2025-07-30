module projects

import freeflowuniverse.herolib.hero.models.core

// Priority levels for project items
pub enum Priority {
	critical
	high
	medium
	low
	none
}

// Status values for project lifecycle
pub enum Status {
	todo
	in_progress
	review
	done
	archived
}

// Types of items in the project hierarchy
pub enum ItemType {
	epic
	story
	task
	bug
	improvement
	feature
}

// Project represents a high-level container for organizing work
// A Project holds information about its members and contains lists of associated epics, sprints, and boards
pub struct Project {
	core.Base
pub mut:
	name         string @[index]        // Project name
	description string                // Detailed project description
	owner_id    u64   @[index]        // User ID of the project owner
	member_ids  []u64 @[index]        // List of user IDs who are members
	board_ids   []u64                 // List of associated board IDs
	sprint_ids  []u64 @[index]        // List of sprint IDs in this project
	epic_ids    []u64 @[index]        // List of epic IDs in this project
	tags        []string @[index]      // Project tags for categorization
	status      Status @[index]       // Current project status
	priority    Priority @[index]     // Project priority level
	item_type   ItemType @[index]     // Type of project item
}

// Label represents a tag with name and color for categorization
pub struct Label {
	core.Base
pub mut:
	name  string @[index]  // Label name
	color string @[index]  // Hex color code for the label
}