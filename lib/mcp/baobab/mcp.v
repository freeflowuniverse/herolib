module baobab

import freeflowuniverse.herolib.mcp
import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.schemas.jsonrpc

pub fn new_mcp_server() !&mcp.Server {
	logger.info('Creating new Developer MCP server')

	// Initialize the server with the empty handlers map
	mut server := mcp.new_server(mcp.MemoryBackend{
		tools:         {
			'generate_module_from_openapi': generate_module_from_openapi_tool
		}
		tool_handlers: {
			'generate_module_from_openapi': generate_module_from_openapi_tool_handler
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
