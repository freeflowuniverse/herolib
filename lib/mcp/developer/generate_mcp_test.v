module developer

import freeflowuniverse.herolib.mcp
import json
import os

fn test_parse_struct_fields() {
	// Test case 1: Simple struct with primitive types
	simple_struct := 'pub struct User {
		name string
		age int
		active bool
	}'
	
	fields := parse_struct_fields(simple_struct)
	assert fields.len == 3
	assert fields['name'] == 'string'
	assert fields['age'] == 'int'
	assert fields['active'] == 'bool'
	
	// Test case 2: Struct with pub: and mut: sections
	complex_struct := 'pub struct Config {
	pub:
		host string
		port int
	mut:
		connected bool
		retries int
	}'
	
	fields2 := parse_struct_fields(complex_struct)
	assert fields2.len == 4
	assert fields2['host'] == 'string'
	assert fields2['port'] == 'int'
	assert fields2['connected'] == 'bool'
	assert fields2['retries'] == 'int'
	
	// Test case 3: Struct with attributes and comments
	struct_with_attrs := 'pub struct ApiResponse {
		// User ID
		id int
		// User\'s full name
		name string @[json: "full_name"]
		// Whether account is active
		active bool
	}'
	
	fields3 := parse_struct_fields(struct_with_attrs)
	assert fields3.len == 3  // All fields are included
	assert fields3['id'] == 'int'
	assert fields3['active'] == 'bool'
	
	// Test case 4: Empty struct
	empty_struct := 'pub struct Empty {}'
	fields4 := parse_struct_fields(empty_struct)
	assert fields4.len == 0
	
	println('test_parse_struct_fields passed')
}

fn test_create_mcp_tool_input_schema() {
	d := Developer{}
	
	// Test case 1: Primitive types
	string_schema := d.create_mcp_tool_input_schema('string') or { panic(err) }
	assert string_schema.typ == 'string'
	
	int_schema := d.create_mcp_tool_input_schema('int') or { panic(err) }
	assert int_schema.typ == 'integer'
	
	float_schema := d.create_mcp_tool_input_schema('float') or { panic(err) }
	assert float_schema.typ == 'number'
	
	bool_schema := d.create_mcp_tool_input_schema('bool') or { panic(err) }
	assert bool_schema.typ == 'boolean'
	
	// Test case 2: Array type
	array_schema := d.create_mcp_tool_input_schema('[]string') or { panic(err) }
	assert array_schema.typ == 'array'
	// In our implementation, arrays don't have items directly in the schema
	
	// Test case 3: Struct type
	struct_def := 'pub struct Person {
		name string
		age int
	}'
	
	struct_schema := d.create_mcp_tool_input_schema(struct_def) or { panic(err) }
	assert struct_schema.typ == 'object'
	assert struct_schema.properties.len == 2
	assert struct_schema.properties['name'].typ == 'string'
	assert struct_schema.properties['age'].typ == 'integer'
	
	println('test_create_mcp_tool_input_schema passed')
}

fn test_create_mcp_tool() {
	d := Developer{}
	
	// Test case 1: Simple function with primitive types
	simple_fn := '// Get user by ID
// Returns user information
pub fn get_user(id int, include_details bool) {
	// Implementation
}'
	
	tool1 := d.create_mcp_tool(simple_fn, {}) or { panic(err) }
	assert tool1.name == 'get_user'
	expected_desc1 := "Get user by ID\nReturns user information"
	assert tool1.description == expected_desc1
	assert tool1.input_schema.typ == 'object'
	assert tool1.input_schema.properties.len == 2
	assert tool1.input_schema.properties['id'].typ == 'integer'
	assert tool1.input_schema.properties['include_details'].typ == 'boolean'
	assert tool1.input_schema.required.len == 2
	assert 'id' in tool1.input_schema.required
	assert 'include_details' in tool1.input_schema.required
	
	// Test case 2: Method with receiver
	method_fn := '// Update user profile
pub fn (u User) update_profile(name string, age int) bool {
	// Implementation
	return true
}'
	
	tool2 := d.create_mcp_tool(method_fn, {}) or { panic(err) }
	assert tool2.name == 'update_profile'
	assert tool2.description == 'Update user profile'
	assert tool2.input_schema.properties.len == 2
	assert tool2.input_schema.properties['name'].typ == 'string'
	assert tool2.input_schema.properties['age'].typ == 'integer'
	
	// Test case 3: Function with complex types
	complex_fn := '// Create new configuration
// Sets up system configuration
fn create_config(name string, settings Config) !Config {
	// Implementation
}'
	
	config_struct := 'pub struct Config {
		server_url string
		max_retries int
		timeout float
	}'
	
	tool3 := d.create_mcp_tool(complex_fn, {'Config': config_struct}) or { panic(err) }
	assert tool3.name == 'create_config'
	expected_desc3 := "Create new configuration\nSets up system configuration"
	assert tool3.description == expected_desc3
	assert tool3.input_schema.properties.len == 2
	assert tool3.input_schema.properties['name'].typ == 'string'
	assert tool3.input_schema.properties['settings'].typ == 'object'
	
	// Test case 4: Function with no parameters
	no_params_fn := '// Initialize system
pub fn initialize() {
	// Implementation
}'
	
	tool4 := d.create_mcp_tool(no_params_fn, {}) or { panic(err) }
	assert tool4.name == 'initialize'
	assert tool4.description == 'Initialize system'
	assert tool4.input_schema.properties.len == 0
	assert tool4.input_schema.required.len == 0
	
	println('test_create_mcp_tool passed')
}


fn test_create_mcp_tool_code() {
	d := Developer{}
	
	// Test with the complex function that has struct parameters and return type
	module_path := '${os.dir(@FILE)}/testdata/mock_module'
	function_name := 'test_function'
	
	code := d.create_mcp_tool_code(function_name, module_path) or {
		panic('Failed to create MCP tool code: ${err}')
	}
	panic(code)
	
	// // Verify the generated code contains the expected elements
	// assert code.contains('test_function_tool')
	// assert code.contains('TestConfig')
	// assert code.contains('TestResult')
	
	// // Test with a simple function that has primitive types
	// simple_function_name := 'simple_function'
	// simple_code := d.create_mcp_tool_code(simple_function_name, module_path) or {
	// 	panic('Failed to create MCP tool code for simple function: ${err}')
	// }
	
	// // Verify the simple function code
	// assert simple_code.contains('simple_function_tool')
	// assert simple_code.contains('name string')
	// assert simple_code.contains('count int')
	
	// println('test_create_mcp_tool_code passed')
}

// Run all tests
fn main() {
	test_parse_struct_fields()
	test_create_mcp_tool_input_schema()
	test_create_mcp_tool()
	test_create_mcp_tool_code()
	
	println('All tests passed successfully!')
}
