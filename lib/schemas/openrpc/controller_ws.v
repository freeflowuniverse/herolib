module openrpc

// Main controller for handling RPC requests
pub struct WebSocketController {
pub mut:
    handler       Handler @[required] // Handles JSON-RPC requests
}

// Creates a new HTTPController instance
pub fn new_websocket_controller(c WebSocketController) &WebSocketController {
	return &WebSocketController{...c}
}