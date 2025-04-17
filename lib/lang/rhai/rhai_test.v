module rhai

import freeflowuniverse.herolib.lang.rhai
// import os // Unused, remove later if not needed

fn testsuite_begin() {
    // Optional: Setup code before tests run
}

fn testsuite_end() {
    // Optional: Teardown code after tests run
}

fn test_generate_wrapper_simple_function() {
    rust_fn := 'pub fn add(a: i32, b: i32) -> i32'
    expected_wrapper := 'pub fn add(a: i64, b: i64) -> Result<i64, Box<EvalAltResult>> {\n    // Assuming the function exists in the scope where the wrapper is defined\n    Ok(add(a, b))\n}'

    actual_wrapper := rhai.generate_rhai_function_wrapper(rust_function: rust_fn, struct_declarations: []string{}) or {
        assert false, 'Function returned error: ${err}'
        return // Needed for compiler
    }
    // Normalize whitespace for comparison
    assert actual_wrapper.trim_space() == expected_wrapper.trim_space()
}

fn test_generate_wrapper_immutable_method() {
    rust_fn := 'pub fn get_name(&self) -> String'
    // receiver := 'MyStruct' // No longer passed directly
    struct_decls := ['struct MyStruct { name: String }'] // Example declaration
    expected_wrapper := 'pub fn get_name(receiver: &MyStruct) -> Result<String, Box<EvalAltResult>> {\n    Ok(receiver.get_name())\n}'

    actual_wrapper := rhai.generate_rhai_function_wrapper(rust_function: rust_fn, struct_declarations: struct_decls) or {
        assert false, 'Function returned error: ${err}'
        return
    }
    assert actual_wrapper.trim_space() == expected_wrapper.trim_space()
}

fn test_generate_wrapper_mutable_method() {
    rust_fn := 'pub fn set_name(&mut self, new_name: String)' // Implicit () return
    // receiver := 'MyStruct' // No longer passed directly
    struct_decls := ['struct MyStruct { name: String }'] // Example declaration
    expected_wrapper := 'pub fn set_name(receiver: &mut MyStruct, new_name: String) -> Result<(), Box<EvalAltResult>> {\n    Ok(receiver.set_name(new_name))\n}'

    actual_wrapper := rhai.generate_rhai_function_wrapper(rust_function: rust_fn, struct_declarations: struct_decls) or {
        assert false, 'Function returned error: ${err}'
        return
    }
    assert actual_wrapper.trim_space() == expected_wrapper.trim_space()
}

fn test_generate_wrapper_function_returning_result() {
    rust_fn := 'pub fn load_config(path: &str) -> Result<Config, io::Error>'
    // receiver := '' // No longer relevant
    struct_decls := ['struct Config { ... }'] // Example placeholder declaration
    expected_wrapper := 'pub fn load_config(path: &str) -> Result<Config, Box<EvalAltResult>> {\n    load_config(path)\n        .map_err(|e| Box::new(EvalAltResult::ErrorRuntime(format!("Error in load_config: {}", e).into(), rhai::Position::NONE)))\n}'

    actual_wrapper := rhai.generate_rhai_function_wrapper(rust_function: rust_fn, struct_declarations: struct_decls) or {
        assert false, 'Function returned error: ${err}'
        return
    }
    assert actual_wrapper.trim_space() == expected_wrapper.trim_space()
}

fn test_generate_wrapper_function_returning_pathbuf() {
    rust_fn := 'pub fn get_home_dir() -> PathBuf'
    // receiver := '' // No longer relevant
    struct_decls := []string{} // No relevant structs
    // Expecting conversion to String for Rhai
    expected_wrapper := 'pub fn get_home_dir() -> Result<String, Box<EvalAltResult>> {\n    Ok(get_home_dir().to_string_lossy().to_string())\n}'
    actual_wrapper := rhai.generate_rhai_function_wrapper(rust_function: rust_fn, struct_declarations: struct_decls) or {
        assert false, 'Function returned error: ${err}'
        return
    }
    assert actual_wrapper.trim_space() == expected_wrapper.trim_space()
}

fn test_generate_wrapper_function_with_vec() {
    rust_fn := 'pub fn list_files(dir: &str) -> Vec<String>'
    // receiver := '' // No longer relevant
    struct_decls := []string{} // No relevant structs
    // Expecting Vec<String> to map directly
    expected_wrapper := 'pub fn list_files(dir: &str) -> Result<Vec<String>, Box<EvalAltResult>> {\n    Ok(list_files(dir))\n}'
    actual_wrapper := rhai.generate_rhai_function_wrapper(rust_function: rust_fn, struct_declarations: struct_decls) or {
        assert false, 'Function returned error: ${err}'
        return
    }
    assert actual_wrapper.trim_space() == expected_wrapper.trim_space()
}
