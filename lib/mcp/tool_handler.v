module mcp

import x.json2

// ToolHandler is a function type that handles tool calls
pub type ToolHandler = fn (arguments map[string]string) !ToolCallResult