module jsonrpc

// This file contains tests for the JSON-RPC handler implementation.
// It tests the handler's ability to process requests, invoke the appropriate procedure,
// and return properly formatted responses.

// method_echo is a simple test method that returns the input text.
// Used to test successful request handling.
//
// Parameters:
//   - text: A string to echo back
//
// Returns:
//   - The same string that was passed in
fn method_echo(text string) !string {
	return text
}

// TestStruct is a simple struct used for testing struct parameter handling.
pub struct TestStruct {
	data string
}

// method_echo_struct is a test method that returns the input struct.
// Used to test handling of complex types in JSON-RPC.
//
// Parameters:
//   - structure: A TestStruct instance to echo back
//
// Returns:
//   - The same TestStruct that was passed in
fn method_echo_struct(structure TestStruct) !TestStruct {
	return structure
}

// method_error is a test method that always returns an error.
// Used to test error handling in the JSON-RPC flow.
//
// Parameters:
//   - text: A string (not used)
//
// Returns:
//   - Always returns an error
fn method_error(text string) !string {
	return error('some error')
}

// method_echo_handler is a procedure handler for the method_echo function.
// It decodes the request, calls method_echo, and encodes the response.
//
// Parameters:
//   - data: The JSON-RPC request as a string
//
// Returns:
//   - A JSON-encoded response string
fn method_echo_handler(data string) !string {
	// Decode the request with string parameters
	request := decode_request_generic[string](data)!
	
	// Call the echo method and handle any errors
	result := method_echo(request.params) or {
		// If an error occurs, create an error response
		response := new_error_response(request.id,
			code: err.code()
			message: err.msg()
		)
		return response.encode()
	}
	
	// Create a success response with the result
	response := new_response_generic(request.id, result)
	return response.encode()
}

// method_echo_struct_handler is a procedure handler for the method_echo_struct function.
// It demonstrates handling of complex struct types in JSON-RPC.
//
// Parameters:
//   - data: The JSON-RPC request as a string
//
// Returns:
//   - A JSON-encoded response string
fn method_echo_struct_handler(data string) !string {
	// Decode the request with TestStruct parameters
	request := decode_request_generic[TestStruct](data)!
	
	// Call the echo struct method and handle any errors
	result := method_echo_struct(request.params) or {
		// If an error occurs, create an error response
		response := new_error_response(request.id,
			code: err.code()
			message: err.msg()
		)
		return response.encode()
	}
	
	// Create a success response with the struct result
	response := new_response_generic[TestStruct](request.id, result)
	return response.encode()
}

// method_error_handler is a procedure handler for the method_error function.
// It demonstrates error handling in JSON-RPC procedure handlers.
//
// Parameters:
//   - data: The JSON-RPC request as a string
//
// Returns:
//   - A JSON-encoded error response string
fn method_error_handler(data string) !string {
	// Decode the request with string parameters
	request := decode_request_generic[string](data)!
	
	// Call the error method, which always returns an error
	result := method_error(request.params) or {
		// Create an error response with the error details
		response := new_error_response(request.id,
			code: err.code()
			message: err.msg()
		)
		return response.encode()
	}
	
	// This code should never be reached since method_error always returns an error
	response := new_response_generic(request.id, result)
	return response.encode()
}

// test_new tests the creation of a new JSON-RPC handler.
fn test_new() {
	// Create a new handler with no procedures
	handler := new_handler(Handler{})!
}

// test_handle tests the handler's ability to process different types of requests.
// It tests three scenarios:
// 1. A successful string echo request
// 2. A successful struct echo request
// 3. A request that results in an error
fn test_handle() {
	// Create a new handler with three test procedures
	handler := new_handler(Handler{
		procedures: {
			'method_echo': method_echo_handler
			'method_echo_struct': method_echo_struct_handler
			'method_error': method_error_handler
		}
	})!

	// Test case 1: String echo request
	params0 := 'ECHO!'
	request0 := new_request_generic[string]('method_echo', params0)
	decoded0 := handler.handle(request0.encode())!
	response0 := decode_response_generic[string](decoded0)!
	assert response0.result()! == params0

	// Test case 2: Struct echo request
	params1 := TestStruct{'ECHO!'}
	request1 := new_request_generic[TestStruct]('method_echo_struct', params1)
	decoded1 := handler.handle(request1.encode())!
	response1 := decode_response_generic[TestStruct](decoded1)!
	assert response1.result()! == params1

	// Test case 3: Error request
	params2 := 'ECHO!'
	request2 := new_request_generic[string]('method_error', params2)
	decoded2 := handler.handle(request2.encode())!
	response2 := decode_response_generic[string](decoded2)!
	assert response2.is_error()
	assert response2.error()?.message == 'some error'
}
