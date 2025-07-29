module transport

import veb
import veb.sse
import log
import time
import freeflowuniverse.herolib.schemas.jsonrpc

// HttpTransport implements the Transport interface for HTTP communication.
// It provides both JSON-RPC over HTTP and REST API endpoints for MCP servers.
pub struct HttpTransport {
pub:
	port int      = 8080
	host string   = 'localhost'
	mode HttpMode = .both
mut:
	handler &jsonrpc.Handler = unsafe { nil }
}

// HttpApp is the VEB application struct that handles HTTP requests
pub struct HttpApp {
pub mut:
	transport &HttpTransport = unsafe { nil }
}

// Context represents the HTTP request context
pub struct Context {
	veb.Context
}

// new_http_transport creates a new HTTP transport instance
pub fn new_http_transport(config HttpConfig) Transport {
	return &HttpTransport{
		port: config.port
		host: config.host
		mode: config.protocol
	}
}

// start implements the Transport interface for HTTP communication.
// It starts a VEB web server with the appropriate endpoints based on the configured mode.
pub fn (mut t HttpTransport) start(handler &jsonrpc.Handler) ! {
	unsafe {
		t.handler = handler
	}
	log.info('Starting MCP server with HTTP transport on ${t.host}:${t.port}')

	mut app := &HttpApp{
		transport: t
	}

	veb.run[HttpApp, Context](mut app, t.port)
}

// send implements the Transport interface for HTTP communication.
// Note: For HTTP, responses are sent directly in the request handlers,
// so this method is not used in the same way as STDIO transport.
pub fn (mut t HttpTransport) send(response string) {
	// HTTP responses are handled directly in the route handlers
	// This method is kept for interface compatibility
	log.debug('HTTP transport send called: ${response}')
}

// JSON-RPC over HTTP endpoint
// Handles POST requests to /jsonrpc with JSON-RPC 2.0 protocol
@['/jsonrpc'; post]
pub fn (mut app HttpApp) handle_jsonrpc(mut ctx Context) veb.Result {
	// Get the request body
	request_body := ctx.req.data

	if request_body.len == 0 {
		return ctx.request_error('Empty request body')
	}

	// Process the JSON-RPC request using the existing handler
	response := app.transport.handler.handle(request_body) or {
		log.error('JSON-RPC handler error: ${err}')
		return ctx.server_error('Internal server error')
	}

	// Return the JSON-RPC response
	ctx.set_content_type('application/json')
	return ctx.text(response)
}

// Health check endpoint
@['/health'; get]
pub fn (mut app HttpApp) health(mut ctx Context) veb.Result {
	return ctx.json({
		'status':    'ok'
		'transport': 'http'
		'timestamp': 'now'
	})
}

// CORS preflight handler
@['/*'; options]
pub fn (mut app HttpApp) options(mut ctx Context) veb.Result {
	ctx.set_custom_header('Access-Control-Allow-Origin', '*') or {}
	ctx.set_custom_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS') or {}
	ctx.set_custom_header('Access-Control-Allow-Headers', 'Content-Type, Authorization') or {}
	return ctx.text('')
}

// REST API Endpoints (when mode is .rest_only or .both)

// List all available tools
@['/api/tools'; get]
pub fn (mut app HttpApp) list_tools(mut ctx Context) veb.Result {
	if app.transport.mode == .jsonrpc_only {
		return ctx.not_found()
	}

	// Create JSON-RPC request for tools/list
	request := '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'

	response := app.transport.handler.handle(request) or {
		log.error('Tools list error: ${err}')
		return ctx.server_error('Failed to list tools')
	}

	// Parse JSON-RPC response and extract result
	result := extract_jsonrpc_result(response) or {
		return ctx.server_error('Invalid response format')
	}

	ctx.set_custom_header('Access-Control-Allow-Origin', '*') or {}
	ctx.set_content_type('application/json')
	return ctx.text(result)
}

