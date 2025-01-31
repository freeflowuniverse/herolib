module jobs

import freeflowuniverse.herolib.core.redisclient

// HeroRunner is the main factory for managing jobs, agents, services and groups
pub struct HeroRunner {
mut:
	redis &redisclient.Redis
pub mut:
	jobs    &JobManager
	agents  &AgentManager
	services &ServiceManager
	groups  &GroupManager
}

// new creates a new HeroRunner instance
pub fn new() !&HeroRunner {
	mut redis := redisclient.core_get()!
	
	mut hr := &HeroRunner{
		redis: redis
		jobs: &JobManager{
			redis: redis
		}
		agents: &AgentManager{
			redis: redis
		}
		services: &ServiceManager{
			redis: redis
		}
		groups: &GroupManager{
			redis: redis
		}
	}
	
	return hr
}
