module play

import freeflowuniverse.herolib.core.playbook
import freeflowuniverse.herolib.circles.base { Databases, SessionState, new_session }
import freeflowuniverse.herolib.circles.actions.db { JobDB, new_jobdb }
import os

// ReturnFormat defines the format for returning results
pub enum ReturnFormat {
	heroscript
	json
}

// Player is the main struct for processing heroscript actions
@[heap]
pub struct Player {
pub mut:
	actor string        // The name of the actor as used in heroscript
	return_format ReturnFormat // Format for returning results
	session_state SessionState // Session state for database operations
	job_db JobDB        // Job database handler
}

// new_player creates a new Player instance
pub fn new_player(actor string, return_format ReturnFormat) !Player {
	// Initialize session state
	mut session_state := new_session(
		name: 'circles'
		path: os.join_path(os.home_dir(), '.herolib', 'circles')
	)!

	// Create a new job database
	mut job_db := new_jobdb(session_state)!

	return Player{
		actor: actor
		return_format: return_format
		session_state: session_state
		job_db: job_db
	}
}

// play processes a heroscript text or playbook
pub fn (mut p Player) play(input string, is_text bool) ! {
	mut plbook := if is_text {
		playbook.new(text: input)!
	} else {
		playbook.new(path: input)!
	}

	// Find all actions for this actor
	filter := '${p.actor}.'
	actions := plbook.find(filter: filter)!
	
	if actions.len == 0 {
		println('No actions found for actor: ${p.actor}')
		return
	}

	// Process each action
	for action in actions {
		action_name := action.name.split('.')[1]
		
		// Call the appropriate method based on the action name
		match action_name {
			'create' { p.create(action.params)! }
			'get' { p.get(action.params)! }
			'delete' { p.delete(action.params)! }
			'update_status' { p.update_status(action.params)! }
			'list' { p.list(action.params)! }
			else { println('Unknown action: ${action_name}') }
		}
	}
}

// create method is implemented in create.v

// get method is implemented in get.v

// delete method is implemented in delete.v

// update_status method is implemented in update_status.v

// list method is implemented in list.v
