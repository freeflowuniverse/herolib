module zinit


pub struct ServiceConfigResponse {
pub mut:
	exec             string            // Command to run
	oneshot          bool              // Whether the service should be restarted
	after            []string          // Services that must be running before this one starts
	log              string            // How to handle service output (null, ring, stdout)
	env              map[string]string // Environment variables for the service
	shutdown_timeout int               // Maximum time to wait for service to stop during shutdown
}


// Helper function to create a basic service configuration
pub fn new_service_config(exec string) ServiceConfig {
	return ServiceConfig{
		exec: exec
		oneshot: false
		log: log_stdout
		env: map[string]string{}
		shutdown_timeout: 30
	}
}

// Helper function to create a oneshot service configuration
pub fn new_oneshot_service_config(exec string) ServiceConfig {
	return ServiceConfig{
		exec: exec
		oneshot: true
		log: log_stdout
		env: map[string]string{}
		shutdown_timeout: 30
	}
}
