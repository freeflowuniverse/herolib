module developer

import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.mcp
import freeflowuniverse.herolib.schemas.jsonrpc

fn new_mcp_server() {
	logger.info('Creating new Developer MCP server')

	// Initialize the server with the empty handlers map
	mut server := mcp.new_server(
		mcp.MemoryBackend{
			resources: map[string]mcp.Resource{},
			resource_contents: map[string][]mcp.ResourceContent{},
			resource_templates: map[string]mcp.ResourceTemplate{},
			prompts: map[string]mcp.Prompt{},
			prompt_messages: map[string][]mcp.PromptMessage{},
			tools: map[string]mcp.Tool{},
			tool_handlers: map[string]mcp.ToolHandler{},
		},
		mcp.ServerParams{
			config:mcp.ServerConfiguration{
			server_info: mcp.ServerInfo{
				name: 'developer'
				version: '1.0.0'
			}
		}}
	)!

	server.start() or {
		logger.fatal('Error starting server: $err')
		exit(1)
	}
}
