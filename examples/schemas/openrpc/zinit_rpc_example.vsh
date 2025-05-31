#!/usr/bin/env -S v -n -w -cg -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.schemas.jsonrpc

mut cl:=jsonrpc.new_unix_socket_client("/tmp/zinit.sock")


send_params := jsonrpc.SendParams{
	timeout: 30
	retry: 1
}
//[]string{} = T is the generic type for the request, which can be any type
request := jsonrpc.new_request_generic('service_list', []string{})

// send sends a JSON-RPC request with parameters of type T and expects a response with result of type D.
// This method handles the full request-response cycle including validation and error handling.
//
// Type Parameters:
//   - T: The type of the request parameters
//   - D: The expected type of the response result
//
// Parameters:
//   - request: The JSON-RPC request object with parameters of type T
//   - params: Configuration parameters for the send operation
//
// Returns:
//   - The response result of type D or an error if any step in the process fails
// pub fn (mut c Client) send[T, D](request RequestGeneric[T], params SendParams) !D {
result := cl.send[[]string, map[string]string](request, send_params)!

// println('Service List:')
// for service in result {
// 	println(service)
// }



// user := client.send[UserParams, UserResult](request, send_params) or {
//     eprintln('Error sending request: $err')
//     return
// }
