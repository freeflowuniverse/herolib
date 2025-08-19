module jsonrpc

import net.websocket

// This file implements a JSON-RPC 2.0 handler for WebSocket servers.
// It provides functionality to register procedure handlers and process incoming JSON-RPC requests.

// Handler is a JSON-RPC request handler that maps method names to their corresponding procedure handlers.
// It can be used with a WebSocket server to handle incoming JSON-RPC requests.
pub struct Handler {
pub mut:
	// A map where keys are method names and values are the corresponding procedure handler functions
	procedures map[string]ProcedureHandler
}

// ProcedureHandler is a function type that processes a JSON-RPC request payload and returns a response.
// The function should:
// 1. Decode the payload to extract parameters
// 2. Execute the procedure with the extracted parameters
// 3. Return the result as a JSON-encoded string
// If an error occurs during any of these steps, it should be returned.
pub type ProcedureHandler = fn (payload string) !string

// new_handler creates a new JSON-RPC handler with the specified procedure handlers.
//
// Parameters:
//   - handler: A Handler struct with the procedures field initialized
//
// Returns:
//   - A pointer to a new Handler instance or an error if creation fails
pub fn new_handler(handler Handler) !&Handler {
	return &Handler{
		...handler
	}
}

// register_procedure registers a new procedure handler for the specified method.
//
// Parameters:
//   - method: The name of the method to register
//   - procedure: The procedure handler function to register
pub fn (mut handler Handler) register_procedure(method string, procedure ProcedureHandler) {
	handler.procedures[method] = procedure
}

// handler is a callback function compatible with the WebSocket server's message handler interface.
// It processes an incoming WebSocket message as a JSON-RPC request and returns the response.
//
// Parameters:
//   - client: The WebSocket client that sent the message
//   - message: The JSON-RPC request message as a string
//
// Returns:
//   - The JSON-RPC response as a string
// Note: This method panics if an error occurs during handling
pub fn (handler Handler) handler(client &websocket.Client, message string) string {
	return handler.handle(message) or { panic(err) }
}

// handle processes a JSON-RPC request message and invokes the appropriate procedure handler.
// If the requested method is not found, it returns a method_not_found error response.
//
// Parameters:
//   - message: The JSON-RPC request message as a string
//
// Returns:
//   - The JSON-RPC response as a string, or an error if processing fails
pub fn (handler Handler) handle(message string) !string {
	// Extract the method name from the request
	method := decode_request_method(message)!
	// log.info('Handling remote procedure call to method: ${method}')
	// Look up the procedure handler for the requested method
	procedure_func := handler.procedures[method] or {
		// log.error('No procedure handler for method ${method} found')
		return method_not_found
	}

	// Execute the procedure handler with the request payload
	response := procedure_func(message) or { panic(err) }
	return response
}
