module heroprompt

import rand

// HeropromptSession manages multiple workspaces for organizing AI prompts
pub struct HeropromptSession {
pub mut:
	id         string                 // Unique session identifier
	workspaces []&HeropromptWorkspace // List of workspaces in this session
}

// new_session creates a new heroprompt session with a unique ID
pub fn new_session() HeropromptSession {
	return HeropromptSession{
		id:         rand.uuid_v4()
		workspaces: []
	}
}

// add_workspace creates and adds a new workspace to the session
pub fn (mut self HeropromptSession) add_workspace(args_ NewWorkspaceParams) !&HeropromptWorkspace {
	mut wsp := &HeropromptWorkspace{}
	wsp = wsp.new(args_)!
	self.workspaces << wsp
	return wsp
}
