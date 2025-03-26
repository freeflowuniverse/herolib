module jsonrpc

// Notification represents a JSON-RPC 2.0 notification object.
// It contains all the required fields according to the JSON-RPC 2.0 specification.
// See: https://www.jsonrpc.org/specification#notification
pub struct Notification {
pub mut:
	// The JSON-RPC protocol version, must be exactly "2.0"
	jsonrpc string = '2.0' @[required]

	// The name of the method to be invoked on the server
	method string @[required]
}

// Notification represents a JSON-RPC 2.0 notification object.
// It contains all the required fields according to the JSON-RPC 2.0 specification.
// See: https://www.jsonrpc.org/specification#notification
pub struct NotificationGeneric[T] {
pub mut:
	// The JSON-RPC protocol version, must be exactly "2.0"
	jsonrpc string = '2.0' @[required]

	// The name of the method to be invoked on the server
	method string @[required]
	params ?T
}

// new_notification creates a new JSON-RPC notification with the specified method and parameters.
// It automatically sets the JSON-RPC version to the current version.
//
// Parameters:
//   - method: The name of the method to invoke on the server
//   - params: The parameters to the method, encoded as a JSON string
//
// Returns:
//   - A fully initialized Notification object
pub fn new_notification[T](method string, params T) NotificationGeneric[T] {
	return NotificationGeneric[T]{
		jsonrpc: jsonrpc_version
		method:  method
		params:  params
	}
}

pub fn new_blank_notification(method string) Notification {
	return Notification{
		jsonrpc: jsonrpc_version
		method:  method
	}
}
