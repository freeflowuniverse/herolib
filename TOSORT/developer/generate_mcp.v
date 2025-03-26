module developer

import freeflowuniverse.herolib.core.code
import freeflowuniverse.herolib.mcp
import os

// create_mcp_tool_code receives the name of a V language function string, and the path to the module in which it exists.
// returns an MCP Tool code in v for attaching the function to the mcp server
pub fn (d &Developer) create_mcp_tool_code(function_name string, module_path string) !string {
	println('DEBUG: Looking for function ${function_name} in module path: ${module_path}')
	if !os.exists(module_path) {
		println('DEBUG: Module path does not exist: ${module_path}')
		return error('Module path does not exist: ${module_path}')
	}
	
	function_ := get_function_from_module(module_path, function_name)!
	println('Function string found:\n${function_}')
	
	// Try to parse the function
	function := code.parse_function(function_) or {
		println('Error parsing function: ${err}')
		return error('Failed to parse function: ${err}')
	}

	mut types := map[string]string{}
	for param in function.params {
		// Check if the type is an Object (struct)
		if param.typ is code.Object {
			types[param.typ.symbol()] = get_type_from_module(module_path, param.typ.symbol())!
		}
	}
	
	// Get the result type if it's a struct
	mut result_ := ""
	if function.result.typ is code.Result {
		result_type := (function.result.typ as code.Result).typ
		if result_type is code.Object {
			result_ = get_type_from_module(module_path, result_type.symbol())!
		}
	} else if function.result.typ is code.Object {
		result_ = get_type_from_module(module_path, function.result.typ.symbol())!
	}

	tool_name := function.name
	tool := d.create_mcp_tool(function_, types)!
	handler := d.create_mcp_tool_handler(function_, types, result_)!
	str := $tmpl('./templates/tool_code.v.template')
	return str
}

// create_mcp_tool parses a V language function string and returns an MCP Tool struct
// function: The V function string including preceding comments
// types: A map of struct names to their definitions for complex parameter types
// result: The type of result of the create_mcp_tool function. Could be simply string, or struct {...}
pub fn (d &Developer) create_mcp_tool_handler(function_ string, types map[string]string, result_ string) !string {
	function := code.parse_function(function_)!
	decode_stmts := function.params.map(argument_decode_stmt(it)).join_lines()
	
	result := code.parse_type(result_)
	str := $tmpl('./templates/tool_handler.v.template')
	return str
}

pub fn argument_decode_stmt(param code.Param) string {
	return if param.typ is code.Integer {
		'${param.name} := arguments["${param.name}"].int()'
	} else if param.typ is code.Boolean {
		'${param.name} := arguments["${param.name}"].bool()'
	} else if param.typ is code.String {
		'${param.name} := arguments["${param.name}"].str()'
	} else if param.typ is code.Object {
		'${param.name} := json.decode[${param.typ.symbol()}](arguments["${param.name}"].str())!'
	} else if param.typ is code.Array {
		'${param.name} := json.decode[${param.typ.symbol()}](arguments["${param.name}"].str())!'
	} else if param.typ is code.Map {
		'${param.name} := json.decode[${param.typ.symbol()}](arguments["${param.name}"].str())!'
	} else {
		panic('Unsupported type: ${param.typ}')
	}
}
/*
in @generate_mcp.v , implement a create_mpc_tool_handler function that given a vlang function string and the types  that map to their corresponding type definitions (for instance struct some_type: SomeType{...}), generates a vlang function such as the following:

ou
pub fn (d &Developer) create_mcp_tool_tool_handler(arguments map[string]Any) !mcp.Tool {
	function := arguments['function'].str()
	types := json.decode[map[string]string](arguments['types'].str())!
	return d.create_mcp_tool(function, types)
}
*/


