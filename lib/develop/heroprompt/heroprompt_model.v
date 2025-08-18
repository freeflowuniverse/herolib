module heroprompt

import freeflowuniverse.herolib.data.encoderhero
import time

pub const version = '0.0.0'
const singleton = false
const default = true

// Workspace represents a workspace containing multiple directories
// and their selected files for AI prompt generation
@[heap]
pub struct Workspace {
pub mut:
	name      string = 'default' // Workspace name
	base_path string            // Base path of the workspace
	children  []HeropromptChild // List of directories and files in this workspace
	created   time.Time         // Time of creation
	updated   time.Time         // Time of last update
	is_saved  bool
}

// your checking & initialization code if needed
fn obj_init(mycfg_ Workspace) !Workspace {
	return mycfg_
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_loads(heroscript string) !Workspace {
	// TODO: go from heroscript to object
	//load playbook, and manually get the params out of the actions & fill in the object
	$dbg;
	return obj
}
