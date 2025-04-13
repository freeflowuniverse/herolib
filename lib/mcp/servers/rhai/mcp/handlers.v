module mcp

import freeflowuniverse.herolib.mcp
import x.json2 as json { Any }
import freeflowuniverse.herolib.mcp.servers.rhai.logic as rhaido
import freeflowuniverse.herolib.core.pathlib
import os

//TODO: implement

pub fn handler(arguments map[string]Any) !mcp.ToolCallResult {
	path := arguments['path'].str()
	
	// Check if path exists
	if !os.exists(path) {
		return mcp.ToolCallResult{
			is_error: true
			content: mcp.result_to_mcp_tool_contents[string]("Error: Path '${path}' does not exist")
		}
	}
	
	// Determine if path is a file or directory
	is_directory := os.is_dir(path)
	
	mut message := ""

	//TODO: implement
	
	if is_directory {
		// Convert all rhai files in the directory
		rhaido.convert_rhai(path) or {
			return mcp.ToolCallResult{
				is_error: true
				content: mcp.result_to_mcp_tool_contents[string]("Error converting rhai files in directory: ${err}")
			}
		}
		message = "Successfully converted all rhai files in directory '${path}'"
	} else if path.ends_with(".rhai") {
		// Convert a single rhai file
		rhaido.convert_rhai_file(path) or {
			return mcp.ToolCallResult{
				is_error: true
				content: mcp.result_to_mcp_tool_contents[string]("Error converting rhai file: ${err}")
			}
		}
		message = "Successfully converted rhai file '${path}'"
	} else {
		return mcp.ToolCallResult{
			is_error: true
			content: mcp.result_to_mcp_tool_contents[string]("Error: Path '${path}' is not a directory or .rhai file")
		}
	}

	return mcp.ToolCallResult{
		is_error: false
		content: mcp.result_to_mcp_tool_contents[string](message)
	}
}
