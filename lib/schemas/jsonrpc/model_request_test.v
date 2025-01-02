module jsonrpc

fn test_new_request() {
	request := new_request('test_method', 'test_params')
	assert request.jsonrpc == jsonrpc.jsonrpc_version
	assert request.method == 'test_method'
	assert request.params == 'test_params'
	assert request.id != '' // Ensure the ID is generated
}

fn test_decode_request() {
	data := '{"jsonrpc":"2.0","method":"test_method","params":"test_params","id":"123"}'
	request := decode_request(data) or {
		assert false, 'Failed to decode request: $err'
		return
	}
	assert request.jsonrpc == '2.0'
	assert request.method == 'test_method'
	assert request.params == 'test_params'
	assert request.id == '123'
}

fn test_request_encode() {
	request := new_request('test_method', 'test_params')
	json := request.encode()
	assert json.contains('"jsonrpc"') && json.contains('"method"') && json.contains('"params"') && json.contains('"id"')
}

fn test_new_request_generic() {
	params := {'key': 'value'}
	request := new_request_generic('test_method', params)
	assert request.jsonrpc == jsonrpc.jsonrpc_version
	assert request.method == 'test_method'
	assert request.params == params
	assert request.id != '' // Ensure the ID is generated
}

fn test_decode_request_id() {
	data := '{"jsonrpc":"2.0","method":"test_method","params":"test_params","id":"123"}'
	id := decode_request_id(data) or {
		assert false, 'Failed to decode request ID: $err'
		return
	}
	assert id == '123'
}

fn test_decode_request_method() {
	data := '{"jsonrpc":"2.0","method":"test_method","params":"test_params","id":"123"}'
	method := decode_request_method(data) or {
		assert false, 'Failed to decode request method: $err'
		return
	}
	assert method == 'test_method'
}

fn test_decode_request_generic() {
	data := '{"jsonrpc":"2.0","method":"test_method","params":{"key":"value"},"id":"123"}'
	request := decode_request_generic[map[string]string](data) or {
		assert false, 'Failed to decode generic request: $err'
		return
	}
	assert request.jsonrpc == '2.0'
	assert request.method == 'test_method'
	assert request.params == {'key': 'value'}
	assert request.id == '123'
}

fn test_request_generic_encode() {
	params := {'key': 'value'}
	request := new_request_generic('test_method', params)
	json := request.encode()
	assert json.contains('"jsonrpc"') && json.contains('"method"') && json.contains('"params"') && json.contains('"id"')
}