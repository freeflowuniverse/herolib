module jsonrpc

fn test_new_response() {
	response := new_response('123', 'test_result')
	assert response.jsonrpc == jsonrpc.jsonrpc_version
	assert response.id == '123'
	
	assert response.is_result()
	assert !response.is_error() // Ensure no error is set
	result := response.result() or {
		assert false, 'Response should have result'
		return
	}
	assert result == 'test_result'
}

fn test_new_error_response() {
	error := RPCError{
		code: 123
		message: 'Test error'
		data: 'Error details'
	}
	response := new_error_response('123', error)
	assert response.jsonrpc == jsonrpc.jsonrpc_version

	response.validate()!
	assert response.is_error()
	assert !response.is_result() // Ensure no result is set
	assert response.id == '123'
	
	response_error := response.error()?
	assert response_error == error
}

fn test_decode_response() {
	data := '{"jsonrpc":"2.0","result":"test_result","id":"123"}'
	response := decode_response(data) or {
		assert false, 'Failed to decode response: $err'
		return
	}
	assert response.jsonrpc == '2.0'
	assert response.id == '123'

	assert response.is_result()
	assert !response.is_error() // Ensure no error is set
	result := response.result() or {
		assert false, 'Response should have result'
		return
	}
	assert result == 'test_result'
}

fn test_response_encode() {
	response := new_response('123', 'test_result')
	json := response.encode()
	assert json.contains('"jsonrpc"') && json.contains('"result"') && json.contains('"id"')
}

fn test_response_validate() {
	response := new_response('123', 'test_result')
	response.validate() or { assert false, 'Validation failed for valid response: $err' }

	error := RPCError{
		code: 123
		message: 'Test error'
		data: 'Error details'
	}
	invalid_response := Response{
		jsonrpc: '2.0'
		result: 'test_result'
		error_: error
		id: '123'
	}
	invalid_response.validate() or {
		assert err.msg().contains('Response contains both error and result.')
	}
}

fn test_response_error() {
	error := RPCError{
		code: 123
		message: 'Test error'
		data: 'Error details'
	}
	response := new_error_response('123', error)
	err := response.error() or {
		assert false, 'Failed to get error: $err'
		return
	}
	assert err.code == 123
	assert err.message == 'Test error'
	assert err.data == 'Error details'
}

fn test_response_result() {
	response := new_response('123', 'test_result')
	result := response.result() or {
		assert false, 'Failed to get result: $err'
		return
	}
	assert result == 'test_result'
}

fn test_new_response_generic() {
	response := new_response_generic('123', {'key': 'value'})
	assert response.jsonrpc == jsonrpc.jsonrpc_version
	assert response.id == '123'
	
	assert response.is_result()
	assert !response.is_error() // Ensure no error is set
	result := response.result() or {
		assert false, 'Response should have result'
		return
	}
	assert result == {'key': 'value'}
}

fn test_decode_response_generic() {
	data := '{"jsonrpc":"2.0","result":{"key":"value"},"id":"123"}'
	response := decode_response_generic[map[string]string](data) or {
		assert false, 'Failed to decode generic response: $err'
		return
	}
	assert response.jsonrpc == '2.0'
	assert response.id == '123'
	
	assert response.is_result()
	assert !response.is_error() // Ensure no error is set
	result := response.result() or {
		assert false, 'Response should have result'
		return
	}
	assert result == {'key': 'value'}
}

fn test_response_generic_encode() {
	response := new_response_generic('123', {'key': 'value'})
	json := response.encode()
	assert json.contains('"jsonrpc"') && json.contains('"result"') && json.contains('"id"')
}

fn test_response_generic_validate() {
	response := new_response_generic('123', {'key': 'value'})
	response.validate() or { assert false, 'Validation failed for valid response: $err' }

	error := RPCError{
		code: 123
		message: 'Test error'
		data: 'Error details'
	}
	invalid_response := ResponseGeneric{
		jsonrpc: '2.0'
		result: {'key': 'value'}
		error_: error
		id: '123'
	}
	invalid_response.validate() or {
		assert err.msg().contains('Response contains both error and result.')
	}
}

fn test_response_generic_error() {
	error := RPCError{
		code: 123
		message: 'Test error'
		data: 'Error details'
	}
	response := ResponseGeneric[map[string]string]{
		jsonrpc: '2.0'
		error_: error
		id: '123'
	}
	err := response.error() or {
		assert false, 'Failed to get error: $err'
		return
	}
	assert err.code == 123
	assert err.message == 'Test error'
	assert err.data == 'Error details'
}

fn test_response_generic_result() {
	response := new_response_generic('123', {'key': 'value'})
	result := response.result() or {
		assert false, 'Failed to get result: $err'
		return
	}
	assert result == {'key': 'value'}
}