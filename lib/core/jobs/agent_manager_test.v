module jobs

import freeflowuniverse.herolib.core.redisclient
import freeflowuniverse.herolib.data.ourtime

fn test_runner.agents() {

	mut runner:=new()!

	// Create a new agent using the manager
	mut agent := runner.agents.new()	
	agent.pubkey = 'test-agent-1'
	agent.address = '127.0.0.1'
	agent.description = 'Test Agent'
	
	// Create a service action
	mut action := AgentServiceAction{
		action: 'start'
		description: 'Start a VM'
		params: {
			'name': 'string'
		}
		params_example: {
			'name': 'myvm'
		}
		status: .ok
		public: true
	}
	
	// Create a service
	mut service := AgentService{
		actor: 'vm_manager'
		actions: [action]
		description: 'VM Management Service'
		status: .ok
	}
	
	agent.services = [service]
	
	// Add the agent
	runner.agents.set(agent)!
	
	// Get the agent and verify fields
	retrieved_agent := runner.agents.get(agent.pubkey)!
	assert retrieved_agent.pubkey == agent.pubkey
	assert retrieved_agent.address == agent.address
	assert retrieved_agent.description == agent.description
	assert retrieved_agent.services.len == 1
	assert retrieved_agent.services[0].actor == 'vm_manager'
	assert retrieved_agent.status.status == .ok
	
	// Update agent status
	runner.agents.update_status(agent.pubkey, .down)!
	updated_agent := runner.agents.get(agent.pubkey)!
	assert updated_agent.status.status == .down
	
	// Test get_by_service
	agents := runner.agents.get_by_service('vm_manager', 'start')!
	assert agents.len > 0
	assert agents[0].pubkey == agent.pubkey
	
	// List all agents
	all_agents := runner.agents.list()!
	assert all_agents.len > 0
	assert all_agents[0].pubkey == agent.pubkey
	
	// Delete the agent
	runner.agents.delete(agent.pubkey)!
	
	// Verify deletion
	agents_after := runner.agents.list()!
	for a in agents_after {
		assert a.pubkey != agent.pubkey
	}
}
