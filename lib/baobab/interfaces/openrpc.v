module interfaces

// handler for test echoes JSONRPC Request as JSONRPC Response
fn handler(request jsonrpc.Request) !jsonrpc.Response {
    return jsonrpc.Response {
        jsonrpc: request.jsonrpc
        id: request.id
        result: request.params
    }
}

pub struct OpenRPCInterface {
pub mut:
	client Client
}

pub fn new_openrpc_interface(client Client) &OpenRPCInterface {
	return &OpenRPCInterface{client}
}

pub fn (mut i OpenRPCInterface) handle(request jsonrpc.Request) !jsonrpc.Response {
	// Convert incoming OpenAPI request to a procedure call
	action := actions.action_from_jsonrpc_request(request)
	response := i.client.call_to_action(action)!
	return actions.action_to_jsonrpc_response(response)
}