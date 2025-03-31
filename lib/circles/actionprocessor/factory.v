module actionprocessor

import freeflowuniverse.herolib.circles.core.db as core_db
import freeflowuniverse.herolib.circles.mcc.db as mcc_db
import freeflowuniverse.herolib.circles.actions.db as actions_db
import freeflowuniverse.herolib.circles.base { SessionState }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.redisclient

__global (
	circle_global  map[string]&CircleCoordinator
	circle_default string
	action_queues map[string]&ActionQueue
)

// HeroRunner is the main factory for managing jobs, agents, services, circles and names
@[heap]
pub struct CircleCoordinator {
pub mut:
	name          string // is a unique name on planetary scale is a dns name
	agents        &core_db.AgentDB
	circles       &core_db.CircleDB
	names         &core_db.NameDB
	mails         &mcc_db.MailDB
	calendar      &mcc_db.CalendarDB
	jobs          &actions_db.JobDB
	action_queues map[string]&ActionQueue
	session_state SessionState
}

@[params]
pub struct CircleCoordinatorArgs {
pub mut:
	name   string = 'local'
	pubkey string // pubkey of user who called this
	addr   string // mycelium address
	path   string
}

// new creates a new CircleCoordinator instance
pub fn new(args_ CircleCoordinatorArgs) !&CircleCoordinator {
	mut args := args_
	args.name = texttools.name_fix(args.name)

	if args.name in circle_global {
		mut c := circle_global[args.name] or { panic('bug') }
		return c
	}

	mut session_state := base.new_session(base.StateArgs{
		name:   args.name
		pubkey: args.pubkey
		addr:   args.addr
		path:   args.path
	})!

	// os.mkdir_all(mypath)!
	// Create the directories if they don't exist// SHOULD BE AUTOMATIC
	// os.mkdir_all(os.join_path(mypath, 'data_core'))!
	// os.mkdir_all(os.join_path(mypath, 'data_mcc'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_core'))!
	// os.mkdir_all(os.join_path(mypath, 'meta_mcc'))! //message, contacts, calendar

	// Initialize the db handlers with proper ourdb instances
	mut agent_db := core_db.new_agentdb(session_state) or {
		return error('Failed to initialize agent_db: ${err}')
	}
	mut circle_db := core_db.new_circledb(session_state) or {
		return error('Failed to initialize circle_db: ${err}')
	}
	mut name_db := core_db.new_namedb(session_state) or {
		return error('Failed to initialize name_db: ${err}')
	}
	mut mail_db := mcc_db.new_maildb(session_state) or {
		return error('Failed to initialize mail_db: ${err}')
	}
	mut calendar_db := mcc_db.new_calendardb(session_state) or {
		return error('Failed to initialize calendar_db: ${err}')
	}
	mut job_db := actions_db.new_jobdb(session_state) or {
		return error('Failed to initialize job_db: ${err}')
	}

	mut cm := &CircleCoordinator{
		agents:        &agent_db
		circles:       &circle_db
		names:         &name_db
		mails:         &mail_db
		calendar:      &calendar_db
		jobs:          &job_db
		action_queues: map[string]&ActionQueue{}
		session_state: session_state
	}

	circle_global[args.name] = cm

	return cm
}

// ActionQueueArgs defines the parameters for creating a new ActionQueue
@[params]
pub struct ActionQueueArgs {
pub mut:
	name string = 'default' // Name of the queue
	redis_addr string // Redis server address, defaults to 'localhost:6379'
}

// new_action_queue creates a new ActionQueue
pub fn new_action_queue(args ActionQueueArgs) !&ActionQueue {
	// Normalize the queue name
	queue_name := texttools.name_fix(args.name)
	
	// Check if queue already exists in global map
	if queue_name in action_queues {
		mut q := action_queues[queue_name] or { panic('bug') }
		return q
	}
	
	// Set default Redis address if not provided
	mut redis_addr := args.redis_addr
	if redis_addr == '' {
		redis_addr = 'localhost:6379'
	}
	
	// Create Redis client
	mut redis := redisclient.new(redis_addr)!
	
	// Create Redis queue
	queue_key := 'actionqueue:${queue_name}'
	mut redis_queue := redis.queue_get(queue_key)
	
	// Create ActionQueue
	mut action_queue := &ActionQueue{
		name: queue_name
		queue: &redis_queue
		redis: redis
	}
	
	// Store in global map
	action_queues[queue_name] = action_queue
	
	return action_queue
}

// get_action_queue retrieves an existing ActionQueue or creates a new one
pub fn get_action_queue(name string) !&ActionQueue {
	queue_name := texttools.name_fix(name)
	
	if queue_name in action_queues {
		mut q := action_queues[queue_name] or { panic('bug') }
		return q
	}
	
	return new_action_queue(ActionQueueArgs{
		name: queue_name
	})!
}

// get_or_create_action_queue retrieves an existing ActionQueue for a CircleCoordinator or creates a new one
pub fn (mut cc CircleCoordinator) get_or_create_action_queue(name string) !&ActionQueue {
	queue_name := texttools.name_fix(name)
	
	if queue_name in cc.action_queues {
		mut q := cc.action_queues[queue_name] or { panic('bug') }
		return q
	}
	
	mut action_queue := new_action_queue(ActionQueueArgs{
		name: queue_name
	})!
	
	cc.action_queues[queue_name] = action_queue
	
	return action_queue
}
