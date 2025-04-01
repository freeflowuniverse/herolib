module pugconvert

import freeflowuniverse.herolib.mcp
import x.json2 as json { Any }
import freeflowuniverse.herolib.mcp.logger
import freeflowuniverse.herolib.baobab.generator

pub fn handler(arguments map[string]Any) !mcp.ToolCallResult {
	println('debugzo31')
	path := arguments['path'].str()

	return mcp.ToolCallResult{
		is_error: false
		content:  result_to_mcp_tool_contents[string](result)
	}
}
