module model

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree


@[heap]
pub struct AgentManager {
pub mut:
	manager Manager[Agent]
}

pub fn new_agentmanager(db_data &ourdb.OurDB, db_meta &radixtree.RadixTree) AgentManager {
	return AgentManager{
		manager: Manager[Agent]{db_data: db_data, db_meta: db_meta, prefix: 'agent'}
	}
}

pub fn (mut m AgentManager) new() Agent {
	return Agent{}
}

// set adds or updates an agent
pub fn (mut m AgentManager) set(agent Agent) !Agent {
	return m.manager.set(agent)!
}

// get retrieves an agent by its ID
pub fn (mut m AgentManager) get(id u32) !Agent {
	return m.manager.get(id)!
}
// list returns all agent IDs
pub fn (mut m AgentManager) list() ![]u32 {
	return m.manager.list()!
}

pub fn (mut m AgentManager) getall	() ![]Agent {
	return m.manager.getall()!
}

// delete removes an agent by its ID
pub fn (mut m AgentManager) delete(id u32) ! {
	m.manager.delete(id)!
}

//////////////////CUSTOM METHODS//////////////////////////////////

// get_by_pubkey retrieves an agent by its public key
pub fn (mut m AgentManager) get_by_pubkey(pubkey string) !Agent {
	return m.manager.get_by_key('pubkey', pubkey)!
}

// delete_by_pubkey removes an agent by its public key
pub fn (mut m AgentManager) delete_by_pubkey(pubkey string) ! {
	// Get the agent by pubkey
	agent := m.get_by_pubkey(pubkey) or {
		// Agent not found, nothing to delete
		return
	}
	
	// Delete the agent by ID
	m.delete(agent.id)!
}

// update_status updates just the status of an agent
pub fn (mut m AgentManager) update_status(pubkey string, status AgentState) !Agent {
	// Get the agent by pubkey
	mut agent := m.get_by_pubkey(pubkey)!
	
	// Update the status
	agent.status.status = status
	agent.status.timestamp_last = ourtime.now()
	
	// Save the updated agent
	return m.set(agent)!
}

// get_all_agent_pubkeys returns all agent pubkeys
fn (mut m AgentManager) get_all_agent_pubkeys() ![]string {
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
pub fn (mut m AgentManager) get_by_service(actor string, action string) ![]Agent {
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
