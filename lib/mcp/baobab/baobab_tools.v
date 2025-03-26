module baobab

import freeflowuniverse.herolib.mcp
import x.json2 as json { Any }
import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.baobab.generator

const generate_module_from_openapi_tool = mcp.Tool{
	name:         'generate_module_from_openapi'
	description:  ''
	input_schema: mcp.ToolInputSchema{
		typ:        'object'
		properties: {
			'openapi_path': mcp.ToolProperty{
				typ:   'string'
				items: mcp.ToolItems{
					typ:  ''
					enum: []
				}
				enum:  []
			}
		}
		required:   ['openapi_path']
	}
}

pub fn generate_module_from_openapi_tool_handler(arguments map[string]Any) !mcp.ToolCallResult {
	println('debugzo31')
	openapi_path := arguments['openapi_path'].str()
	println('debugzo32')
	result := generator.generate_module_from_openapi(openapi_path) or {
		println('debugzo33')
		return mcp.error_tool_call_result(err)
	}
	println('debugzo34')
	return mcp.ToolCallResult{
		is_error: false
		content:  result_to_mcp_tool_contents[string](result)
	}
}
