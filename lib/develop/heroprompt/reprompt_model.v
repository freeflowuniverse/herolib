module heroprompt

import freeflowuniverse.herolib.data.encoderhero

pub const version = '0.0.0'
const singleton = false
const default = true

// HeropromptWorkspace represents a workspace containing multiple directories
// and their selected files for AI prompt generation
@[heap]
pub struct HeropromptWorkspace {
pub mut:
	name      string = 'default' // Workspace name
	base_path string           // Base path of the workspace
	dirs      []&HeropromptDir // List of directories in this workspace
}

@[params]
pub struct AddWorkspaceParams {
pub mut:
	name string
	path string
}

// add_workspace creates and adds a new workspace
pub fn new_workspace(args_ AddWorkspaceParams) !&HeropromptWorkspace {
	mut wsp := &HeropromptWorkspace{}
	wsp = wsp.new(name: args_.name, path: args_.path)!
	return wsp
}

// get_workspace gets the saved workspace
pub fn get_workspace(args_ AddWorkspaceParams) !&HeropromptWorkspace {
	if args_.name.len == 0 {
		return error('Workspace name is required')
	}

	return get(name: args_.name)!
}

// your checking & initialization code if needed
fn obj_init(mycfg_ HeropromptWorkspace) !HeropromptWorkspace {
	mut mycfg := mycfg_
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj HeropromptWorkspace) !string {
	return encoderhero.encode[HeropromptWorkspace](obj)!
}

pub fn heroscript_loads(heroscript string) !HeropromptWorkspace {
	mut obj := encoderhero.decode[HeropromptWorkspace](heroscript)!
	return obj
}
