module developer

import freeflowuniverse.herolib.mcp
import x.json2 as json { Any }
// import json

const create_mcp_tool_code_tool = mcp.Tool{
	name:         'create_mcp_tool_code'
	description:  'create_mcp_tool_code receives the name of a V language function string, and the path to the module in which it exists.
returns an MCP Tool code in v for attaching the function to the mcp server'
	input_schema: mcp.ToolInputSchema{
		typ:        'object'
		properties: {
			'function_name': mcp.ToolProperty{
				typ:   'string'
				items: mcp.ToolItems{
					typ:  ''
					enum: []
				}
				enum:  []
			}
			'module_path':   mcp.ToolProperty{
				typ:   'string'
				items: mcp.ToolItems{
					typ:  ''
					enum: []
				}
				enum:  []
			}
		}
		required:   ['function_name', 'module_path']
	}
}

pub fn (d &Developer) create_mcp_tool_code_tool_handler(arguments map[string]Any) !mcp.ToolCallResult {
	function_name := arguments['function_name'].str()
	module_path := arguments['module_path'].str()
	result := d.create_mcp_tool_code(function_name, module_path) or {
		return mcp.error_tool_call_result(err)
	}
	return mcp.ToolCallResult{
		is_error: false
		content:  result_to_mcp_tool_contents[string](result)
	}
}

// Tool definition for the create_mcp_tool function
const create_mcp_tool_tool = mcp.Tool{
	name:         'create_mcp_tool'
	description:  'Parses a V language function string and returns an MCP Tool struct. This tool analyzes function signatures, extracts parameters, and generates the appropriate MCP Tool representation.'
	input_schema: mcp.ToolInputSchema{
		typ:        'object'
		properties: {
			'function': mcp.ToolProperty{
				typ: 'string'
			}
			'types':    mcp.ToolProperty{
				typ: 'object'
			}
		}
		required:   ['function']
	}
}

pub fn (d &Developer) create_mcp_tool_tool_handler(arguments map[string]Any) !mcp.ToolCallResult {
	function := arguments['function'].str()
	types := json.decode[map[string]string](arguments['types'].str())!
	result := d.create_mcp_tool(function, types) or { return mcp.error_tool_call_result(err) }
	return mcp.ToolCallResult{
		is_error: false
		content:  result_to_mcp_tool_contents[string](result.str())
	}
}

// Tool definition for the create_mcp_tool_handler function
const create_mcp_tool_handler_tool = mcp.Tool{
	name:         'create_mcp_tool_handler'
	description:  'Generates a tool handler for the create_mcp_tool function. This tool handler accepts function string and types map and returns an MCP ToolCallResult.'
	input_schema: mcp.ToolInputSchema{
		typ:        'object'
		properties: {
			'function': mcp.ToolProperty{
				typ: 'string'
			}
			'types':    mcp.ToolProperty{
				typ: 'object'
			}
			'result':   mcp.ToolProperty{
				typ: 'string'
			}
		}
		required:   ['function', 'result']
	}
}

// Tool handler for the create_mcp_tool_handler function
pub fn (d &Developer) create_mcp_tool_handler_tool_handler(arguments map[string]Any) !mcp.ToolCallResult {
	function := arguments['function'].str()
	types := json.decode[map[string]string](arguments['types'].str())!
	result_ := arguments['result'].str()
	result := d.create_mcp_tool_handler(function, types, result_) or {
		return mcp.error_tool_call_result(err)
	}
	return mcp.ToolCallResult{
		is_error: false
		content:  result_to_mcp_tool_contents[string](result)
	}
}
