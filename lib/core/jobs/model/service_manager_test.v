module model

import freeflowuniverse.herolib.core.redisclient

fn test_services() {
	mut runner := new()!

	// Create a new service using the manager
	mut service := runner.services.new()
	service.actor = 'vm_manager'
	service.description = 'VM Management Service'

	// Create an ACL
	mut ace := ACE{
		groups: ['admin-group']
		users:  ['user-1-pubkey']
		right:  'write'
	}

	mut acl := ACL{
		name: 'vm-acl'
		ace:  [ace]
	}

	// Create a service action
	mut action := ServiceAction{
		action:         'start'
		description:    'Start a VM'
		params:         {
			'name': 'string'
		}
		params_example: {
			'name': 'myvm'
		}
		acl:            acl
	}

	service.actions = [action]

	// Add the service
	runner.services.set(service)!

	// Get the service and verify fields
	retrieved_service := runner.services.get(service.actor)!
	assert retrieved_service.actor == service.actor
	assert retrieved_service.description == service.description
	assert retrieved_service.actions.len == 1
	assert retrieved_service.actions[0].action == 'start'
	assert retrieved_service.status == .ok

	// Update service status
	runner.services.update_status(service.actor, .down)!
	updated_service := runner.services.get(service.actor)!
	assert updated_service.status == .down

	// Test get_by_action
	services := runner.services.get_by_action('start')!
	assert services.len > 0
	assert services[0].actor == service.actor

	// Test access control
	has_access := runner.services.check_access(service.actor, 'start', 'user-1-pubkey',
		[])!
	assert has_access == true

	has_group_access := runner.services.check_access(service.actor, 'start', 'user-2-pubkey',
		['admin-group'])!
	assert has_group_access == true

	no_access := runner.services.check_access(service.actor, 'start', 'user-3-pubkey',
		[])!
	assert no_access == false

	// List all services
	all_services := runner.services.list()!
	assert all_services.len > 0
	assert all_services[0].actor == service.actor

	// Delete the service
	runner.services.delete(service.actor)!

	// Verify deletion
	services_after := runner.services.list()!
	for s in services_after {
		assert s.actor != service.actor
	}
}
