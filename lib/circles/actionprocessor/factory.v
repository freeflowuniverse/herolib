module actionprocessor


import freeflowuniverse.herolib.circles.models.core
import freeflowuniverse.herolib.circles.models
import freeflowuniverse.herolib.core.texttools
import os

__global (
	circle_global  map[string]&CircleCoordinator
	circle_default string
)


// HeroRunner is the main factory for managing jobs, agents, services, circles and names
@[heap]
pub struct CircleCoordinator {
pub mut:
	name string //is a unique name on planetary scale is a dns name
	agents   &core.AgentManager
	circles  &core.CircleManager
	names    &core.NameManager
	session_state 	 model.SessionState
}


@[params]
pub struct CircleCoordinatorArgs{
pub mut:
	name string	= "local"
	pubkey        string   // pubkey of user who called this
	addr string //mycelium address	
}

// new creates a new CircleCoordinator instance
pub fn new(args_ CircleCoordinatorArgs) !&CircleCoordinator {
	mut args:=args_	
	args.name = texttools.name_fix(args.name)

	if args.name in circle_global {
		mut c:=circle_global[args.name]
		c.args = args
		return c
	}

	mut session_state:=models.new(name: args.name, pubkey: args.pubkey, addr: args.addr, path: args.path)!

	// os.mkdir_all(mypath)!
	// Create the directories if they don't exist// SHOULD BE AUTOMATIC
	// os.mkdir_all(os.join_path(mypath, 'data_core'))!
	// os.mkdir_all(os.join_path(mypath, 'data_mcc'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_core'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_mcc'))! //message, contacts, calendar


	// Initialize the managers with proper ourdb instances
	mut agent_manager := core.new_agentmanager(session_state)!
	mut circle_manager := core.new_circlemanager(session_state)!
	mut name_manager := core.new_namemanager(session_state)!

	mut cm := &CircleCoordinator{
		agents:   &agent_manager
		circles:  &circle_manager
		names:    &name_manager
		session_state: session_state
	}

	circle_global[args.name] = cm

	return cm
}
