module jsonrpc

import time

// This file contains tests for the JSON-RPC client implementation.
// It uses a mock transport client to simulate JSON-RPC server responses without requiring an actual server.

// TestRPCTransportClient is a mock implementation of the RPCTransport interface.
// It simulates a JSON-RPC server by returning predefined responses based on the method name.
struct TestRPCTransportClient {}

// send implements the RPCTransport interface's send method.
// Instead of sending the request to a real server, it decodes the request and returns
// a predefined response based on the method name.
//
// Parameters:
//   - request_json: The JSON-RPC request as a JSON string
//   - params: Additional parameters for sending the request
//
// Returns:
//   - A JSON-encoded response string or an error if decoding fails
fn (t TestRPCTransportClient) send(request_json string, params SendParams) !string {
	// Decode the incoming request to determine which response to return
	request := decode_request(request_json)!

	// Return different responses based on the method name:
	// - 'echo': Returns the params as the result
	// - 'test_error': Returns an error response
	// - anything else: Returns a method_not_found error
	response := if request.method == 'echo' {
		new_response(request.id, request.params)
	} else if request.method == 'test_error' {
		error := RPCError{
			code: 1
			message: 'intentional jsonrpc error response'
		}
		new_error_response(request.id, error)
	} else {
		new_error_response(request.id, method_not_found)
	}
	
	return response.encode()
}

// TestClient extends the Client struct for testing purposes.
struct TestClient {
	Client
}

// test_new tests the creation of a new JSON-RPC client with a mock transport.
fn test_new() {
	// Create a new client with the mock transport
	client := new_client(
		transport: TestRPCTransportClient{}
	)
}

// test_send_json_rpc tests the client's ability to send requests and handle responses.
// It tests three scenarios:
// 1. Successful response from an 'echo' method
// 2. Error response from a 'test_error' method
// 3. Method not found error from a non-existent method
fn test_send_json_rpc() {
	// Create a new client with the mock transport
	mut client := new_client(
		transport: TestRPCTransportClient{}
	)

	// Test case 1: Successful echo response
	request0 := new_request_generic[string]('echo', 'ECHO!')
	response0 := client.send[string, string](request0)!
	assert response0 == 'ECHO!'

	// Test case 2: Error response
	request1 := new_request_generic[string]('test_error', '')
	if response1 := client.send[string, string](request1) {
		assert false, 'Should return internal error'
	} else {
		// Verify the error details
		assert err is RPCError
		assert err.code() == 1
		assert err.msg() == 'intentional jsonrpc error response'
	}
	
	// Test case 3: Method not found error
	request2 := new_request_generic[string]('nonexistent_method', '')
	if response2 := client.send[string, string](request2) {
		assert false, 'Should return not found error'
	} else {
		// Verify the error details
		assert err is RPCError
		assert err.code() == -32601
		assert err.msg() == 'Method not found'
	}

	// Duplicate of test case 1 (can be removed or kept for additional verification)
	request := new_request_generic[string]('echo', 'ECHO!')
	response := client.send[string, string](request)!
	assert response == 'ECHO!'
}
