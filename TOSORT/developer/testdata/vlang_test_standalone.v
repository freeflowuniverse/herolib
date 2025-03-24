module main

import os

// Standalone test for the get_type_from_module function
// This file can be run directly with: v run vlang_test_standalone.v

// Implementation of get_type_from_module function
fn get_type_from_module(module_path string, type_name string) !string {
	v_files := list_v_files(module_path) or {
		return error('Failed to list V files in ${module_path}: ${err}')
	}

	for v_file in v_files {
		content := os.read_file(v_file) or { return error('Failed to read file ${v_file}: ${err}') }

		type_str := 'struct ${type_name} {'
		i := content.index(type_str) or { -1 }
		if i == -1 {
			continue
		}

		start_i := i + type_str.len
		closing_i := find_closing_brace(content, start_i) or {
			return error('could not find where declaration for type ${type_name} ends')
		}

		return content.substr(start_i, closing_i + 1)
	}

	return error('type ${type_name} not found in module ${module_path}')
}

// Helper function to find the closing brace
fn find_closing_brace(content string, start_i int) ?int {
	mut brace_count := 1
	for i := start_i; i < content.len; i++ {
		if content[i] == `{` {
			brace_count++
		} else if content[i] == `}` {
			brace_count--
			if brace_count == 0 {
				return i
			}
		}
	}
	return none
}

// Helper function to list V files
fn list_v_files(dir string) ![]string {
	files := os.ls(dir) or { return error('Error listing directory: ${err}') }

	mut v_files := []string{}
	for file in files {
		if file.ends_with('.v') && !file.ends_with('_.v') {
			filepath := os.join_path(dir, file)
			v_files << filepath
		}
	}

	return v_files
}

// Helper function to create test files with struct definitions
fn create_test_files() !(string, string, string) {
	// Create a temporary directory for our test files
	test_dir := os.temp_dir()
	test_file_path := os.join_path(test_dir, 'test_type.v')

	// Create a test file with a simple struct
	test_content := 'module test_module

struct TestType {
	name string
	age int
	active bool
}

// Another struct to make sure we get the right one
struct OtherType {
	id string
}
'
	os.write_file(test_file_path, test_content) or {
		eprintln('Failed to create test file: ${err}')
		return error('Failed to create test file: ${err}')
	}

	// Create a test file with a nested struct
	nested_test_content := 'module test_module

struct NestedType {
	config map[string]string {
		required: true
	}
	data []struct {
		key string
		value string
	}
}
'
	nested_test_file := os.join_path(test_dir, 'nested_test.v')
	os.write_file(nested_test_file, nested_test_content) or {
		eprintln('Failed to create nested test file: ${err}')
		return error('Failed to create nested test file: ${err}')
	}

	return test_dir, test_file_path, nested_test_file
}

// Test function for get_type_from_module
fn test_get_type_from_module() {
	// Create test files
	test_dir, test_file_path, nested_test_file := create_test_files() or {
		eprintln('Failed to create test files: ${err}')
		assert false
		return
	}

	// Test case 1: Get a simple struct
	type_content := get_type_from_module(test_dir, 'TestType') or {
		eprintln('Failed to get type: ${err}')
		assert false
		return
	}

	// Verify the content matches what we expect
	expected := '\n\tname string\n\tage int\n\tactive bool\n}'
	assert type_content == expected, 'Expected: "${expected}", got: "${type_content}"'

	// Test case 2: Try to get a non-existent type
	non_existent := get_type_from_module(test_dir, 'NonExistentType') or {
		// This should fail, so we expect an error
		assert err.str().contains('not found in module'), 'Expected error message about type not found'
		''
	}
	assert non_existent == '', 'Expected empty string for non-existent type'

	// Test case 3: Test with nested braces in the struct
	nested_type_content := get_type_from_module(test_dir, 'NestedType') or {
		eprintln('Failed to get nested type: ${err}')
		assert false
		return
	}

	expected_nested := '\n\tconfig map[string]string {\n\t\trequired: true\n\t}\n\tdata []struct {\n\t\tkey string\n\t\tvalue string\n\t}\n}'
	assert nested_type_content == expected_nested, 'Expected: "${expected_nested}", got: "${nested_type_content}"'

	// Clean up test files
	os.rm(test_file_path) or {}
	os.rm(nested_test_file) or {}

	println('All tests for get_type_from_module passed successfully!')
}

fn main() {
	test_get_type_from_module()
}
