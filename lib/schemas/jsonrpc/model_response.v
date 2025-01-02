module jsonrpc

import x.json2
import json

// The JSON-RPC version used for responses.
const jsonrpc_version = '2.0'

// Represents a JSON-RPC response, which includes a result, an error, or both.
pub struct Response {
pub:
	jsonrpc string @[required]  // JSON-RPC version, e.g., "2.0"
	result  ?string // JSON-encoded result (optional)
	error_   ?RPCError @[json: 'error'] // Error object if the request failed (optional)
	id      string @[required]  // Matches the request ID
}

// Creates a successful response with the given result.
pub fn new_response(id string, result string) Response {
	return Response{
		jsonrpc: jsonrpc.jsonrpc_version
		result: result
		id: id
	}
}

// Creates an error response with the given error object.
pub fn new_error_response(id string, error RPCError) Response {
	return Response{
		jsonrpc: jsonrpc.jsonrpc_version
		error_: error
		id: id
	}
}

// Decodes a JSON string into a `Response` object.
pub fn decode_response(data string) !Response {
	raw := json2.raw_decode(data)!
	raw_map := raw.as_map()

	if 'error' !in raw_map.keys() && 'result' !in raw_map.keys() {
		return error('Invalid JSONRPC response, no error and result found.')
	} else if 'error' in raw_map.keys() && 'result' in raw_map.keys() {
		return error('Invalid JSONRPC response, both error and result found.')
	}

	if err := raw_map['error'] {
		id_any := raw_map['id'] or {return error('Invalid JSONRPC response, no ID Field found')}
		return Response {
			id: id_any.str()
			jsonrpc: jsonrpc_version
			error_: json2.decode[RPCError](err.str())!
		}
	}

	return Response {
		id: raw_map['id'] or {return error('Invalid JSONRPC response, no ID Field found')}.str()
		jsonrpc: jsonrpc_version
		result: raw_map['result']!.str()
	}
}

// Encodes the `Response` object into a JSON string.
pub fn (resp Response) encode() string {
	return json2.encode(resp)
}

// Validates that the response does not contain both `result` and `error`.
pub fn (resp Response) validate() ! {
	// if err := resp.error_ && resp.result != '' {
	// 	return error('Response contains both error and result.\n- Error: ${resp.error_.str()}\n- Result: ${resp.result}')
	// }
}

// Returns the error if present in the response.
pub fn (resp Response) is_error() bool {
	return resp.error_ != none
}

// Returns the error if present in the response.
pub fn (resp Response) is_result() bool {
	return resp.result != none
}

// Returns the error if present in the response.
pub fn (resp Response) error() ?RPCError {
	if err := resp.error_ {
		return err
	}
	return none
}

// Returns the result if no error is present.
pub fn (resp Response) result() !string {
	if err := resp.error() {
		return err
	} // Ensure no error is present
	return resp.result or {''}
}

// A generic JSON-RPC response, allowing strongly-typed results.
pub struct ResponseGeneric[D] {
pub mut:
	jsonrpc string @[required]
	result  ?D
	error_  ?RPCError @[json: 'error'] // Error object if the request failed (optional)
	id      string @[required]
}

// Creates a successful generic response with the given result.
pub fn new_response_generic[D](id string, result D) ResponseGeneric[D] {
	return ResponseGeneric[D]{
		jsonrpc: jsonrpc.jsonrpc_version
		result: result
		id: id
	}
}

// Decodes a JSON string into a generic `ResponseGeneric` object.
pub fn decode_response_generic[D](data string) !ResponseGeneric[D] {
	println('respodata ${data}')
	raw := json2.raw_decode(data)!
	raw_map := raw.as_map()

	if 'error' !in raw_map.keys() && 'result' !in raw_map.keys() {
		return error('Invalid JSONRPC response, no error and result found.')
	} else if 'error' in raw_map.keys() && 'result' in raw_map.keys() {
		return error('Invalid JSONRPC response, both error and result found.')
	}

	if err := raw_map['error'] {
		return ResponseGeneric[D] {
			id: raw_map['id'] or {return error('Invalid JSONRPC response, no ID Field found')}.str()
			jsonrpc: jsonrpc_version
			error_: json2.decode[RPCError](err.str())!
		}
	}

	resp := json.decode(ResponseGeneric[D], data)!
	return ResponseGeneric[D] {
		id: raw_map['id'] or {return error('Invalid JSONRPC response, no ID Field found')}.str()
		jsonrpc: jsonrpc_version
		result: resp.result
	}
}

// Encodes the generic `ResponseGeneric` object into a JSON string.
pub fn (resp ResponseGeneric[D]) encode() string {
	return json2.encode(resp)
}

// Validates that the generic response does not contain both `result` and `error`.
pub fn (resp ResponseGeneric[D]) validate() ! {
	if resp.is_error() && resp.is_result() {
		return error('Response contains both error and result.\n- Error: ${resp.error.str()}\n- Result: ${resp.result}')
	}
}

// Returns the error if present in the response.
pub fn (resp ResponseGeneric[D]) is_error() bool {
	return resp.error_ != none
}

// Returns the error if present in the response.
pub fn (resp ResponseGeneric[D]) is_result() bool {
	return resp.result != none
}


// Returns the error if present in the generic response.
pub fn (resp ResponseGeneric[D]) error() ?RPCError {
	return resp.error_?
}

// Returns the result if no error is present in the generic response.
pub fn (resp ResponseGeneric[D]) result() !D {
	if err := resp.error() {
		return err
	} // Ensure no error is present
	return resp.result or {D{}}
}