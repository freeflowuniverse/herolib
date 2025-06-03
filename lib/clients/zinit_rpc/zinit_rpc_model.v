module zinit_rpc

import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.schemas.jsonrpc

pub const version = '0.0.0'
const singleton = true
const default = false

// Default configuration for Zinit JSON-RPC API
pub const default_socket_path = '/tmp/zinit.sock'

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct ZinitRPC {
pub mut:
	name        string = 'default'
	socket_path string = default_socket_path // Unix socket path for RPC server
	rpc_client  ?&jsonrpc.Client @[skip]
}

// your checking & initialization code if needed
fn obj_init(mycfg_ ZinitRPC) !ZinitRPC {
	mut mycfg := mycfg_
	if mycfg.socket_path == '' {
		mycfg.socket_path = default_socket_path
	}
	// For now, we'll initialize the client when needed
	// The actual client will be created in the factory
	return mycfg
}

// Response structs based on OpenRPC specification

// OpenRPCSpec represents the OpenRPC specification structure
pub struct OpenRPCSpec {
pub mut:
	openrpc string          @[json: 'openrpc'] // OpenRPC version
	info    OpenRPCInfo     @[json: 'info']    // API information
	methods []OpenRPCMethod @[json: 'methods'] // Available methods
	servers []OpenRPCServer @[json: 'servers'] // Server information
}

// OpenRPCInfo represents API information
pub struct OpenRPCInfo {
pub mut:
	version     string         @[json: 'version']     // API version
	title       string         @[json: 'title']       // API title
	description string         @[json: 'description'] // API description
	license     OpenRPCLicense @[json: 'license']     // License information
}

// OpenRPCLicense represents license information
pub struct OpenRPCLicense {
pub mut:
	name string @[json: 'name'] // License name
}

// OpenRPCMethod represents an RPC method
pub struct OpenRPCMethod {
pub mut:
	name        string @[json: 'name']        // Method name
	description string @[json: 'description'] // Method description
	// Note: params and result are dynamic and would need more complex handling
}

// OpenRPCServer represents server information
pub struct OpenRPCServer {
pub mut:
	name string @[json: 'name'] // Server name
	url  string @[json: 'url']  // Server URL
}

// ServiceStatus represents detailed status information for a service
pub struct ServiceStatus {
pub mut:
	name   string            @[json: 'name']   // Service name
	pid    u32               @[json: 'pid']    // Process ID of the running service (if running)
	state  string            @[json: 'state']  // Current state of the service (Running, Success, Error, etc.)
	target string            @[json: 'target'] // Target state of the service (Up, Down)
	after  map[string]string @[json: 'after']  // Dependencies of the service and their states
}

// ServiceConfig represents the configuration for a zinit service
pub struct ServiceConfig {
pub mut:
	exec             string            @[json: 'exec']             // Command to run
	test             string            @[json: 'test']             // Test command (optional)
	oneshot          bool              @[json: 'oneshot']          // Whether the service should be restarted (maps to one_shot in Zinit)
	after            []string          @[json: 'after']            // Services that must be running before this one starts
	log              string            @[json: 'log']              // How to handle service output (null, ring, stdout)
	env              map[string]string @[json: 'env']              // Environment variables for the service
	dir              string            @[json: 'dir']              // Working directory for the service
	shutdown_timeout u64               @[json: 'shutdown_timeout'] // Maximum time to wait for service to stop during shutdown
}

// ServiceStats represents memory and CPU usage statistics for a service
pub struct ServiceStats {
pub mut:
	name         string       @[json: 'name']         // Service name
	pid          u32          @[json: 'pid']          // Process ID of the service
	memory_usage u64          @[json: 'memory_usage'] // Memory usage in bytes
	cpu_usage    f32          @[json: 'cpu_usage']    // CPU usage as a percentage (0-100)
	children     []ChildStats @[json: 'children']     // Stats for child processes
}

// ChildStats represents statistics for a child process
pub struct ChildStats {
pub mut:
	pid          u32 @[json: 'pid']          // Process ID of the child process
	memory_usage u64 @[json: 'memory_usage'] // Memory usage in bytes
	cpu_usage    f32 @[json: 'cpu_usage']    // CPU usage as a percentage (0-100)
}

// ServiceCreateParams represents parameters for service_create method
pub struct ServiceCreateParams {
pub mut:
	name    string        @[json: 'name']    // Name of the service to create
	content ServiceConfig @[json: 'content'] // Configuration for the service
}

// ServiceKillParams represents parameters for service_kill method
pub struct ServiceKillParams {
pub mut:
	name   string @[json: 'name']   // Name of the service to kill
	signal string @[json: 'signal'] // Signal to send (e.g., SIGTERM, SIGKILL)
}

// LogParams represents parameters for log streaming methods
@[params]
pub struct LogParams {
pub mut:
	name string // Optional service name filter
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj ZinitRPC) !string {
	return encoderhero.encode[ZinitRPC](obj)!
}

pub fn heroscript_loads(heroscript string) !ZinitRPC {
	mut obj := encoderhero.decode[ZinitRPC](heroscript)!
	return obj
}

// Factory function to create a new ZinitRPC client instance
@[params]
pub struct NewClientArgs {
pub mut:
	name        string = 'default'
	socket_path string = default_socket_path
}

pub fn new_client(args NewClientArgs) !&ZinitRPC {
	mut client := ZinitRPC{
		name:        args.name
		socket_path: args.socket_path
	}
	client = obj_init(client)!
	return &client
}
