module main

import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.mcp
import freeflowuniverse.herolib.schemas.jsonrpc

fn main() {
	// logger.info('Starting V-Do server')
	
	// Create an empty map of procedure handlers
	handlers := map[string]jsonrpc.ProcedureHandler{}
	
	// Initialize the server with the empty handlers map
	mut server := mcp.new_server(
		handlers, 
		mcp.ServerConfiguration{
			server_info: mcp.ServerInfo{
				name: 'v_do'
				version: '1.0.0'
			}
		}
	)!
	
	server.start() or {
		logger.fatal('Error starting server: $err')
		exit(1)
	}
}
