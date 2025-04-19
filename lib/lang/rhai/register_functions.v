module rhai

import strings

// generate_rhai_function_registration generates Rust code to register a list of functions with Rhai.
// Input: module_name - The name for the registration function (e.g., "nerdctl" -> register_nerdctl_module).
// Input: function_names - A list of Rust function names to register.
// Output: A string containing the generated Rust registration function, or an error string.
pub fn generate_rhai_function_registration(module_name string, function_names []string) !string {
	if module_name.len == 0 {
		return error('module_name cannot be empty')
	}
	if function_names.len == 0 {
		return error('function_names cannot be empty')
	}

	mut sb := strings.new_builder(1024)
	module_name_lower := module_name.to_lower()

	sb.writeln('pub fn register_${module_name_lower}_module(engine: &mut Engine) -> Result<(), Box<EvalAltResult>> {')

	// Register each function
	for fn_name in function_names {
		sb.writeln('\tengine.register_fn("${fn_name}", ${fn_name});')
	}

	sb.writeln('\tOk(())')
	sb.writeln('}')

	return sb.str()
}