// create_mcp_tool parses a V language function string and returns an MCP Tool struct
// function: The V function string including preceding comments
// types: A map of struct names to their definitions for complex parameter types
pub fn (d Developer) create_mcp_tool(function string, types map[string]string) !mcp.Tool {
	// Extract description from preceding comments
	mut description := ''
	lines := function.split('\n')
	
	// Find function signature line
	mut fn_line_idx := -1
	for i, line in lines {
		if line.trim_space().starts_with('fn ') || line.trim_space().starts_with('pub fn ') {
			fn_line_idx = i
			break
		}
	}
	
	if fn_line_idx == -1 {
		return error('Invalid function: no function signature found')
	}
	
	// Extract comments before the function
	for i := 0; i < fn_line_idx; i++ {
		line := lines[i].trim_space()
		if line.starts_with('//') {
			// Remove the comment marker and any leading space
			comment := line[2..].trim_space()
			if description != '' {
				description += '\n'
			}
			description += comment
		}
	}
	
	// Parse function signature
	fn_signature := lines[fn_line_idx].trim_space()
	
	// Extract function name
	mut fn_name := ''
	
	// Check if this is a method with a receiver
	if fn_signature.contains('fn (') {
		// This is a method with a receiver
		// Format: [pub] fn (receiver Type) name(...)
		
		// Find the closing parenthesis of the receiver
		mut receiver_end := fn_signature.index(')') or { return error('Invalid method signature: missing closing parenthesis for receiver') }
		
		// Extract the text after the receiver
		mut after_receiver := fn_signature[receiver_end + 1..].trim_space()
		
		// Extract the function name (everything before the opening parenthesis)
		mut params_start := after_receiver.index('(') or { return error('Invalid method signature: missing parameters') }
		fn_name = after_receiver[0..params_start].trim_space()
	} else if fn_signature.starts_with('pub fn ') {
		// Regular public function
		mut prefix_len := 'pub fn '.len
		mut params_start := fn_signature.index('(') or { return error('Invalid function signature: missing parameters') }
		fn_name = fn_signature[prefix_len..params_start].trim_space()
	} else if fn_signature.starts_with('fn ') {
		// Regular function
		mut prefix_len := 'fn '.len
		mut params_start := fn_signature.index('(') or { return error('Invalid function signature: missing parameters') }
		fn_name = fn_signature[prefix_len..params_start].trim_space()
	} else {
		return error('Invalid function signature: must start with "fn" or "pub fn"')
	}
	
	if fn_name == '' {
		return error('Could not extract function name')
	}
	
	// Extract parameters
	mut params_str := ''
	
	// Check if this is a method with a receiver
	if fn_signature.contains('fn (') {
		// This is a method with a receiver
		// Find the closing parenthesis of the receiver
		mut receiver_end := fn_signature.index(')') or { return error('Invalid method signature: missing closing parenthesis for receiver') }
		
		// Find the opening parenthesis of the parameters
		mut params_start := -1
		for i := receiver_end + 1; i < fn_signature.len; i++ {
			if fn_signature[i] == `(` {
				params_start = i
				break
			}
		}
		if params_start == -1 {
			return error('Invalid method signature: missing parameter list')
		}
		
		// Find the closing parenthesis of the parameters
		mut params_end := fn_signature.last_index(')') or { return error('Invalid method signature: missing closing parenthesis for parameters') }
		
		// Extract the parameters
		params_str = fn_signature[params_start + 1..params_end].trim_space()
	} else {
		// Regular function
		mut params_start := fn_signature.index('(') or { return error('Invalid function signature: missing parameters') }
		mut params_end := fn_signature.last_index(')') or { return error('Invalid function signature: missing closing parenthesis') }
		
		// Extract the parameters
		params_str = fn_signature[params_start + 1..params_end].trim_space()
	}
	
	// Create input schema for parameters
	mut properties := map[string]mcp.ToolProperty{}
	mut required := []string{}
	
	if params_str != '' {
		param_list := params_str.split(',')
		
		for param in param_list {
			trimmed_param := param.trim_space()
			if trimmed_param == '' {
				continue
			}
			
			// Split parameter into name and type
			param_parts := trimmed_param.split_any(' \t')
			if param_parts.len < 2 {
				continue
			}
			
			param_name := param_parts[0]
			param_type := param_parts[1]
			
			// Add to required parameters
			required << param_name
			
			// Create property for this parameter
			mut property := mcp.ToolProperty{}
			
			// Check if this is a complex type defined in the types map
			if param_type in types {
				// Parse the struct definition to create a nested schema
				struct_def := types[param_type]
				struct_schema := d.create_mcp_tool_input_schema(struct_def)!
				property = mcp.ToolProperty{
					typ: struct_schema.typ
				}
			} else {
				// Handle primitive types
				schema := d.create_mcp_tool_input_schema(param_type)!
				property = mcp.ToolProperty{
					typ: schema.typ
				}
			}
			
			properties[param_name] = property
		}
	}
	
	// Create the input schema
	input_schema := mcp.ToolInputSchema{
		typ: 'object',
		properties: properties,
		required: required
	}
	
	// Create and return the Tool
	return mcp.Tool{
		name: fn_name,
		description: description,
		input_schema: input_schema
	}
}

