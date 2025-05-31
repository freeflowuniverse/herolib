# Zinit OpenRPC Client

This is a V language client for the Zinit service manager, implementing the OpenRPC specification.

## Overview

Zinit is a service manager that allows you to manage and monitor services on your system. This client provides a comprehensive API to interact with Zinit via its JSON-RPC interface.

## Features

- Complete implementation of all methods in the Zinit OpenRPC specification
- Type-safe API with proper error handling
- Comprehensive documentation
- Helper functions for common operations
- Example code for all operations

## Usage

### Basic Example

```v
import freeflowuniverse.heroweb.clients.zinit

fn main() {
    // Create a new client with the default socket path
    mut client := zinit.new_default_client()
    
    // List all services
    services := client.service_list() or {
        println('Error: ${err}')
        return
    }
    
    // Print the services
    for name, state in services {
        println('${name}: ${state}')
    }
    
    // Get status of a specific service
    if services.len > 0 {
        service_name := services.keys()[0]
        status := client.service_status(service_name) or {
            println('Error: ${err}')
            return
        }
        
        println('Service: ${status.name}')
        println('State: ${status.state}')
        println('PID: ${status.pid}')
    }
}
```

### Creating and Managing Services

```v
import freeflowuniverse.heroweb.clients.zinit

fn main() {
    mut client := zinit.new_default_client()
    
    // Create a new service configuration
    config := zinit.ServiceConfig{
        exec: '/bin/echo "Hello, World!"'
        oneshot: true
        log: zinit.log_stdout
        env: {
            'ENV_VAR': 'value'
        }
    }
    
    // Create the service
    client.service_create('hello', config) or {
        println('Error creating service: ${err}')
        return
    }
    
    // Start the service
    client.service_start('hello') or {
        println('Error starting service: ${err}')
        return
    }
    
    // Get the service logs
    logs := client.stream_current_logs('hello') or {
        println('Error getting logs: ${err}')
        return
    }
    
    for log in logs {
        println(log)
    }
    
    // Clean up
    client.service_stop('hello') or {}
    client.service_forget('hello') or {}
    client.service_delete('hello') or {}
}
```

## API Reference

### Client Creation

- `new_client(socket_path string) &Client` - Create a new client with a custom socket path
- `new_default_client() &Client` - Create a new client with the default socket path (`/tmp/zinit.sock`)

### Service Management

- `service_list() !map[string]string` - List all services and their states
- `service_status(name string) !ServiceStatus` - Get detailed status of a service
- `service_start(name string) !` - Start a service
- `service_stop(name string) !` - Stop a service
- `service_monitor(name string) !` - Start monitoring a service
- `service_forget(name string) !` - Stop monitoring a service
- `service_kill(name string, signal string) !` - Send a signal to a service
- `service_create(name string, config ServiceConfig) !string` - Create a new service
- `service_delete(name string) !string` - Delete a service
- `service_get(name string) !ServiceConfig` - Get a service configuration
- `service_stats(name string) !ServiceStats` - Get memory and CPU usage statistics

### System Operations

- `system_shutdown() !` - Stop all services and power off the system
- `system_reboot() !` - Stop all services and reboot the system
- `system_start_http_server(address string) !string` - Start an HTTP/RPC server
- `system_stop_http_server() !` - Stop the HTTP/RPC server

### Logs

- `stream_current_logs(name ?string) ![]string` - Get current logs
- `stream_subscribe_logs(name ?string) !string` - Subscribe to log messages

## Constants

- `default_socket_path` - Default Unix socket path (`/tmp/zinit.sock`)
- `state_running`, `state_success`, `state_error`, etc. - Common service states
- `target_up`, `target_down` - Common service targets
- `log_null`, `log_ring`, `log_stdout` - Common log types
- `signal_term`, `signal_kill`, etc. - Common signals

## Helper Functions

- `new_service_config(exec string) ServiceConfig` - Create a basic service configuration
- `new_oneshot_service_config(exec string) ServiceConfig` - Create a oneshot service configuration
- `is_service_not_found_error(err IError) bool` - Check if an error is a "service not found" error
- `format_memory_usage(bytes i64) string` - Format memory usage in human-readable format
- `format_cpu_usage(cpu_percent f64) string` - Format CPU usage

## License

MIT