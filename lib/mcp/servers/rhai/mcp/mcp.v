module pugconvert

import freeflowuniverse.herolib.mcp
import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.schemas.jsonrpc

pub fn new_mcp_server() !&mcp.Server {
	logger.info('Creating new Rhai MCP server')

	// Initialize the server with the empty handlers map
	mut server := mcp.new_server(mcp.MemoryBackend{
		tools:         {
			'rhai_interface': specs
		}
		tool_handlers: {
			'rhai_interface': handler
		}
	}, mcp.ServerParams{
		config: mcp.ServerConfiguration{
			server_info: mcp.ServerInfo{
				name:    'developer'
				version: '1.0.0'
			}
		}
	})!
	return server
}