// create_mcp_tool_input_schema creates a ToolInputSchema for a given input type
// input: The input type string
// returns: A ToolInputSchema for the given input type
// errors: Returns an error if the input type is not supported
pub fn (d Developer) create_mcp_tool_input_schema(input string) !mcp.ToolInputSchema {
	
	// if input is a primitive type, return a mcp ToolInputSchema with that type
	if input == 'string' {
		return mcp.ToolInputSchema{
			typ: 'string'
		}
	} else if input == 'int' {
		return mcp.ToolInputSchema{
			typ: 'integer'
		}
	} else if input == 'float' {
		return mcp.ToolInputSchema{
			typ: 'number'
		}
	} else if input == 'bool' {
		return mcp.ToolInputSchema{
			typ: 'boolean'
		}
	}
	
	// if input is a struct, return a mcp ToolInputSchema with typ 'object' and properties for each field in the struct
	if input.starts_with('pub struct ') {
		struct_name := input[11..].split(' ')[0]
		fields := parse_struct_fields(input)
		mut properties := map[string]mcp.ToolProperty{}
		
		for field_name, field_type in fields {
			property := mcp.ToolProperty{
				typ: d.create_mcp_tool_input_schema(field_type)!.typ
			}
			properties[field_name] = property
		}
		
		return mcp.ToolInputSchema{
			typ: 'object',
			properties: properties
		}
	}
	
	// if input is an array, return a mcp ToolInputSchema with typ 'array' and items of the item type
	if input.starts_with('[]') {
		item_type := input[2..]
		
		// For array types, we create a schema with type 'array'
		// The actual item type is determined by the primitive type
		mut item_type_str := 'string' // default
		if item_type == 'int' {
			item_type_str = 'integer'
		} else if item_type == 'float' {
			item_type_str = 'number'
		} else if item_type == 'bool' {
			item_type_str = 'boolean'
		}
		
		// Create a property for the array items
		mut property := mcp.ToolProperty{
			typ: 'array'
		}
		
		// Add the property to the schema
		mut properties := map[string]mcp.ToolProperty{}
		properties['items'] = property
		
		return mcp.ToolInputSchema{
			typ: 'array',
			properties: properties
		}
	}
	
	// Default to string type for unknown types
	return mcp.ToolInputSchema{
		typ: 'string'
	}
}


// parse_struct_fields parses a V language struct definition string and returns a map of field names to their types
fn parse_struct_fields(struct_def string) map[string]string {
	mut fields := map[string]string{}
	
	// Find the opening and closing braces of the struct definition
	start_idx := struct_def.index('{') or { return fields }
	end_idx := struct_def.last_index('}') or { return fields }
	
	// Extract the content between the braces
	struct_content := struct_def[start_idx + 1..end_idx].trim_space()
	
	// Split the content by newlines to get individual field definitions
	field_lines := struct_content.split('
')
	
	for line in field_lines {
		trimmed_line := line.trim_space()
		
		// Skip empty lines and comments
		if trimmed_line == '' || trimmed_line.starts_with('//') {
			continue
		}
		
		// Handle pub: or mut: prefixes
		mut field_def := trimmed_line
		if field_def.starts_with('pub:') || field_def.starts_with('mut:') {
			field_def = field_def.all_after(':').trim_space()
		}
		
		// Split by whitespace to separate field name and type
		parts := field_def.split_any(' 	')
		if parts.len < 2 {
			continue
		}
		
		field_name := parts[0]
		field_type := parts[1..].join(' ')
		
		// Handle attributes like @[json: 'name']
		if field_name.contains('@[') {
			continue
		}
		
		fields[field_name] = field_type
	}
	
	return fields
}
