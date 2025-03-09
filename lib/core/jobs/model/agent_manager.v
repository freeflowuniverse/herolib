module model

import freeflowuniverse.herolib.data.ourtime
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.radixtree
import json
import os

// AgentManager handles all agent-related operations
pub struct AgentManager {
pub mut:
	db_data   &ourdb.OurDB     // Database for storing agent data
	db_meta   &radixtree.RadixTree // Radix tree for mapping keys to IDs
}


// new creates a new Agent instance
pub fn (mut m AgentManager) new() Agent {
	return Agent{
		pubkey:   ''   // Empty pubkey to be filled by caller
		port:     9999 // Default port
		status:   AgentStatus{
			guid:            ''
			timestamp_first: ourtime.now()
			timestamp_last:  ourtime.OurTime{}
			status:          .ok
		}
		services: []AgentService{}
	}
}

// set adds or updates an agent
pub fn (mut m AgentManager) set(agent Agent) ! {
	// Ensure the agent has a pubkey
	if agent.pubkey == '' {
		return error('Agent must have a pubkey')
	}

	// Create the key for the radix tree
	key := 'agents:${agent.pubkey}'
	
	// Serialize the agent data
	agent_data := agent.dumps()!
	
	// Check if this agent already exists in the database
	if id_bytes := m.db_meta.search(key) {
		// Agent exists, get the ID and update
		id_str := id_bytes.bytestr()
		id := id_str.u32()
		
		// Update the agent with the existing ID
		mut updated_agent := agent
		updated_agent.id = id
		
		// Store the updated agent
		m.db_data.set(id: id, data: updated_agent.dumps()!)!
	} else {
		// Agent doesn't exist, create a new one with auto-incrementing ID
		id := m.db_data.set(data: agent_data)!
		
		// Store the ID in the radix tree for future lookups
		m.db_meta.insert(key, id.str().bytes())!
		
		// Update the agents:all key with this new agent
		m.add_to_all_agents(agent.pubkey)!
	}
}

// get retrieves an agent by its public key
pub fn (mut m AgentManager) get(pubkey string) !Agent {
	// Create the key for the radix tree
	key := 'agents:${pubkey}'
	
	// Get the ID from the radix tree
	id_bytes := m.db_meta.search(key) or {
		return error('Agent with pubkey ${pubkey} not found')
	}
	
	// Convert the ID bytes to u32
	id_str := id_bytes.bytestr()
	id := id_str.u32()
	
	// Get the agent data from the database
	agent_data := m.db_data.get(id) or {
		return error('Agent data not found for ID ${id}')
	}
	
	// Deserialize the agent data
	mut agent := agent_loads(agent_data) or {
		return error('Failed to deserialize agent data: ${err}')
	}
	
	// Set the ID in the agent
	agent.id = id
	
	return agent
}

// list returns all agents
pub fn (mut m AgentManager) list() ![]Agent {
	mut agents := []Agent{}
	
	// Get the list of all agent pubkeys from the special key
	pubkeys := m.get_all_agent_pubkeys() or {
		// If no agents are found, return an empty list
		return agents
	}
	
	// For each pubkey, get the agent
	for pubkey in pubkeys {
		// Get the agent
		agent := m.get(pubkey) or {
			// If we can't get the agent, skip it
			continue
		}
		
		agents << agent
	}
	
	return agents
}

// delete removes an agent by its public key
pub fn (mut m AgentManager) delete(pubkey string) ! {
	// Create the key for the radix tree
	key := 'agents:${pubkey}'
	
	// Get the ID from the radix tree
	id_bytes := m.db_meta.search(key) or {
		return error('Agent with pubkey ${pubkey} not found')
	}
	
	// Convert the ID bytes to u32
	id_str := id_bytes.bytestr()
	id := id_str.u32()
	
	// Delete the agent data from the database
	m.db_data.delete(id)!
	
	// Delete the key from the radix tree
	m.db_meta.delete(key)!
	
	// Remove from the agents:all list
	m.remove_from_all_agents(pubkey)!
}

// update_status updates just the status of an agent
pub fn (mut m AgentManager) update_status(pubkey string, status AgentState) ! {
	// Get the agent
	mut agent := m.get(pubkey)!
	
	// Update the status
	agent.status.status = status
	agent.status.timestamp_last = ourtime.now()
	
	// Save the updated agent
	m.set(agent)!
}

// Helper function to get all agent pubkeys from the special key
fn (mut m AgentManager) get_all_agent_pubkeys() ![]string {
	// Try to get the agents:all key
	if all_bytes := m.db_meta.search('agents:all') {
		// Convert to string and split by comma
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			return all_str.split(',')
		}
	}
	
	return error('No agents found')
}

// Helper function to add a pubkey to the agents:all list
fn (mut m AgentManager) add_to_all_agents(pubkey string) ! {
	mut all_pubkeys := []string{}
	
	// Try to get existing list
	if all_bytes := m.db_meta.search('agents:all') {
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			all_pubkeys = all_str.split(',')
		}
	}
	
	// Check if pubkey is already in the list
	for existing in all_pubkeys {
		if existing == pubkey {
			// Already in the list, nothing to do
			return
		}
	}
	
	// Add the new pubkey
	all_pubkeys << pubkey
	
	// Join and store back
	new_all := all_pubkeys.join(',')
	
	// Store in the radix tree
	m.db_meta.insert('agents:all', new_all.bytes())!
}

// Helper function to remove a pubkey from the agents:all list
fn (mut m AgentManager) remove_from_all_agents(pubkey string) ! {
	// Try to get existing list
	if all_bytes := m.db_meta.search('agents:all') {
		all_str := all_bytes.bytestr()
		if all_str.len > 0 {
			mut all_pubkeys := all_str.split(',')
			
			// Find and remove the pubkey
			for i, existing in all_pubkeys {
				if existing == pubkey {
					all_pubkeys.delete(i)
					break
				}
			}
			
			// Join and store back
			new_all := all_pubkeys.join(',')
			
			// Store in the radix tree
			m.db_meta.insert('agents:all', new_all.bytes())!
		}
	}
}

// get_by_service returns all agents that provide a specific service
pub fn (mut m AgentManager) get_by_service(actor string, action string) ![]Agent {
	mut matching_agents := []Agent{}
	
	// Get all agents
	agents := m.list()!
	
	// Filter agents that provide the specified service
	for agent in agents {
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
