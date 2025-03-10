module model

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import os

// HeroRunner is the main factory for managing jobs, agents, services, circles and names
@[heap]
pub struct HeroRunner {
pub mut:
	agents   &AgentManager
	circles  &CircleManager
	names    &NameManager
	// jobs     &JobManager
	// services &ServiceManager
}

@[params]
pub struct HeroRunnerArgs{
pub mut:
	path string	
}

// new creates a new HeroRunner instance
pub fn new(args_ HeroRunnerArgs) !&HeroRunner {
	mut args:=args_

	// Set up the VFS for job storage
	if args.path.len == 0{
	 	args.path = os.join_path(os.home_dir(), '.hero', 'jobs')
	}
	os.mkdir_all(args.path)!

	// Create the directories if they don't exist
	os.mkdir_all(os.join_path(args.path, 'data'))!
	os.mkdir_all(os.join_path(args.path, 'meta'))!

	println(1)
	// Create the data database (non-incremental mode for custom IDs)
	mut db_data := ourdb.new(
		path: os.join_path(args.path, 'data')
		incremental_mode: false // Using auto-increment for IDs
	)!
	println(2)

	// Create the metadata radix tree for key-to-id mapping
	mut db_meta := radixtree.new(
		path: os.join_path(args.path, 'meta')
	)!

	// Initialize the managers with proper ourdb instances
	mut agent_manager := new_agentmanager(db_data, db_meta)
	mut circle_manager := new_circlemanager(db_data, db_meta)
	mut name_manager := new_namemanager(db_data, db_meta)
	// mut job_manager := &JobManager{db_data:&db_data,db_meta:db_meta}
	// mut service_manager := &ServiceManager{db_data:&db_data,db_meta:db_meta}

	mut hr := &HeroRunner{
		agents:   &agent_manager
		circles:  &circle_manager
		names:    &name_manager
		// services: service_manager
		// jobs:     job_manager
	}

	return hr
}

// // cleanup_jobs removes jobs older than the specified number of days
// pub fn (mut hr HeroRunner) cleanup_jobs(days int) !int {
// 	return hr.jobs.cleanup(days)
// }
