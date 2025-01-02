module openrpc

import veb
import x.json2
import freeflowuniverse.herolib.schemas.jsonrpc

// Main controller for handling RPC requests
pub struct Controller {
pub:
    specification OpenRPC @[required] // OpenRPC specification
pub mut:
    handler       Handler @[required] // Handles JSON-RPC requests
}

pub struct Context {
    veb.Context
}

// Creates a new Controller instance
pub fn new_controller(c Controller) &Controller {
	return &Controller{...c}
}

// Parameters for running the server
@[params]
pub struct RunParams {
pub:
    port int = 8080 // Default to port 8080
}

// Starts the server
pub fn (mut c Controller) run(params RunParams) {
    veb.run[Controller, Context](mut c, 8080)
}

// Handles POST requests at the index endpoint
@[post]
pub fn (mut c Controller) index(mut ctx Context) veb.Result {
    req_raw := json2.raw_decode(ctx.req.data) or {
        return ctx.server_error('Invalid JSON body') // Return error if JSON is malformed
    }

    req_map := req_raw.as_map() // Converts JSON to a map

    // Create a jsonrpc.Request using the decoded data
    request := jsonrpc.Request{
        jsonrpc: req_map['jsonrpc'].str()
        id: req_map['id'].str()
        method: req_map['method'].str()
        params: req_map['params'].str()
    }

    // Process the request with the handler
    response := c.handler.handle(request) or {
        return ctx.server_error('Handler error: ${err.msg}')
    }

    // Return the handler's response as JSON
    return ctx.json(response)
}

pub struct Handler {
	specification OpenRPC
pub mut: 
    handler fn(jsonrpc.Request) !jsonrpc.Response
}

// Handle a request and return a response
pub fn (h Handler) handle(req jsonrpc.Request) !jsonrpc.Response {
    return h.handler(req)!
}
