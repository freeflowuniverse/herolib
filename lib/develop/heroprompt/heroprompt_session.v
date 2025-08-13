module heroprompt

import rand

pub struct HeropromptSession {
pub mut:
	id         string
	workspaces []&HeropromptWorkspace
}

pub fn new_session() HeropromptSession {
	return HeropromptSession{
		id:         rand.uuid_v4()
		workspaces: []
	}
}

pub fn (mut self HeropromptSession) add_workspace(args_ NewWorkspaceParams) !&HeropromptWorkspace {
	mut wsp := &HeropromptWorkspace{}
	wsp = wsp.new(args_)!
	self.workspaces << wsp
	return wsp
}
