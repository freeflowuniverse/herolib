module actionprocessor


import freeflowuniverse.herolib.circles.core.db
import freeflowuniverse.herolib.circles.mcc.db
import freeflowuniverse.herolib.circles.actions.db
import freeflowuniverse.herolib.circles.models
import freeflowuniverse.herolib.core.texttools

__global (
	circle_global  map[string]&CircleCoordinator
	circle_default string
)


// HeroRunner is the main factory for managing jobs, agents, services, circles and names
@[heap]
pub struct CircleCoordinator {
pub mut:
	name string //is a unique name on planetary scale is a dns name
	agents   &db.AgentDB
	circles  &db.CircleDB
	names    &db.NameDB
	mails    &db.MailDB
	calendar &db.CalendarDB
	jobs     &db.JobDB
	session_state 	 models.SessionState
}


@[params]
pub struct CircleCoordinatorArgs{
pub mut:
	name string	= "local"
	pubkey        string   // pubkey of user who called this
	addr string //mycelium address
	path string
}

// new creates a new CircleCoordinator instance
pub fn new(args_ CircleCoordinatorArgs) !&CircleCoordinator {
	mut args:=args_	
	args.name = texttools.name_fix(args.name)

	if args.name in circle_global {
		mut c:=circle_global[args.name] or {panic("bug")}
		return c
	}

	mut session_state:=models.new_session(name: args.name, pubkey: args.pubkey, addr: args.addr, path: args.path)!

	// os.mkdir_all(mypath)!
	// Create the directories if they don't exist// SHOULD BE AUTOMATIC
	// os.mkdir_all(os.join_path(mypath, 'data_core'))!
	// os.mkdir_all(os.join_path(mypath, 'data_mcc'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_core'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_mcc'))! //message, contacts, calendar


	// Initialize the db handlers with proper ourdb instances
	mut agent_db := core.new_agentdb(session_state)!
	mut circle_db := core.new_circledb(session_state)!
	mut name_db := core.new_namedb(session_state)!
	mut mail_db := mcc.new_maildb(session_state)!
	mut calendar_db := mcc.new_calendardb(session_state)!
	mut job_db := actions.new_jobdb(session_state)!

	mut cm := &CircleCoordinator{
		agents:   &agent_db
		circles:  &circle_db
		names:    &name_db
		mails:    &mail_db
		calendar: &calendar_db
		jobs:     &job_db
		session_state: session_state
	}

	circle_global[args.name] = cm

	return cm
}
