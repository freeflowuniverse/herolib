module models

import freeflowuniverse.herolib.data.ourtime

fn test_agent_dumps_loads() {
	// Create a test agent with some sample data
	mut agent := Agent{
		pubkey: 'ed25519:1234567890abcdef'
		address: '192.168.1.100'
		port: 9999
		description: 'Test agent for binary encoding'
		status: AgentStatus{
			guid: 'agent-123'
			timestamp_first: ourtime.now()
			timestamp_last: ourtime.now()
			status: AgentState.ok
		}
		signature: 'signature-data-here'
	}

	// Add a service
	mut service := AgentService{
		actor: 'vm'
		description: 'Virtual machine management'
		status: AgentServiceState.ok
		public: true
	}

	// Add an action to the service
	action := AgentServiceAction{
		action: 'create'
		description: 'Create a new virtual machine'
		status: AgentServiceState.ok
		public: true
		params: {
			'name': 'Name of the VM'
			'memory': 'Memory in MB'
			'cpu': 'Number of CPU cores'
		}
		params_example: {
			'name': 'my-test-vm'
			'memory': '2048'
			'cpu': '2'
		}
	}

	service.actions << action

	// Add another action
	action2 := AgentServiceAction{
		action: 'delete'
		description: 'Delete a virtual machine'
		status: AgentServiceState.ok
		public: false
		params: {
			'name': 'Name of the VM to delete'
		}
		params_example: {
			'name': 'my-test-vm'
		}
	}

	service.actions << action2
	agent.services << service

	// Test binary encoding
	binary_data := agent.dumps() or {
		assert false, 'Failed to encode agent: ${err}'
		return
	}

	// Test binary decoding
	mut decoded_agent := Agent{}
	decoded_agent.loads(binary_data) or {
		assert false, 'Failed to decode agent: ${err}'
		return
	}

	// Verify the decoded data matches the original
	assert decoded_agent.pubkey == agent.pubkey
	assert decoded_agent.address == agent.address
	assert decoded_agent.port == agent.port
	assert decoded_agent.description == agent.description
	assert decoded_agent.signature == agent.signature

	// Verify status
	assert decoded_agent.status.guid == agent.status.guid
	assert decoded_agent.status.status == agent.status.status

	// Verify services
	assert decoded_agent.services.len == agent.services.len
	if decoded_agent.services.len > 0 {
		service1 := decoded_agent.services[0]
		original_service := agent.services[0]
		
		assert service1.actor == original_service.actor
		assert service1.description == original_service.description
		assert service1.status == original_service.status
		assert service1.public == original_service.public
		
		// Verify actions
		assert service1.actions.len == original_service.actions.len
		if service1.actions.len > 0 {
			action1 := service1.actions[0]
			original_action := original_service.actions[0]
			
			assert action1.action == original_action.action
			assert action1.description == original_action.description
			assert action1.status == original_action.status
			assert action1.public == original_action.public
			
			// Verify params
			assert action1.params.len == original_action.params.len
			for key, value in original_action.params {
				assert key in action1.params
				assert action1.params[key] == value
			}
			
			// Verify params_example
			assert action1.params_example.len == original_action.params_example.len
			for key, value in original_action.params_example {
				assert key in action1.params_example
				assert action1.params_example[key] == value
			}
		}
	}

	println('Agent binary encoding/decoding test passed successfully')
}

