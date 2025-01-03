module openrpc

import x.json2
import freeflowuniverse.herolib.schemas.jsonrpc

pub struct Handler {
pub:
	specification OpenRPC @[required] // The OpenRPC specification
pub mut:
    handler IHandler
}

pub interface IHandler {
mut:
	handle(jsonrpc.Request) !jsonrpc.Response // Custom handler for other methods
}

@[params]
pub struct HandleParams {
	timeout int = 60 // Timeout in seconds
	retry   int  // Number of retries
}

// Handle a JSON-RPC request and return a response
pub fn (mut h Handler) handle(req jsonrpc.Request, params HandleParams) !jsonrpc.Response {
	// Validate the incoming request
	req.validate() or {
		return jsonrpc.new_error_response(req.id, jsonrpc.invalid_request)
	}

	// Check if the method exists
	if req.method == 'rpc.discover' {
		// Handle the rpc.discover method
		spec_json := h.specification.encode()!
		return jsonrpc.new_response(req.id, spec_json)
	}

	// Validate the method exists in the specification
	if req.method !in h.specification.methods.map(it.name) {
		return jsonrpc.new_error_response(req.id, jsonrpc.method_not_found)
	}

	// Enforce timeout and retries (dummy implementation)
	if params.timeout < 0 || params.retry < 0 {
		return jsonrpc.new_error_response(req.id, jsonrpc.invalid_params)
	}

	// Forward the request to the custom handler
	return h.handler.handle(req)
}