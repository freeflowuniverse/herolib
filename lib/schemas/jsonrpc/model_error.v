module jsonrpc

// Predefined JSON-RPC errors as per the specification: https://www.jsonrpc.org/specification
pub const parse_error = RPCError{
	code: 32700
	message: 'Parse error'
	data: 'Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text.'
}
pub const invalid_request = RPCError{
	code: 32600
	message: 'Invalid Request'
	data: 'The JSON sent is not a valid Request object.'
}
pub const method_not_found = RPCError{
	code: 32601
	message: 'Method not found'
	data: 'The method does not exist / is not available.'
}
pub const invalid_params = RPCError{
	code: 32602
	message: 'Invalid params'
	data: 'Invalid method parameter(s).'
}
pub const internal_error = RPCError{
	code: 32603
	message: 'Internal RPCError'
	data: 'Internal JSON-RPC error.'
}

// Represents a JSON-RPC error object with a code, message, and optional data.
pub struct RPCError {
pub mut:
	code    int    // Error code indicating the type of error
	message string // Brief error description
	data    string // Additional details about the error
}

// Creates a new error response for a given request ID.
pub fn new_error(id string, error RPCError) Response {
	return Response{
		jsonrpc: jsonrpc_version
		error_: error
		id: id
	}
}

// Returns the error message.
pub fn (err RPCError) msg() string {
	return err.message
}

// Returns the error code.
pub fn (err RPCError) code() int {
	return err.code
}

// Checks if the error object is empty (i.e., uninitialized).
pub fn (err RPCError) is_empty() bool {
	return err.code == 0
}