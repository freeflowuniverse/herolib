module developer

import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.mcp
import freeflowuniverse.herolib.schemas.jsonrpc

pub fn new_mcp_server(d &Developer) ! &mcp.Server {
	logger.info('Creating new Developer MCP server')

	// Initialize the server with the empty handlers map
	mut server := mcp.new_server(
		mcp.MemoryBackend{
			tools: {
				'create_mcp_tool': create_mcp_tool_tool,
				'create_mcp_tool_handler': create_mcp_tool_handler_tool,
				'create_mcp_tool_code': create_mcp_tool_code_tool
			},
			tool_handlers: {
				'create_mcp_tool': d.create_mcp_tool_tool_handler,
				'create_mcp_tool_handler': d.create_mcp_tool_handler_tool_handler,
				'create_mcp_tool_code': d.create_mcp_tool_code_tool_handler
			},
		},
		mcp.ServerParams{
			config:mcp.ServerConfiguration{
			server_info: mcp.ServerInfo{
				name: 'developer'
				version: '1.0.0'
			}
		}}
	)!
	return server
}
