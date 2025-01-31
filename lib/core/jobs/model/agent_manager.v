module model

import freeflowuniverse.herolib.core.redisclient
import freeflowuniverse.herolib.data.ourtime
import json

const (
	agents_key = 'herorunner:agents' // Redis key for storing agents
)

// AgentManager handles all agent-related operations
pub struct AgentManager {
mut:
	redis &redisclient.Redis
}

// new creates a new Agent instance
pub fn (mut m AgentManager) new() Agent {
	return Agent{
		pubkey: '' // Empty pubkey to be filled by caller
		port: 9999 // Default port
		status: AgentStatus{
			guid: ''
			timestamp_first: ourtime.Time{}
			timestamp_last: ourtime.Time{}
			status: .ok
		}
		services: []AgentService{}
	}
}

// add adds a new agent to Redis
pub fn (mut m AgentManager) set(agent Agent) ! {
	// Store agent in Redis hash where key is agent.pubkey and value is JSON of agent
	agent_json := json.encode(agent)
	m.redis.hset(agents_key, agent.pubkey, agent_json)!
}

// get retrieves an agent by its public key
pub fn (mut m AgentManager) get(pubkey string) !Agent {
	agent_json := m.redis.hget(agents_key, pubkey)!
	return json.decode(Agent, agent_json)
}

// list returns all agents
pub fn (mut m AgentManager) list() ![]Agent {
	mut agents := []Agent{}
	
	// Get all agents from Redis hash
	agents_map := m.redis.hgetall(agents_key)!
	
	// Convert each JSON value to Agent struct
	for _, agent_json in agents_map {
		agent := json.decode(Agent, agent_json)!
		agents << agent
	}
	
	return agents
}

// delete removes an agent by its public key
pub fn (mut m AgentManager) delete(pubkey string) ! {
	m.redis.hdel(agents_key, pubkey)!
}

// update_status updates just the status of an agent
pub fn (mut m AgentManager) update_status(pubkey string, status AgentState) ! {
	mut agent := m.get(pubkey)!
	agent.status.status = status
	m.update(agent)!
}

// get_by_service returns all agents that provide a specific service
pub fn (mut m AgentManager) get_by_service(actor string, action string) ![]Agent {
	mut matching_agents := []Agent{}
	
	agents := m.list()!
	for agent in agents {
		for service in agent.services {
			if service.actor != actor {
				continue
			}
			for act in service.actions {
				if act.action == action {
					matching_agents << agent
					break
				}
			}
		}
	}
	
	return matching_agents
}