// Call a specific tool
@['/api/tools/:tool_name/call'; post]
pub fn (mut app HttpApp) call_tool(mut ctx Context, tool_name string) veb.Result {
	if app.transport.mode == .jsonrpc_only {
		return ctx.not_found()
	}

	// Create JSON-RPC request for tools/call by building the JSON string directly
	// This avoids json2.Any conversion issues
	arguments_json := ctx.req.data

	request_json := '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"${tool_name}","arguments":${arguments_json}}}'

	response := app.transport.handler.handle(request_json) or {
		log.error('Tool call error: ${err}')
		return ctx.server_error('Tool call failed')
	}

	// Parse JSON-RPC response and extract result
	result := extract_jsonrpc_result(response) or {
		return ctx.server_error('Invalid response format')
	}

	ctx.set_custom_header('Access-Control-Allow-Origin', '*') or {}
	ctx.set_content_type('application/json')
	return ctx.text(result)
}

// List all available resources
@['/api/resources'; get]
pub fn (mut app HttpApp) list_resources(mut ctx Context) veb.Result {
	if app.transport.mode == .jsonrpc_only {
		return ctx.not_found()
	}

	// Create JSON-RPC request for resources/list
	request := '{"jsonrpc":"2.0","id":1,"method":"resources/list","params":{}}'

	response := app.transport.handler.handle(request) or {
		log.error('Resources list error: ${err}')
		return ctx.server_error('Failed to list resources')
	}

	// Parse JSON-RPC response and extract result
	result := extract_jsonrpc_result(response) or {
		return ctx.server_error('Invalid response format')
	}

	ctx.set_custom_header('Access-Control-Allow-Origin', '*') or {}
	ctx.set_content_type('application/json')
	return ctx.text(result)
}

// SSE endpoint for streaming MCP communication
@['/sse'; get]
pub fn (mut app HttpApp) handle_sse(mut ctx Context) veb.Result {
	// Set CORS headers
	ctx.set_custom_header('Access-Control-Allow-Origin', '*') or {}
	ctx.set_custom_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS') or {}
	ctx.set_custom_header('Access-Control-Allow-Headers', 'Content-Type, Authorization') or {}

	// Take over the connection for SSE
	ctx.takeover_conn()

	// Handle SSE connection in a separate thread
	spawn handle_sse_connection(mut ctx, app.transport.handler)

	return veb.no_result()
}

// Handle SSE connection for MCP communication
fn handle_sse_connection(mut ctx Context, handler &jsonrpc.Handler) {
	mut sse_conn := sse.start_connection(mut ctx.Context)

	log.info('SSE connection established for MCP')

	// Keep connection alive with periodic messages
	for {
		// Send server capabilities periodically
		capabilities_msg := '{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2024-11-05","capabilities":{"logging":{},"prompts":{"listChanged":true},"resources":{"subscribe":true,"listChanged":true},"tools":{"listChanged":true}},"serverInfo":{"name":"inspector_example","version":"1.0.0"}}}'

		sse_conn.send_message(
			event: 'capabilities'
			data:  capabilities_msg
		) or {
			log.info('SSE connection closed during capabilities send')
			break
		}

		time.sleep(2 * time.second)

		// Send tools list
		tools_response := handler.handle('{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}') or {
			log.error('Failed to get tools list: ${err}')
			continue
		}

		sse_conn.send_message(
			event: 'tools'
			data:  tools_response
		) or {
			log.info('SSE connection closed during tools send')
			break
		}

		time.sleep(3 * time.second)

		// Send keepalive ping
		sse_conn.send_message(
			event: 'ping'
			data:  '{"status":"alive"}'
		) or {
			log.info('SSE connection closed during ping')
			break
		}

		time.sleep(5 * time.second)
	}

	sse_conn.close()
}

// Helper function to extract result from JSON-RPC response
fn extract_jsonrpc_result(response string) !string {
	// Simple string-based JSON extraction to avoid json2.Any issues
	// Look for "result": and extract the value
	if response.contains('"error"') {
		return error('JSON-RPC error in response')
	}

	if !response.contains('"result":') {
		return error('No result in JSON-RPC response')
	}

	// Simple extraction - for now just return the whole response
	// In a production system, you'd want proper JSON parsing here
	return response
}
