module core

import os
import rand
import freeflowuniverse.herolib.circles.actionprocessor
import freeflowuniverse.herolib.circles.core.model

fn test_agent_db() {
	// Create a temporary directory for testing
	test_dir := os.join_path(os.temp_dir(), 'hero_agent_test_${rand.intn(9000) or { 0 } + 1000}')
	os.mkdir_all(test_dir) or { panic(err) }
	defer { os.rmdir_all(test_dir) or {} }
	
	mut runner := actionprocessor.new(path: test_dir)!

	// Create multiple agents for testing
	mut agent1 := runner.agents.new()
	agent1.pubkey = 'test-agent-1'
	agent1.address = '127.0.0.1'
	agent1.description = 'Test Agent 1'

	mut agent2 := runner.agents.new()
	agent2.pubkey = 'test-agent-2'
	agent2.address = '127.0.0.2'
	agent2.description = 'Test Agent 2'

	mut agent3 := runner.agents.new()
	agent3.pubkey = 'test-agent-3'
	agent3.address = '127.0.0.3'
	agent3.description = 'Test Agent 3'

	// Create a service using the factory method
	mut service := agent1.new_service(actor: 'vm_manager', description: 'VM Management Service')
	
	// Create a service action using the factory method
	mut action := service.new_action(action:'start', description: 'Start a VM')
	
	// Set additional properties for the action
	action.params = {
		'name': 'string'
	}
	action.params_example = {
		'name': 'myvm'
	}

	// Add the agents
	println('Adding agent 1')
	agent1 = runner.agents.set(agent1)!
	
	// Explicitly set different IDs for each agent to avoid overwriting
	agent2.id = 1 // Set a different ID for agent2
	println('Adding agent 2')
	agent2 = runner.agents.set(agent2)!
	
	agent3.id = 2 // Set a different ID for agent3
	println('Adding agent 3')
	agent3 = runner.agents.set(agent3)!

	// Test list functionality
	println('Testing list functionality')
	
	// Debug: Print the agent IDs in the list
	agent_ids := runner.agents.list()!
	println('Agent IDs in list: ${agent_ids}')
	
	// Debug: Print the 'all' key from the radix tree
	all_bytes := runner.agents.db.session_state.dbs.db_meta_core.get('agent:id') or {
		println('No agent:id key found in radix tree')
		[]u8{}
	}
	
	if all_bytes.len > 0 {
		all_str := all_bytes.bytestr()
		println('Raw agent:id key content: "${all_str}"')
	}
	
	// Get all agents
	all_agents := runner.agents.getall()!
	println('Retrieved ${all_agents.len} agents')
	for i, agent in all_agents {
		println('Agent ${i}: id=${agent.id}, pubkey=${agent.pubkey}')
	}
	
	assert all_agents.len == 3, 'Expected 3 agents, got ${all_agents.len}'
	
	// Verify all agents are in the list
	mut found1 := false
	mut found2 := false
	mut found3 := false
	
	for agent in all_agents {
		if agent.pubkey == 'test-agent-1' {
			found1 = true
		} else if agent.pubkey == 'test-agent-2' {
			found2 = true
		} else if agent.pubkey == 'test-agent-3' {
			found3 = true
		}
	}
	
	assert found1, 'Agent 1 not found in list'
	assert found2, 'Agent 2 not found in list'
	assert found3, 'Agent 3 not found in list'

	// Get and verify individual agents
	println('Verifying individual agents')
	retrieved_agent1 := runner.agents.get_by_pubkey('test-agent-1')!
	assert retrieved_agent1.pubkey == agent1.pubkey
	assert retrieved_agent1.address == agent1.address
	assert retrieved_agent1.description == agent1.description
	assert retrieved_agent1.services.len == 1
	assert retrieved_agent1.services[0].actor == 'vm_manager'
	assert retrieved_agent1.status.status == .ok

	// Update agent status
	println('Updating agent status')
	runner.agents.update_status('test-agent-1', .down)!
	updated_agent := runner.agents.get_by_pubkey('test-agent-1')!
	assert updated_agent.status.status == .down

	// Test get_by_service
	println('Testing get_by_service')
	service_agents := runner.agents.get_by_service('vm_manager', 'start')!
	assert service_agents.len == 1
	assert service_agents[0].pubkey == 'test-agent-1'

	// Test delete functionality
	println('Testing delete functionality')
	// Delete agent 2
	runner.agents.delete_by_pubkey('test-agent-2')!
	
	// Verify deletion with list
	agents_after_delete := runner.agents.getall()!
	assert agents_after_delete.len == 2, 'Expected 2 agents after deletion, got ${agents_after_delete.len}'
	
	// Verify the remaining agents
	mut found_after_delete1 := false
	mut found_after_delete2 := false
	mut found_after_delete3 := false
	
	for agent in agents_after_delete {
		if agent.pubkey == 'test-agent-1' {
			found_after_delete1 = true
		} else if agent.pubkey == 'test-agent-2' {
			found_after_delete2 = true
		} else if agent.pubkey == 'test-agent-3' {
			found_after_delete3 = true
		}
	}
	
	assert found_after_delete1, 'Agent 1 not found after deletion'
	assert !found_after_delete2, 'Agent 2 found after deletion (should be deleted)'
	assert found_after_delete3, 'Agent 3 not found after deletion'

	// Delete another agent
	println('Deleting another agent')
	runner.agents.delete_by_pubkey('test-agent-3')!
	
	// Verify only one agent remains
	agents_after_second_delete := runner.agents.getall()!
	assert agents_after_second_delete.len == 1, 'Expected 1 agent after second deletion, got ${agents_after_second_delete.len}'
	assert agents_after_second_delete[0].pubkey == 'test-agent-1', 'Remaining agent should be test-agent-1'

	// Delete the last agent
	println('Deleting last agent')
	runner.agents.delete_by_pubkey('test-agent-1')!
	
	// Verify no agents remain
	agents_after_all_deleted := runner.agents.getall() or {
		// This is expected to fail with 'No agents found' error
		assert err.msg() == 'No agents found'
		[]core.Agent{cap: 0}
	}
	assert agents_after_all_deleted.len == 0, 'Expected 0 agents after all deletions, got ${agents_after_all_deleted.len}'

	println('All tests passed successfully')
}
