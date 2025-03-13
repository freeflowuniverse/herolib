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
import jsonrpc

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
import jsonrpc

// Define a request method and parameters
params := YourParams{...}
request := jsonrpc.new_request_generic('methodName', params)

// Configure send parameters
send_params := jsonrpc.SendParams{
    timeout: 30
    retry: 3
}

// Send the request and process the response
response := client.send[YourParams, YourResult](request, send_params) or {
    eprintln('Error sending request: $err')
    return
}

println('Response result: $response')
```

### 3. **Handling Errors**

Use the predefined JSON-RPC errors or create custom ones.

```v
import jsonrpc

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

## Modules and Key Components

### 1. **`model_request.v`**
Handles JSON-RPC requests:
- Structs: `Request`, `RequestGeneric`
- Methods: `new_request`, `new_request_generic`, `decode_request`, etc.

### 2. **`model_response.v`**
Handles JSON-RPC responses:
- Structs: `Response`, `ResponseGeneric`
- Methods: `new_response`, `new_response_generic`, `decode_response`, `validate`, etc.

### 3. **`model_error.v`**
Manages JSON-RPC errors:
- Struct: `RPCError`
- Predefined errors: `parse_error`, `invalid_request`, etc.
- Methods: `msg`, `is_empty`, etc.

### 4. **`client.v`**
Implements the JSON-RPC client:
- Structs: `Client`, `SendParams`, `ClientConfig`
- Interface: `IRPCTransportClient`
- Method: `send`

---

## JSON-RPC Specification Reference

This module adheres to the [JSON-RPC 2.0 specification](https://www.jsonrpc.org/specification).
