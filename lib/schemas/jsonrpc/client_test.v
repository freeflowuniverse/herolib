module jsonrpc

import time

struct TestRPCTransportClient {}

fn (t TestRPCTransportClient) send(request_json string, params SendParams) !string {
	request := decode_request(request_json)!

	// instead of sending request and returning response from rpc server
	// our test rpc transport client return a response
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

struct TestClient {
	Client
}

fn test_new() {
	client := new_client(
		transport: TestRPCTransportClient{}
	)
}

fn test_send_json_rpc() {
	mut client := new_client(
		transport: TestRPCTransportClient{}
	)

	request0 := new_request_generic[string]('echo', 'ECHO!')
	response0 := client.send[string, string](request0)!
	assert response0 == 'ECHO!'

	request1 := new_request_generic[string]('test_error', '')
	if response1 := client.send[string, string](request1) {
		assert false, 'Should return internal error'
	} else {
		assert err is RPCError
		assert err.code() == 1
		assert err.msg() == 'intentional jsonrpc error response'
	}
	
	request2 := new_request_generic[string]('nonexistent_method', '')
	if response2 := client.send[string, string](request2) {
		assert false, 'Should return not found error'
	} else {
		assert err is RPCError
		assert err.code() == 32601
		assert err.msg() == 'Method not found'
	}

	request := new_request_generic[string]('echo', 'ECHO!')
	response := client.send[string, string](request)!
	assert response == 'ECHO!'
}
