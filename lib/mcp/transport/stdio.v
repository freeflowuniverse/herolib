module transport

import time
import os
import log
import freeflowuniverse.herolib.schemas.jsonrpc

// StdioTransport implements the Transport interface for standard input/output communication.
// This is the original MCP transport method where the server reads JSON-RPC requests from stdin
// and writes responses to stdout. This transport is used for process-to-process communication.
pub struct StdioTransport {
mut:
	handler &jsonrpc.Handler = unsafe { nil }
}

// new_stdio_transport creates a new STDIO transport instance
pub fn new_stdio_transport() Transport {
	return &StdioTransport{}
}

// start implements the Transport interface for STDIO communication.
// It reads JSON-RPC messages from stdin, processes them with the handler,
// and sends responses to stdout.
pub fn (mut t StdioTransport) start(handler &jsonrpc.Handler) ! {
	unsafe {
		t.handler = handler
	}
	log.info('Starting MCP server with STDIO transport')

	for {
		// Read a message from stdin
		message := os.get_line()
		if message == '' {
			time.sleep(10000) // prevent cpu spinning
			continue
		}

		// Handle the message using the JSON-RPC handler
		response := t.handler.handle(message) or {
			log.error('message: ${message}')
			log.error('Error handling message: ${err}')

			// Try to extract the request ID for error response
			id := jsonrpc.decode_request_id(message) or { 0 }

			// Create an internal error response
			error_response := jsonrpc.new_error(id, jsonrpc.internal_error).encode()
			print(error_response)
			continue
		}

		// Send the response only if it's not empty (notifications return empty responses)
		if response.len > 0 {
			t.send(response)
		}
	}
}

// send implements the Transport interface for STDIO communication.
// It writes the response to stdout and flushes the output buffer.
pub fn (mut t StdioTransport) send(response string) {
	println(response)
	flush_stdout()
}
