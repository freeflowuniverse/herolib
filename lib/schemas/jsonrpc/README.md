# JSON-RPC Module

This module provides a robust implementation of the JSON-RPC 2.0 protocol in VLang. It includes utilities for creating, sending, and handling JSON-RPC requests and responses, with support for custom transports, strong typing, and error management.

---

## Features

- **Request and Response Handling**:
  - Create and encode JSON-RPC requests (generic or non-generic).
  - Decode and validate JSON-RPC responses.
  - Manage custom parameters and IDs for requests.
  
- **Error Management**:
  - Predefined JSON-RPC errors based on the official specification.
  - Support for custom error creation and validation.

- **Generic Support**:
  - Strongly typed request and response handling using generics.
  
- **Customizable Transport**:
  - Pluggable transport client interface for flexibility (e.g., WebSocket, HTTP).

---

## Usage

### 1. **Client Setup**

Create a new JSON-RPC client using a custom transport layer.

```v
import freeflowuniverse.herolib.schemas.jsonrpc

// Implement the IRPCTransportClient interface for your transport (e.g., WebSocket)
struct WebSocketTransport {
    // Add your transport-specific implementation here
}

// Create a new JSON-RPC client
mut client := jsonrpc.new_client(jsonrpc.Client{
    transport: WebSocketTransport{}
})
```

### 2. **Sending a Request**

Send a strongly-typed JSON-RPC request and handle the response.

```v
import freeflowuniverse.herolib.schemas.jsonrpc

// Define your parameter and result types
struct UserParams {
    id int
    include_details bool
}

struct UserResult {
    name string
    email string
    role string
}

// Create a strongly-typed request with generic parameters
params := UserParams{
    id: 123
    include_details: true
}
request := jsonrpc.new_request_generic('getUser', params)

// Configure send parameters
send_params := jsonrpc.SendParams{
    timeout: 30
    retry: 3
}

// Send the request and receive a strongly-typed response
// The generic types [UserParams, UserResult] ensure type safety for both request and response
user := client.send[UserParams, UserResult](request, send_params) or {
    eprintln('Error sending request: $err')
    return
}

// Access the strongly-typed result fields directly
println('User name: ${user.name}, email: ${user.email}, role: ${user.role}')
```

### 3. **Handling Errors**

Use the predefined JSON-RPC errors or create custom ones.

```v
import freeflowuniverse.herolib.schemas.jsonrpc

// Predefined error
err := jsonrpc.method_not_found

// Custom error
custom_err := jsonrpc.RPCError{
    code: 12345
    message: 'Custom error message'
    data: 'Additional details'
}

// Attach the error to a response
response := jsonrpc.new_error('request_id', custom_err)
println(response)
```

---

### 4. **Working with Generic Responses**

The JSON-RPC module provides strong typing for responses using generics, allowing you to define the exact structure of your expected results.

```v
import freeflowuniverse.herolib.schemas.jsonrpc

// Define your result type
struct ServerStats {
    cpu_usage f64
    memory_usage f64
    uptime int
    active_connections int
}

// Create a request (with or without parameters)
request := jsonrpc.new_request('getServerStats', '{}')

// Decode a response directly to your type
response_json := '{"jsonrpc":"2.0","result":{"cpu_usage":45.2,"memory_usage":62.7,"uptime":86400,"active_connections":128},"id":1}'
response := jsonrpc.decode_response_generic[ServerStats](response_json) or {
    eprintln('Failed to decode response: $err')
    return
}

// Access the strongly-typed result
if !response.is_error() {
    stats := response.result() or {
        eprintln('Error getting result: $err')
        return
    }
    
    println('Server stats:')
    println('- CPU: ${stats.cpu_usage}%')
    println('- Memory: ${stats.memory_usage}%')
    println('- Uptime: ${stats.uptime} seconds')
    println('- Connections: ${stats.active_connections}')
}
```

### 5. **Creating Generic Responses**

When implementing a JSON-RPC server, you can create strongly-typed responses:

```v
import freeflowuniverse.herolib.schemas.jsonrpc

// Define a result type
struct SearchResult {
    total_count int
    items []string
    page int
    page_size int
}

// Create a response with a strongly-typed result
result := SearchResult{
    total_count: 157
    items: ['item1', 'item2', 'item3']
    page: 1
    page_size: 3
}

// Create a generic response with the strongly-typed result
response := jsonrpc.new_response_generic(1, result)

// Encode the response to send it
json := response.encode()
println(json)
// Output: {"jsonrpc":"2.0","id":1,"result":{"total_count":157,"items":["item1","item2","item3"],"page":1,"page_size":3}}
```

## Modules and Key Components

### 1. **`model_request.v`**
Handles JSON-RPC requests:
- Structs: `Request`, `RequestGeneric[T]`
- Methods: `new_request`, `new_request_generic[T]`, `decode_request`, `decode_request_generic[T]`, etc.

### 2. **`model_response.v`**
Handles JSON-RPC responses:
- Structs: `Response`, `ResponseGeneric[D]`
- Methods: `new_response`, `new_response_generic[D]`, `decode_response`, `decode_response_generic[D]`, `validate`, etc.

### 3. **`model_error.v`**
Manages JSON-RPC errors:
- Struct: `RPCError`
- Predefined errors: `parse_error`, `invalid_request`, etc.
- Methods: `msg`, `is_empty`, etc.

### 4. **`client.v`**
Implements the JSON-RPC client:
- Structs: `Client`, `SendParams`, `ClientConfig`
- Interface: `IRPCTransportClient`
- Method: `send[T, D]` - Generic method for sending requests with parameters of type T and receiving responses with results of type D

---

## JSON-RPC Specification Reference

This module adheres to the [JSON-RPC 2.0 specification](https://www.jsonrpc.org/specification).
