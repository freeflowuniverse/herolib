module model

import freeflowuniverse.herolib.core.redisclient
import freeflowuniverse.herolib.data.ourdb
import os

// HeroRunner is the main factory for managing jobs, agents, services and groups
pub struct HeroRunner {
mut:
	redis &redisclient.Redis
pub mut:
	jobs     &JobManager
	agents   &AgentManager
	services &ServiceManager
	groups   &GroupManager
}

// new creates a new HeroRunner instance
pub fn new() !&HeroRunner {
	mut redis := redisclient.core_get()!

	// Set up the VFS for job storage
	data_dir := os.join_path(os.home_dir(), '.hero', 'jobs')
	os.mkdir_all(data_dir)!

	// Create separate databases for data and metadata
	mut db_data := ourdb.new(
		path: os.join_path(data_dir, 'data')
		incremental_mode: false
	)!

	mut db_metadata := ourdb.new(
		path: os.join_path(data_dir, 'metadata')
		incremental_mode: false
	)!

	//TODO: the ourdb instance is given in the new and passed to each manager


	mut hr := &HeroRunner{
		redis:    redis
		jobs:     &JobManager{
		}
		agents:   &AgentManager{
		}
		services: &ServiceManager{
		}
		groups:   &GroupManager{
		}
	}

	return hr
}

// cleanup_jobs removes jobs older than the specified number of days
pub fn (mut hr HeroRunner) cleanup_jobs(days int) !int {
	return hr.jobs.cleanup(days)
}
