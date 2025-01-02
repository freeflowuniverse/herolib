module jsonrpc

// Interface for a transport client used by the JSON-RPC client.
pub interface IRPCTransportClient {
mut:
	send(string, SendParams) !string // Sends a request and returns the response as a string
}

// JSON-RPC WebSocket client implementation.
pub struct Client {
mut:
	transport IRPCTransportClient // Transport layer to handle communication
}

// Creates a new JSON-RPC client instance.
pub fn new_client(client Client) &Client {
	return &Client{...client}
}

// Parameters for configuring the `send` function.
@[params]
pub struct SendParams {
	timeout int = 60 // Timeout in seconds (default: 60)
	retry   int      // Number of retry attempts
}

// Sends a JSON-RPC request and returns the response result of type `D`.
// Validates the response and ensures the request/response IDs match.
pub fn (mut c Client) send[T, D](request RequestGeneric[T], params SendParams) !D {
	response_json := c.transport.send(request.encode(), params)! // Send the encoded request
	response := decode_response_generic[D](response_json) or {
		return error('Unable to decode response.\n- Response: ${response_json}\n- Error: ${err}')
	}

	response.validate() or {
		return error('Received invalid response: ${err}')
	}

	if response.id != request.id {
		return error('Received response with different id ${response}')
	}

	println('response ${response}')

	// Return the result or propagate the error.
	return response.result()!
}