module mcp

import time
import os
import log
import x.json2
import freeflowuniverse.herolib.schemas.jsonrpc
import freeflowuniverse.herolib.mcp.logger

// new_server creates a new MCP server
pub fn new_server(handlers map[string]jsonrpc.ProcedureHandler, config ServerConfiguration) !&Server {
	mut server := &Server{
		ServerConfiguration: config
	}
	
	// Create a handler with the core MCP procedures registered
	handler := jsonrpc.new_handler(jsonrpc.Handler{
		procedures: {
			...handlers,
			'initialize': server.initialize_handler,
			'notifications/initialized': initialized_notification_handler
		}
	})!
	
	server.handler = *handler
	return server
}