module v_do

import json
import os
import freeflowuniverse.herolib.mcp.v_do.handlers
import freeflowuniverse.herolib.mcp.v_do.logger

// MCP server implementation using stdio transport
// Based on https://modelcontextprotocol.io/docs/concepts/transports

// MCPRequest represents an MCP request message
struct MCPRequest {
	id      string
	method  string
	params  map[string]string
	jsonrpc string = '2.0'
}

// MCPResponse represents an MCP response
struct MCPResponse {
	id      string
	result  map[string]string
	jsonrpc string = '2.0'
}

// MCPErrorResponse represents an MCP error response
struct MCPErrorResponse {
	id      string
	error   MCPError
	jsonrpc string = '2.0'
}

// MCPError represents an error in an MCP response
struct MCPError {
	code    int
	message string
}

// Server is the main MCP server struct
pub struct Server {}

// new_server creates a new MCP server
pub fn new_server() &Server {
	return &Server{}
}

// start starts the MCP server
pub fn (mut s Server) start() ! {
	logger.info('Starting V-Do MCP server')
	for {
		message := s.read_message() or {
			logger.error('Failed to parse message: $err')
			s.send_error('0', -32700, 'Failed to parse message: $err')
			continue
		}

		logger.debug('Received message: ${message.method}')
		s.handle_message(message) or {
			logger.error('Internal error: $err')
			s.send_error(message.id, -32603, 'Internal error: $err')
		}
	}
}

// read_message reads an MCP message from stdin
fn (mut s Server) read_message() !MCPRequest {
	mut content_length := 0
	
	// Read headers
	for {
		line := read_line_from_stdin() or { 
			logger.error('Failed to read line: $err')
			return error('Failed to read line: $err') 
		}
		if line.len == 0 {
			break
		}
		
		if line.starts_with('Content-Length:') {
			content_length_str := line.all_after('Content-Length:').trim_space()
			content_length = content_length_str.int()
		}
	}
	
	if content_length == 0 {
		logger.error('No Content-Length header found')
		return error('No Content-Length header found')
	}
	
	// Read message body
	body := read_content_from_stdin(content_length) or { 
		logger.error('Failed to read content: $err')
		return error('Failed to read content: $err') 
	}
	
	// Parse JSON
	message := json.decode(MCPRequest, body) or { 
		logger.error('Failed to decode JSON: $err')
		return error('Failed to decode JSON: $err') 
	}
	
	return message
}

// read_line_from_stdin reads a line from stdin
fn read_line_from_stdin() !string {
	line := os.get_line()
	return line
}

// read_content_from_stdin reads content from stdin with the specified length
fn read_content_from_stdin(length int) !string {
	// For MCP protocol, we need to read exactly the content length
	mut content := ''
	mut reader := os.stdin()
	mut buf := []u8{len: length}
	n := reader.read(mut buf) or { 
		logger.error('Failed to read from stdin: $err')
		return error('Failed to read from stdin: $err') 
	}
	
	if n < length {
		logger.error('Expected to read $length bytes, but got $n')
		return error('Expected to read $length bytes, but got $n')
	}
	
	content = buf[..n].bytestr()
	return content
}

// handle_message handles an MCP message
fn (mut s Server) handle_message(message MCPRequest) ! {
	match message.method {
		'test' {
			fullpath := message.params['fullpath'] or { 
				logger.error('Missing fullpath parameter')
				s.send_error(message.id, -32602, 'Missing fullpath parameter')
				return error('Missing fullpath parameter') 
			}
			logger.info('Running test on $fullpath')
			result := handlers.vtest(fullpath) or {
				logger.error('Test failed: $err')
				s.send_error(message.id, -32000, 'Test failed: $err')
				return err
			}
			s.send_response(message.id, {'output': result})
		}
		else {
			logger.error('Unknown method: ${message.method}')
			s.send_error(message.id, -32601, 'Unknown method: ${message.method}')
			return error('Unknown method: ${message.method}')
		}
	}
}

// send_response sends an MCP response
fn (mut s Server) send_response(id string, result map[string]string) {
	response := MCPResponse{
		id: id
		result: result
	}
	
	json_str := json.encode(response)
	logger.debug('Sending response for id: $id')
	s.write_message(json_str)
}

// send_error sends an MCP error response
fn (mut s Server) send_error(id string, code int, message string) {
	logger.error('Sending error response: $message (code: $code, id: $id)')
	error_response := MCPErrorResponse{
		id: id
		error: MCPError{
			code: code
			message: message
		}
	}
	
	json_str := json.encode(error_response)
	s.write_message(json_str)
}

// write_message writes an MCP message to stdout
fn (mut s Server) write_message(content string) {
	header := 'Content-Length: ${content.len}\r\n\r\n'
	print(header)
	print(content)
}
