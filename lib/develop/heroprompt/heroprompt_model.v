module heroprompt

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import os

pub const version = '0.0.0'
const singleton = false
const default = true

/
// Workspace represents a workspace containing multiple directories
// and their selected files for AI prompt generation
@[heap]
pub struct Workspace {
pub mut:
	name      string = 'default' // Workspace name
	base_path string             // Base path of the workspace
	children  []HeropromptChild  // List of directories and files in this workspace
}


// your checking & initialization code if needed
fn obj_init(mycfg_ Workspace) !Workspace {
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_loads(heroscript string) !Workspace {
	mut obj := encoderhero.decode[Workspace](heroscript)!
	return obj
}
