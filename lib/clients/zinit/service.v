module zinit

import freeflowuniverse.herolib.schemas.jsonrpc

// ServiceConfig represents the configuration for a zinit service
pub struct ServiceConfig {
pub mut:
	exec             string            // Command to run
	oneshot          bool              // Whether the service should be restarted
	after            []string          // Services that must be running before this one starts
	log              string            // How to handle service output (null, ring, stdout)
	env              map[string]string // Environment variables for the service
	shutdown_timeout int               // Maximum time to wait for service to stop during shutdown
}

// KillParams represents the parameters for the service_kill method
pub struct KillParams {
pub:
	name   string // Name of the service to kill
	signal string // Signal to send (e.g., SIGTERM, SIGKILL)
}


// RpcDiscoverResponse represents the response from rpc.discover
pub struct RpcDiscoverResponse {
pub mut:
	spec map[string]string // OpenRPC specification
}


// rpc_discover returns the OpenRPC specification for the API
pub fn (mut c Client) rpc_discover() !RpcDiscoverResponse {
	request := jsonrpc.new_request_generic('rpc.discover', []string{})
	response := c.rpc_client.send[[]string, map[string]string](request)!
	return RpcDiscoverResponse{
		spec: response
	}
}



// // Response Models for Zinit API
// //
// // This file contains all the response models used by the Zinit API.
// // These models are used as type parameters in the response generics.

// // ServiceListResponse represents the response from service_list
// pub struct ServiceListResponse {
// pub mut:
// 	// Map of service names to their current states
// 	services map[string]string
// }

// service_list lists all services managed by Zinit
// Returns a map of service names to their current states
pub fn (mut c Client) service_list() !map[string]string {
	request := jsonrpc.new_request_generic('service_list',map[string]string  )
	services := c.rpc_client.send[map[string]string, map[string]string](request)!
	// return ServiceListResponse{
	// 	services: services
	// }
	return services
}

// ServiceStatusResponse represents the response from service_status
pub struct ServiceStatusResponse {
pub mut:
	name   string            // Service name
	pid    int               // Process ID of the running service (if running)
	state  string            // Current state of the service (Running, Success, Error, etc.)
	target string            // Target state of the service (Up, Down)
	after  map[string]string // Dependencies of the service and their states
}

// service_status shows detailed status information for a specific service
// name: the name of the service
pub fn (mut c Client) service_status(name string) !ServiceStatusResponse {
	request := jsonrpc.new_request_generic('service_status', name)
	
	// Use a direct struct mapping instead of manual conversion
	return c.rpc_client.send[string, ServiceStatusResponse](request)!
}

// service_start starts a service
// name: the name of the service to start
pub fn (mut c Client) service_start(name string) ! {
	request := jsonrpc.new_request_generic('service_start', name)
	c.rpc_client.send[string, string](request)!
}

// service_stop stops a service
// name: the name of the service to stop
pub fn (mut c Client) service_stop(name string) ! {
	request := jsonrpc.new_request_generic('service_stop', name)
	c.rpc_client.send[string, string](request)!
}

// service_monitor starts monitoring a service
// The service configuration is loaded from the config directory
// name: the name of the service to monitor
pub fn (mut c Client) service_monitor(name string) ! {
	request := jsonrpc.new_request_generic('service_monitor', name)
	c.rpc_client.send[string, string](request)!
}

// service_delete deletes a service configuration file
// name: the name of the service to delete
pub fn (mut c Client) service_delete(name string) !ServiceDeleteResponse {
	request := jsonrpc.new_request_generic('service_delete', name)
	result := c.rpc_client.send[string, string](request)!
	return ServiceDeleteResponse{
		result: result
	}
}

// service_forget stops monitoring a service
// You can only forget a stopped service
// name: the name of the service to forget
pub fn (mut c Client) service_forget(name string) ! {
	request := jsonrpc.new_request_generic('service_forget', name)
	c.rpc_client.send[string, string](request)!
}

//TODO: make sure the signal is a valid signal and enumerator do as @[params] so its optional


// service_kill sends a signal to a running service
// name: the name of the service to send the signal to
// signal: the signal to send (e.g., SIGTERM, SIGKILL)
pub fn (mut c Client) service_kill(name string, signal string) ! {
	params := KillParams{
		name: name
		signal: signal
	}
	
	request := jsonrpc.new_request_generic('service_kill', params)
	c.rpc_client.send[KillParams, string](request)!
}


// CreateServiceParams represents the parameters for the service_create method
struct CreateServiceParams {
	name    string        // Name of the service to create
	content ServiceConfig // Configuration for the service
}


// service_create creates a new service configuration file
// name: the name of the service to create
// config: the service configuration
pub fn (mut c Client) service_create(name string, config ServiceConfig) !ServiceCreateResponse {
	params := CreateServiceParams{
		name: name
		content: config
	}
	
	request := jsonrpc.new_request_generic('service_create', params)
	path := c.rpc_client.send[CreateServiceParams, string](request)!
	return ServiceCreateResponse{
		path: path
	}
}

// service_get gets a service configuration file
// name: the name of the service to get
pub fn (mut c Client) service_get(name string) !ServiceConfigResponse {

	request := jsonrpc.new_request_generic('service_get', {"name":name})
	
	// We need to handle the conversion from ServiceConfig to ServiceConfigResponse
	config := c.rpc_client.send[map[string]string, ServiceConfig](request)!
	
	return ServiceConfigResponse{
		exec: config.exec
		oneshot: config.oneshot
		after: config.after
		log: config.log
		env: config.env
		shutdown_timeout: config.shutdown_timeout
	}
}
