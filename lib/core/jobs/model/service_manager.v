module model

import json

// ServiceManager handles all service-related operations
pub struct ServiceManager {
}

// new creates a new Service instance
pub fn (mut m ServiceManager) new() Service {
	return Service{
		actor:   '' // Empty actor name to be filled by caller
		actions: []ServiceAction{}
		status:  .ok
	}
}

// set adds or updates a service
pub fn (mut m ServiceManager) set(service Service) ! {
	// Implementation removed
}

// get retrieves a service by its actor name
pub fn (mut m ServiceManager) get(actor string) !Service {
	// Implementation removed
	return Service{}
}

// list returns all services
pub fn (mut m ServiceManager) list() ![]Service {
	mut services := []Service{}

	// Implementation removed

	return services
}

// delete removes a service by its actor name
pub fn (mut m ServiceManager) delete(actor string) ! {
	// Implementation removed
}

// update_status updates just the status of a service
pub fn (mut m ServiceManager) update_status(actor string, status ServiceState) ! {
	// Implementation removed
}

// get_by_action returns all services that provide a specific action
pub fn (mut m ServiceManager) get_by_action(action string) ![]Service {
	mut matching_services := []Service{}

	// Implementation removed

	return matching_services
}

// check_access verifies if a user has access to a service action
pub fn (mut m ServiceManager) check_access(actor string, action string, user_pubkey string, groups []string) !bool {
	// Implementation removed
	return true
}
