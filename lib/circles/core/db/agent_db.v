module db

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.circles.base { DBHandler, SessionState, new_dbhandler }
import freeflowuniverse.herolib.circles.core.models { Agent, AgentService, AgentServiceAction, AgentState }


@[heap]
pub struct AgentDB {
pub mut:
	db DBHandler[Agent]
}

pub fn new_agentdb(session_state SessionState) !AgentDB {
	return AgentDB{
		db: new_dbhandler[Agent]('agent', session_state)
	}
}

pub fn (mut m AgentDB) new() Agent {
	return Agent{}
}

// set adds or updates an agent
pub fn (mut m AgentDB) set(agent Agent) !Agent {
	return m.db.set(agent)!
}

// get retrieves an agent by its ID
pub fn (mut m AgentDB) get(id u32) !Agent {
	return m.db.get(id)!
}
// list returns all agent IDs
pub fn (mut m AgentDB) list() ![]u32 {
	return m.db.list()!
}

pub fn (mut m AgentDB) getall() ![]Agent {
	return m.db.getall()!
}

// delete removes an agent by its ID
pub fn (mut m AgentDB) delete(id u32) ! {
	m.db.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_pubkey retrieves an agent by its public key
pub fn (mut m AgentDB) get_by_pubkey(pubkey string) !Agent {
	return m.db.get_by_key('pubkey', pubkey)!
}

// delete_by_pubkey removes an agent by its public key
pub fn (mut m AgentDB) delete_by_pubkey(pubkey string) ! {
	// Get the agent by pubkey
	agent := m.get_by_pubkey(pubkey) or {
		// Agent not found, nothing to delete
		return
	}
	
	// Delete the agent by ID
	m.delete(agent.id)!
}

// update_status updates just the status of an agent
pub fn (mut m AgentDB) update_status(pubkey string, status AgentState) !Agent {
	// Get the agent by pubkey
	mut agent := m.get_by_pubkey(pubkey)!
	
	// Update the status
	agent.status.status = status
	agent.status.timestamp_last = ourtime.now()
	
	// Save the updated agent
	return m.set(agent)!
}

// get_all_agent_pubkeys returns all agent pubkeys
pub fn (mut m AgentDB) get_all_agent_pubkeys() ![]string {
	// Get all agent IDs
	agent_ids := m.list()!
	
	// Get pubkeys for all agents
	mut pubkeys := []string{}
	for id in agent_ids {
		agent := m.get(id) or { continue }
		pubkeys << agent.pubkey
	}
	
	return pubkeys
}

// get_by_service returns all agents that provide a specific service
pub fn (mut m AgentDB) get_by_service(actor string, action string) ![]Agent {
	mut matching_agents := []Agent{}
	
	// Get all agent IDs
	agent_ids := m.list()!
	
	// Filter agents that provide the specified service
	for id in agent_ids {
		// Get the agent by ID
		agent := m.get(id) or { continue }
		
		// Check if agent provides the specified service
		for service in agent.services {
			if service.actor == actor {
				for service_action in service.actions {
					if service_action.action == action {
						matching_agents << agent
						break
					}
				}
				break
			}
		}
	}
	
	return matching_agents
}
