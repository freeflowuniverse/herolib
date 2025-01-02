module jsonrpc

import x.json2
import rand

// Represents a JSON-RPC request with essential fields.
pub struct Request {
pub mut:
	jsonrpc string @[required] // JSON-RPC version, e.g., "2.0"
	method  string @[required] // Method to invoke
	params  string @[required] // JSON-encoded parameters
	id      string @[required] // Unique request ID
}

// Creates a new JSON-RPC request with the specified method and parameters.
pub fn new_request(method string, params string) Request {
	return Request{
		jsonrpc: jsonrpc.jsonrpc_version
		method: method
		params: params
		id: rand.uuid_v4() // Automatically generate a unique ID
	}
}

// Decodes a JSON string into a `Request` object.
pub fn decode_request(data string) !Request {
	return json2.decode[Request](data)!
}

// Encodes the `Request` object into a JSON string.
pub fn (req Request) encode() string {
	return json2.encode(req)
}

// A generic JSON-RPC request struct allowing strongly-typed parameters.
pub struct RequestGeneric[T] {
pub mut:
	jsonrpc string @[required]
	method  string @[required]
	params  T      @[required]
	id      string @[required]
}

// Creates a new generic JSON-RPC request.
pub fn new_request_generic[T](method string, params T) RequestGeneric[T] {
	return RequestGeneric[T]{
		jsonrpc: jsonrpc.jsonrpc_version
		method: method
		params: params
		id: rand.uuid_v4()
	}
}

// Extracts the `id` field from a JSON string.
// Returns an error if the field is missing.
pub fn decode_request_id(data string) !string {
	data_any := json2.raw_decode(data)!
	data_map := data_any.as_map()
	id_any := data_map['id'] or { return error('ID field not found') }
	return id_any.str()
}

// Extracts the `method` field from a JSON string.
// Returns an error if the field is missing.
pub fn decode_request_method(data string) !string {
	data_any := json2.raw_decode(data)!
	data_map := data_any.as_map()
	method_any := data_map['method'] or { return error('Method field not found') }
	return method_any.str()
}

// Decodes a JSON string into a generic `Request` object.
pub fn decode_request_generic[T](data string) !RequestGeneric[T] {
	return json2.decode[RequestGeneric[T]](data)!
}

// Encodes a generic `Request` object into a JSON string.
pub fn (req RequestGeneric[T]) encode[T]() string {
	return json2.encode(req)
}