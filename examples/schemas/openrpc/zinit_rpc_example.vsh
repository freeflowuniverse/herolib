#!/usr/bin/env -S v -n -w -cg -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.schemas.jsonrpc

// Define the service status response structure based on the OpenRPC schema
struct ServiceStatus {
	name string
	pid int
	state string
	target string
	after map[string]string
}

// Create a client using the Unix socket transport
mut cl := jsonrpc.new_unix_socket_client("/tmp/zinit.sock")

// Example 1: List all services
// Create a request for service_list method with empty parameters
list_request := jsonrpc.new_request_generic('service_list', []string{})

// Send the request and receive a map of service names to states
println('Sending service_list request...')
service_list := cl.send[[]string, map[string]string](list_request)!

// Display the service list
println('Service List:')
println(service_list)

// Example 2: Get status of a specific service
// First, check if we have any services to query
if service_list.len > 0 {
	// Get the first service name from the list
	service_name := service_list.keys()[0]
	
	// Create a request for service_status method with the service name as parameter
	// The parameter for service_status is a single string (service name)
	status_request := jsonrpc.new_request_generic('service_status', {"name": service_name})
	
	// Send the request and receive a ServiceStatus object
	println('\nSending service_status request for service: $service_name')
	service_status := cl.send[ map[string]string, ServiceStatus](status_request)!
	
	// Display the service status details
	println('Service Status:')
	println('- Name: ${service_status.name}')
	println('- PID: ${service_status.pid}')
	println('- State: ${service_status.state}')
	println('- Target: ${service_status.target}')
	println('- Dependencies:')
	for dep_name, dep_state in service_status.after {
		println('  - $dep_name: $dep_state')
	}
} else {
	println('\nNo services found to query status')
}

// // Example 3: Alternative approach using a string array for the parameter
// // Some JSON-RPC servers expect parameters as an array, even for a single parameter
// println('\nAlternative approach using array parameter:')
// if service_list.len > 0 {
// 	service_name := service_list.keys()[0]
	
// 	// Create a request with the service name in an array
// 	status_request_alt := jsonrpc.new_request_generic('service_status', service_name)
	
// 	// Send the request and receive a ServiceStatus object
// 	println('Sending service_status request for service: $service_name (array parameter)')
// 	service_status_alt := cl.send[[]string, ServiceStatus](status_request_alt)!
	
// 	// Display the service status details
// 	println('Service Status (alternative):')
// 	println('- Name: ${service_status_alt.name}')
// 	println('- State: ${service_status_alt.state}')
// }
