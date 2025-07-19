module zinit

import freeflowuniverse.herolib.schemas.jsonrpc

// ServiceStatsResponse represents the response from service_stats
pub struct ServiceStatsResponse {
pub mut:
	name         string               // Service name
	pid          int                  // Process ID of the service
	memory_usage i64                  // Memory usage in bytes
	cpu_usage    f64                  // CPU usage as a percentage (0-100)
	children     []ChildStatsResponse // Stats for child processes
}

// ChildStatsResponse represents statistics for a child process
pub struct ChildStatsResponse {
pub mut:
	pid          int // Process ID of the child process
	memory_usage i64 // Memory usage in bytes
	cpu_usage    f64 // CPU usage as a percentage (0-100)
}

// Serv

// service_stats gets memory and CPU usage statistics for a service
// name: the name of the service to get stats for
pub fn (mut c Client) service_stats(name string) !ServiceStatsResponse {
	request := jsonrpc.new_request_generic('service_stats', name)

	// We need to handle the conversion from the raw response to our model
	raw_stats := c.rpc_client.send[string, map[string]string](request)!

	// Parse the raw stats into our response model
	mut children := []ChildStatsResponse{}
	// In a real implementation, we would parse the children from the raw response

	return ServiceStatsResponse{
		name:         raw_stats['name'] or { '' }
		pid:          raw_stats['pid'].int()
		memory_usage: raw_stats['memory_usage'].i64()
		cpu_usage:    raw_stats['cpu_usage'].f64()
		children:     children
	}
}
