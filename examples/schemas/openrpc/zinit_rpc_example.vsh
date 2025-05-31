#!/usr/bin/env -S v -n -w -cg -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.schemas.jsonrpc
import json

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

// Example 1: Discover the API using rpc_discover
// Create a request for rpc_discover method with empty parameters
discover_request := jsonrpc.new_request_generic('rpc.discover', []string{})

// Send the request and receive the OpenRPC specification as a JSON string
println('Sending rpc_discover request...')
println('This will return the OpenRPC specification for the API')

// Use map[string]string for the result to avoid json2.Any issues
api_spec_raw := cl.send[[]string, string](discover_request)!

// Parse the JSON string manually
println('API Specification (raw):')
println(api_spec_raw)

// Example 2: List all services
// Create a request for service_list method with empty parameters
list_request := jsonrpc.new_request_generic('service_list', []string{})

// Send the request and receive a map of service names to states
println('\nSending service_list request...')
service_list := cl.send[[]string, map[string]string](list_request)!

// Display the service list
println('Service List:')
println(service_list)

// Example 3: Get status of a specific service
// First, check if we have any services to query
if service_list.len > 0 {
	// Get the first service name from the list
	service_name := service_list.keys()[0]
	
	// Create a request for service_status method with the service name as parameter
	// The parameter for service_status is a single string (service name)
	status_request := jsonrpc.new_request_generic('service_status', service_name)
	
	// Send the request and receive a ServiceStatus object
	println('\nSending service_status request for service: $service_name')
	service_status := cl.send[string, ServiceStatus](status_request)!
	
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
