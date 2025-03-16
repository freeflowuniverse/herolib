module actionprocessor


import freeflowuniverse.herolib.circles.core.db as core_db
import freeflowuniverse.herolib.circles.mcc.db as mcc_db
import freeflowuniverse.herolib.circles.actions.db as actions_db
import freeflowuniverse.herolib.circles.base { SessionState }
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
	agents   &core_db.AgentDB
	circles  &core_db.CircleDB
	names    &core_db.NameDB
	mails    &mcc_db.MailDB
	calendar &mcc_db.CalendarDB
	jobs     &actions_db.JobDB
	session_state 	 SessionState
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

	mut session_state := base.new_session(base.StateArgs{
		name: args.name
		pubkey: args.pubkey
		addr: args.addr
		path: args.path
	})!

	// os.mkdir_all(mypath)!
	// Create the directories if they don't exist// SHOULD BE AUTOMATIC
	// os.mkdir_all(os.join_path(mypath, 'data_core'))!
	// os.mkdir_all(os.join_path(mypath, 'data_mcc'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_core'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_mcc'))! //message, contacts, calendar


	// Initialize the db handlers with proper ourdb instances
	mut agent_db := core_db.new_agentdb(session_state) or { return error('Failed to initialize agent_db: ${err}') }
	mut circle_db := core_db.new_circledb(session_state) or { return error('Failed to initialize circle_db: ${err}') }
	mut name_db := core_db.new_namedb(session_state) or { return error('Failed to initialize name_db: ${err}') }
	mut mail_db := mcc_db.new_maildb(session_state) or { return error('Failed to initialize mail_db: ${err}') }
	mut calendar_db := mcc_db.new_calendardb(session_state) or { return error('Failed to initialize calendar_db: ${err}') }
	mut job_db := actions_db.new_jobdb(session_state) or { return error('Failed to initialize job_db: ${err}') }

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
