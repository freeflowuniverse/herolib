module model

import freeflowuniverse.herolib.core.redisclient
import json

const services_key = 'herorunner:services' // Redis key for storing services

// ServiceManager handles all service-related operations
pub struct ServiceManager {
mut:
	redis &redisclient.Redis
}

// new creates a new Service instance
pub fn (mut m ServiceManager) new() Service {
	return Service{
		actor:   '' // Empty actor name to be filled by caller
		actions: []ServiceAction{}
		status:  .ok
	}
}

// add adds a new service to Redis
pub fn (mut m ServiceManager) set(service Service) ! {
	// Store service in Redis hash where key is service.actor and value is JSON of service
	service_json := json.encode(service)
	m.redis.hset(services_key, service.actor, service_json)!
}

// get retrieves a service by its actor name
pub fn (mut m ServiceManager) get(actor string) !Service {
	service_json := m.redis.hget(services_key, actor)!
	return json.decode(Service, service_json)
}

// list returns all services
pub fn (mut m ServiceManager) list() ![]Service {
	mut services := []Service{}

	// Get all services from Redis hash
	services_map := m.redis.hgetall(services_key)!

	// Convert each JSON value to Service struct
	for _, service_json in services_map {
		service := json.decode(Service, service_json)!
		services << service
	}

	return services
}

// delete removes a service by its actor name
pub fn (mut m ServiceManager) delete(actor string) ! {
	m.redis.hdel(services_key, actor)!
}

// update_status updates just the status of a service
pub fn (mut m ServiceManager) update_status(actor string, status ServiceState) ! {
	mut service := m.get(actor)!
	service.status = status
	m.set(service)!
}

// get_by_action returns all services that provide a specific action
pub fn (mut m ServiceManager) get_by_action(action string) ![]Service {
	mut matching_services := []Service{}

	services := m.list()!
	for service in services {
		for act in service.actions {
			if act.action == action {
				matching_services << service
				break
			}
		}
	}

	return matching_services
}

// check_access verifies if a user has access to a service action
pub fn (mut m ServiceManager) check_access(actor string, action string, user_pubkey string, groups []string) !bool {
	service := m.get(actor)!

	// Find the specific action
	mut service_action := ServiceAction{}
	mut found := false
	for act in service.actions {
		if act.action == action {
			service_action = act
			found = true
			break
		}
	}
	if !found {
		return error('Action ${action} not found in service ${actor}')
	}

	// If no ACL is defined, access is granted
	if service_action.acl == none {
		return true
	}

	acl := service_action.acl or { return true }

	// Check each ACE in the ACL
	for ace in acl.ace {
		// Check if user is directly listed
		if user_pubkey in ace.users {
			return ace.right != 'block'
		}

		// Check if any of user's groups are listed
		for group in groups {
			if group in ace.groups {
				return ace.right != 'block'
			}
		}
	}

	return false
}
