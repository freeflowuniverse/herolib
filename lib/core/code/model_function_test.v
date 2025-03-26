module code

fn test_parse_function_with_comments() {
	// Test function string with comments
	function_str := '// test_function is a simple function for testing the MCP tool code generation
// It takes a config and returns a result
pub fn test_function(config TestConfig) !TestResult {
	// This is just a mock implementation for testing purposes
	if config.name == \'\' {
		return error(\'Name cannot be empty\')
	}
	
	return TestResult{
		success: config.enabled
		message: \'Test completed for \${config.name}\'
		code: if config.enabled { 0 } else { 1 }
	}
}'

	// Parse the function
	function := parse_function(function_str) or {
		assert false, 'Failed to parse function: ${err}'
		Function{}
	}

	// Verify the parsed function properties
	assert function.name == 'test_function'
	assert function.is_pub == true
	assert function.params.len == 1
	assert function.params[0].name == 'config'
	assert function.params[0].typ.symbol() == 'TestConfig'
	assert function.result.typ.symbol() == 'TestResult'
	
	// Verify that the comments were correctly parsed into the description
	expected_description := 'test_function is a simple function for testing the MCP tool code generation
It takes a config and returns a result'
	assert function.description == expected_description

	println('test_parse_function_with_comments passed')
}

fn test_parse_function_without_comments() {
	// Test function string without comments
	function_str := 'fn simple_function(name string, count int) string {
	return \'\${name} count: \${count}\'
}'

	// Parse the function
	function := parse_function(function_str) or {
		assert false, 'Failed to parse function: ${err}'
		Function{}
	}

	// Verify the parsed function properties
	assert function.name == 'simple_function'
	assert function.is_pub == false
	assert function.params.len == 2
	assert function.params[0].name == 'name'
	assert function.params[0].typ.symbol() == 'string'
	assert function.params[1].name == 'count'
	assert function.params[1].typ.symbol() == 'int'
	assert function.result.typ.symbol() == 'string'
	
	// Verify that there is no description
	assert function.description == ''

	println('test_parse_function_without_comments passed')
}

fn test_parse_function_with_receiver() {
	// Test function with a receiver
	function_str := 'pub fn (d &Developer) create_tool(name string) !Tool {
	return Tool{
		name: name
	}
}'

	// Parse the function
	function := parse_function(function_str) or {
		assert false, 'Failed to parse function: ${err}'
		Function{}
	}

	// Verify the parsed function properties
	assert function.name == 'create_tool'
	assert function.is_pub == true
	assert function.receiver.name == 'd'
	assert function.receiver.typ.symbol() == '&Developer'
	assert function.params.len == 1
	assert function.params[0].name == 'name'
	assert function.params[0].typ.symbol() == 'string'
	assert function.result.typ.symbol() == 'Tool'

	println('test_parse_function_with_receiver passed')
}
