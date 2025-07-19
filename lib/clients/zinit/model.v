module zinit

// ServiceCreateResponse represents the response from service_create
pub struct ServiceCreateResponse {
pub mut:
	path string // Path to the created service file
}

// ServiceDeleteResponse represents the response from service_delete
pub struct ServiceDeleteResponse {
pub mut:
	result string // Result of the delete operation
}

// SystemStartHttpServerResponse represents the response from system_start_http_server
pub struct SystemStartHttpServerResponse {
pub mut:
	result string // Result of starting the HTTP server
}

// StreamCurrentLogsResponse represents the response from stream_currentLogs
pub struct StreamCurrentLogsResponse {
pub mut:
	logs []string // Log entries
}

// StreamSubscribeLogsResponse represents the response from stream_subscribeLogs
pub struct StreamSubscribeLogsResponse {
pub mut:
	subscription_id string // ID of the log subscription
}

// Module version information
pub const version = '1.0.0'
pub const author = 'Hero Code'
pub const license = 'MIT'

// Default socket path for zinit
pub const default_socket_path = '/tmp/zinit.sock'

// Common service states
pub const state_running = 'Running'
pub const state_success = 'Success'
pub const state_error = 'Error'
pub const state_stopped = 'Stopped'
pub const state_failed = 'Failed'

// Common service targets
pub const target_up = 'Up'
pub const target_down = 'Down'

// Common log types
pub const log_null = 'null'
pub const log_ring = 'ring'
pub const log_stdout = 'stdout'

// Common signals
pub const signal_term = 'SIGTERM'
pub const signal_kill = 'SIGKILL'
pub const signal_hup = 'SIGHUP'
pub const signal_usr1 = 'SIGUSR1'
pub const signal_usr2 = 'SIGUSR2'

// JSON-RPC error codes as defined in the OpenRPC specification
pub const error_service_not_found = -32000
pub const error_service_already_monitored = -32001
pub const error_service_is_up = -32002
pub const error_service_is_down = -32003
pub const error_invalid_signal = -32004
pub const error_config_error = -32005
pub const error_shutting_down = -32006
pub const error_service_already_exists = -32007
pub const error_service_file_error = -32008
