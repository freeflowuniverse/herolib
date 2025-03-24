module mcp

pub fn error_tool_call_result(err IError) ToolCallResult {
	return ToolCallResult{
		is_error: true
		content:  [ToolContent{
			typ:  'text'
			text: err.msg()
		}]
	}
}
