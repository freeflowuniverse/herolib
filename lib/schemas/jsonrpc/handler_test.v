module jsonrpc

// echo method for testing purposes
fn method_echo(text string) !string {
	return text
}

pub struct TestStruct {
	data string
}

// structure echo method for testing purposes
fn method_echo_struct(structure TestStruct) !TestStruct {
	return structure
}

// method that returns error for testing purposes
fn method_error(text string) !string {
	return error('some error')
}

fn method_echo_handler(data string) !string {
	request := decode_request_generic[string](data)!
	result := method_echo(request.params) or {
		response := new_error_response(request.id,
			code: err.code()
			message: err.msg()
		)
		return response.encode()
	}
	response := new_response_generic(request.id, result)
	return response.encode()
}

fn method_echo_struct_handler(data string) !string {
	request := decode_request_generic[TestStruct](data)!
	result := method_echo_struct(request.params) or {
		response := new_error_response(request.id,
			code: err.code()
			message: err.msg()
		)
		return response.encode()
	}
	response := new_response_generic[TestStruct](request.id, result)
	return response.encode()
}

fn method_error_handler(data string) !string {
	request := decode_request_generic[string](data)!
	result := method_error(request.params) or {
		response := new_error_response(request.id,
			code: err.code()
			message: err.msg()
		)
		return response.encode()
	}
	response := new_response_generic(request.id, result)
	return response.encode()
}

fn test_new() {
	handler := new_handler(Handler{})!
}

fn test_handle() {
	handler := new_handler(Handler{
		procedures: {
			'method_echo': method_echo_handler
			'method_echo_struct': method_echo_struct_handler
			'method_error': method_error_handler
		}
	})!

	params0 := 'ECHO!'
	request0 := new_request_generic[string]('method_echo', params0)
	decoded0 := handler.handle(request0.encode())!
	response0 := decode_response_generic[string](decoded0)!
	assert response0.result()! == params0

	params1 := TestStruct{'ECHO!'}
	request1 := new_request_generic[TestStruct]('method_echo_struct', params1)
	decoded1 := handler.handle(request1.encode())!
	response1 := decode_response_generic[TestStruct](decoded1)!
	assert response1.result()! == params1

	params2 := 'ECHO!'
	request2 := new_request_generic[string]('method_error', params2)
	decoded2 := handler.handle(request2.encode())!
	response2 := decode_response_generic[string](decoded2)!
	assert response2.is_error()
	assert response2.error()?.message == 'some error'
}
