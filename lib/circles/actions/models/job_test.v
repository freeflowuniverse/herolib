module model

import freeflowuniverse.herolib.data.ourtime

fn test_job_serialization() {
	// Create a test job
	mut job := Job{
		id: 1
		guid: 'test-job-1'
		agents: ['agent1', 'agent2']
		source: 'source1'
		circle: 'test-circle'
		context: 'test-context'
		actor: 'vm_manager'
		action: 'start'
		params: {
			'id': '10'
			'name': 'test-vm'
		}
		timeout_schedule: 120
		timeout: 7200
		log: true
		ignore_error: false
		ignore_error_codes: [404, 500]
		debug: true
		retry: 3
	}

	// Set up job status
	job.status = JobStatus{
		guid: job.guid
		created: ourtime.now()
		start: ourtime.now()
		end: ourtime.OurTime{}
		status: .created
	}

	// Add a dependency
	job.dependencies << JobDependency{
		guid: 'dependency-job-1'
		agents: ['agent1']
	}

	// Test index_keys method
	keys := job.index_keys()
	assert keys['guid'] == 'test-job-1'
	assert keys['actor'] == 'vm_manager'
	assert keys['circle'] == 'test-circle'
	assert keys['context'] == 'test-context'

	// Serialize the job
	println('Serializing job...')
	serialized := job.dumps() or {
		assert false, 'Failed to serialize job: ${err}'
		return
	}
	assert serialized.len > 0, 'Serialized data should not be empty'

	// Deserialize the job
	println('Deserializing job...')
	deserialized := job_loads(serialized) or {
		assert false, 'Failed to deserialize job: ${err}'
		return
	}

	// Verify the deserialized job
	assert deserialized.id == job.id
	assert deserialized.guid == job.guid
	assert deserialized.agents.len == job.agents.len
	assert deserialized.agents[0] == job.agents[0]
	assert deserialized.agents[1] == job.agents[1]
	assert deserialized.source == job.source
	assert deserialized.circle == job.circle
	assert deserialized.context == job.context
	assert deserialized.actor == job.actor
	assert deserialized.action == job.action
	assert deserialized.params.len == job.params.len
	assert deserialized.params['id'] == job.params['id']
	assert deserialized.params['name'] == job.params['name']
	assert deserialized.timeout_schedule == job.timeout_schedule
	assert deserialized.timeout == job.timeout
	assert deserialized.log == job.log
	assert deserialized.ignore_error == job.ignore_error
	assert deserialized.ignore_error_codes.len == job.ignore_error_codes.len
	assert deserialized.ignore_error_codes[0] == job.ignore_error_codes[0]
	assert deserialized.ignore_error_codes[1] == job.ignore_error_codes[1]
	assert deserialized.debug == job.debug
	assert deserialized.retry == job.retry
	assert deserialized.status.guid == job.status.guid
	assert deserialized.status.status == job.status.status
	assert deserialized.dependencies.len == job.dependencies.len
	assert deserialized.dependencies[0].guid == job.dependencies[0].guid
	assert deserialized.dependencies[0].agents.len == job.dependencies[0].agents.len
	assert deserialized.dependencies[0].agents[0] == job.dependencies[0].agents[0]

	println('All job serialization tests passed!')
}

fn test_job_status_enum() {
	// Test all status enum values
	assert u8(Status.created) == 0
	assert u8(Status.scheduled) == 1
	assert u8(Status.planned) == 2
	assert u8(Status.running) == 3
	assert u8(Status.error) == 4
	assert u8(Status.ok) == 5

	// Test status progression
	mut status := Status.created
	assert status == .created

	status = .scheduled
	assert status == .scheduled

	status = .planned
	assert status == .planned

	status = .running
	assert status == .running

	status = .error
	assert status == .error

	status = .ok
	assert status == .ok

	println('All job status enum tests passed!')
}

fn test_job_dependency() {
	// Create a test dependency
	mut dependency := JobDependency{
		guid: 'dependency-job-1'
		agents: ['agent1', 'agent2', 'agent3']
	}

	// Create a job with this dependency
	mut job := Job{
		id: 2
		guid: 'test-job-2'
		actor: 'network_manager'
		action: 'create'
		dependencies: [dependency]
	}

	// Test dependency properties
	assert job.dependencies.len == 1
	assert job.dependencies[0].guid == 'dependency-job-1'
	assert job.dependencies[0].agents.len == 3
	assert job.dependencies[0].agents[0] == 'agent1'
	assert job.dependencies[0].agents[1] == 'agent2'
	assert job.dependencies[0].agents[2] == 'agent3'

	// Add another dependency
	job.dependencies << JobDependency{
		guid: 'dependency-job-2'
		agents: ['agent4']
	}

	// Test multiple dependencies
	assert job.dependencies.len == 2
	assert job.dependencies[1].guid == 'dependency-job-2'
	assert job.dependencies[1].agents.len == 1
	assert job.dependencies[1].agents[0] == 'agent4'

	println('All job dependency tests passed!')
}

fn test_job_with_empty_values() {
	// Create a job with minimal values
	mut job := Job{
		id: 3
		guid: 'minimal-job'
		actor: 'minimal_actor'
		action: 'test'
	}

	// Serialize and deserialize
	serialized := job.dumps() or {
		assert false, 'Failed to serialize minimal job: ${err}'
		return
	}

	deserialized := job_loads(serialized) or {
		assert false, 'Failed to deserialize minimal job: ${err}'
		return
	}

	// Verify defaults are preserved
	assert deserialized.id == job.id
	assert deserialized.guid == job.guid
	assert deserialized.circle == 'default' // Default value
	assert deserialized.context == 'default' // Default value
	assert deserialized.actor == 'minimal_actor'
	assert deserialized.action == 'test'
	assert deserialized.agents.len == 0
	assert deserialized.params.len == 0
	assert deserialized.timeout_schedule == 60 // Default value
	assert deserialized.timeout == 3600 // Default value
	assert deserialized.log == true // Default value
	assert deserialized.ignore_error == false // Default value
	assert deserialized.ignore_error_codes.len == 0
	assert deserialized.dependencies.len == 0

	println('All minimal job tests passed!')
}
