module vcode

import freeflowuniverse.herolib.mcp

const get_function_from_file_tool = mcp.Tool{
	name:         'get_function_from_file'
	description:  'get_function_from_file parses a V file and extracts a specific function block including its comments
ARGS:
file_path string - path to the V file
function_name string - name of the function to extract
RETURNS: string - the function block including comments, or empty string if not found'
	input_schema: jsonschema.Schema{
		typ:        'object'
		properties: {
			'file_path':     jsonschema.Schema{
				typ:   'string'
				items: mcp.ToolItems{
					typ:  ''
					enum: []
				}
				enum:  []
			}
			'function_name': jsonschema.Schema{
				typ:   'string'
				items: mcp.ToolItems{
					typ:  ''
					enum: []
				}
				enum:  []
			}
		}
		required:   ['file_path', 'function_name']
	}
}
