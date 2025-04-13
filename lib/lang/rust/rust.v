module rust

import os

// Reads and combines all Rust files in the given directory
pub fn read_source_code(source_code_path string) !string {
    // Get all files in the directory
    files := os.ls(source_code_path) or {
        return error('Failed to list files in directory: ${err}')
    }
    
    // Combine all Rust files into a single source code string
    mut source_code := ''
    for file in files {
        file_path := os.join_path(source_code_path, file)
        
        // Skip directories and non-Rust files
        if os.is_dir(file_path) || !file.ends_with('.rs') {
            continue
        }
        
        // Read the file content
        file_content := os.read_file(file_path) or {
            println('Failed to read file ${file_path}: ${err}')
            continue
        }
        
        // Add file content to the combined source code
        source_code += '// File: ${file}\n${file_content}\n\n'
    }
    
    if source_code == '' {
        return error('No Rust files found in directory: ${source_code_path}')
    }
    
    return source_code
}

// Determines the crate path from the source code path
pub fn determine_crate_path(source_code_path string) !string {
    // Extract the path relative to the src directory
    src_index := source_code_path.index('src/') or {
        return error('Could not determine crate path: src/ not found in path')
    }
    
    mut path_parts := source_code_path[src_index+4..].split('/')
    // Remove the last part (the file name)
    if path_parts.len > 0 {
        path_parts.delete_last()
    }
    rel_path := path_parts.join('::')
    return 'sal::${rel_path}'
}

// Extracts the module name from a directory path
pub fn extract_module_name_from_path(path string) string {
    dir_parts := path.split('/')
    return dir_parts[dir_parts.len - 1]
}

// Build and run a Rust project with an example
pub fn run_example(project_dir string, example_name string) !(string, string) {
    // Change to the project directory
    os.chdir(project_dir) or {
        return error('Failed to change directory to project: ${err}')
    }
    
    // Run cargo build first
    build_result := os.execute('cargo build')
    if build_result.exit_code != 0 {
        return error('Compilation failed. Please fix the following errors and ensure your code is compatible with the existing codebase:\n\n${build_result.output}')
    }
    
    // Run the example
    run_result := os.execute('cargo run --example ${example_name}')
    
    return build_result.output, run_result.output
}


// Extract function names from wrapper code
fn extract_functions_from_code(code string) []string {
    mut functions := []string{}
    lines := code.split('\n')
    
    for line in lines {
        if line.contains('pub fn ') && !line.contains('//') {
            // Extract function name
            parts := line.split('pub fn ')
            if parts.len > 1 {
                name_parts := parts[1].split('(')
                if name_parts.len > 0 {
                    fn_name := name_parts[0].trim_space()
                    if fn_name != '' {
                        functions << fn_name
                    }
                }
            }
        }
    }
    
    return functions
}