fn test_agent_complex_structure() {
	// Create a more complex agent with multiple services and actions
	mut agent := Agent{
		pubkey: 'ed25519:complex-test-key'
		address: '10.0.0.5'
		port: 8080
		description: 'Complex test agent'
		status: AgentStatus{
			guid: 'complex-agent-456'
			timestamp_first: ourtime.now()
			timestamp_last: ourtime.now()
			status: AgentState.ok
		}
		signature: 'complex-signature-data'
	}

	// Add first service - VM management
	mut vm_service := AgentService{
		actor: 'vm'
		description: 'VM management service'
		status: AgentServiceState.ok
		public: true
	}

	// Add actions to VM service
	vm_service.actions << AgentServiceAction{
		action: 'create'
		description: 'Create VM'
		status: AgentServiceState.ok
		public: true
		params: {
			'name': 'VM name'
			'size': 'VM size'
		}
		params_example: {
			'name': 'test-vm'
			'size': 'medium'
		}
	}

	vm_service.actions << AgentServiceAction{
		action: 'start'
		description: 'Start VM'
		status: AgentServiceState.ok
		public: true
		params: {
			'name': 'VM name'
		}
		params_example: {
			'name': 'test-vm'
		}
	}

	// Add second service - Storage management
	mut storage_service := AgentService{
		actor: 'storage'
		description: 'Storage management service'
		status: AgentServiceState.ok
		public: false
	}

	// Add actions to storage service
	storage_service.actions << AgentServiceAction{
		action: 'create_volume'
		description: 'Create storage volume'
		status: AgentServiceState.ok
		public: false
		params: {
			'name': 'Volume name'
			'size': 'Volume size in GB'
		}
		params_example: {
			'name': 'data-vol'
			'size': '100'
		}
	}

	storage_service.actions << AgentServiceAction{
		action: 'attach_volume'
		description: 'Attach volume to VM'
		status: AgentServiceState.ok
		public: false
		params: {
			'volume': 'Volume name'
			'vm': 'VM name'
			'mount_point': 'Mount point'
		}
		params_example: {
			'volume': 'data-vol'
			'vm': 'test-vm'
			'mount_point': '/data'
		}
	}

	// Add services to agent
	agent.services << vm_service
	agent.services << storage_service

	// Test binary encoding
	binary_data := agent.dumps() or {
		assert false, 'Failed to encode complex agent: ${err}'
		return
	}

	// Test binary decoding
	mut decoded_agent := Agent{}
	decoded_agent.loads(binary_data) or {
		assert false, 'Failed to decode complex agent: ${err}'
		return
	}

	// Verify the decoded data
	assert decoded_agent.pubkey == agent.pubkey
	assert decoded_agent.address == agent.address
	assert decoded_agent.port == agent.port
	assert decoded_agent.services.len == agent.services.len
	
	// Verify first service (VM)
	if decoded_agent.services.len > 0 {
		vm := decoded_agent.services[0]
		assert vm.actor == 'vm'
		assert vm.actions.len == 2
		
		// Check VM create action
		create_action := vm.actions[0]
		assert create_action.action == 'create'
		assert create_action.params.len == 2
		assert create_action.params['name'] == 'VM name'
		
		// Check VM start action
		start_action := vm.actions[1]
		assert start_action.action == 'start'
		assert start_action.params.len == 1
	}
	
	// Verify second service (Storage)
	if decoded_agent.services.len > 1 {
		storage := decoded_agent.services[1]
		assert storage.actor == 'storage'
		assert storage.public == false
		assert storage.actions.len == 2
		
		// Check storage attach action
		attach_action := storage.actions[1]
		assert attach_action.action == 'attach_volume'
		assert attach_action.params.len == 3
		assert attach_action.params['mount_point'] == 'Mount point'
		assert attach_action.params_example['mount_point'] == '/data'
	}

	println('Complex agent binary encoding/decoding test passed successfully')
}

fn test_agent_empty_structures() {
	// Test with empty arrays and maps
	mut agent := Agent{
		pubkey: 'ed25519:empty-test'
		address: '127.0.0.1'
		port: 7777
		description: ''
		status: AgentStatus{
			guid: 'empty-agent'
			timestamp_first: ourtime.now()
			timestamp_last: ourtime.now()
			status: AgentState.down
		}
		signature: ''
		services: []
	}

	// Test binary encoding
	binary_data := agent.dumps() or {
		assert false, 'Failed to encode empty agent: ${err}'
		return
	}

	// Test binary decoding
	mut decoded_agent := Agent{}
	decoded_agent.loads(binary_data) or {
		assert false, 'Failed to decode empty agent: ${err}'
		return
	}

	// Verify the decoded data
	assert decoded_agent.pubkey == agent.pubkey
	assert decoded_agent.address == agent.address
	assert decoded_agent.port == agent.port
	assert decoded_agent.description == ''
	assert decoded_agent.signature == ''
	assert decoded_agent.services.len == 0
	assert decoded_agent.status.status == AgentState.down

	println('Empty agent binary encoding/decoding test passed successfully')
}
