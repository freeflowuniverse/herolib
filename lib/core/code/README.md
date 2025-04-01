# Code Model

A set of models that represent code, such as structs and functions. The motivation behind this module is to provide a more generic, and lighter alternative to v.ast code models, that can be used for code parsing and code generation across multiple languages.

## Using Codemodel

While the models in this module can be used in any domain, the models here are used extensively in the modules [codeparser](../codeparser/) and codegen (under development). Below are examples on how codemodel can be used for parsing and generating code.
## Code parsing with codemodel

As shown in the example below, the codemodels returned by the parser can be used to infer information about the code written

```js
code := codeparser.parse("somedir") // code is a list of code models

num_functions := code.filter(it is Function).len
structs := code.filter(it is Struct)
println("This directory has ${num_functions} functions")
println('The directory has the structs: ${structs.map(it.name)}')

```

or can be used as intermediate structures to serialize code into some other format:

```js
code_md := ''

// describes the struct in markdown format
for struct in structs {
    code_md += '# ${struct.name}'
    code_md += 'Type: ${struct.typ.symbol()}'
    code_md += '## Fields:'
    for field in struct.fields {
        code_md += '- ${field.name}'
    }
}
```

The [openrpc/docgen](../openrpc/docgen/) module demonstrates a good use case, where codemodels are serialized into JSON schema's, to generate an OpenRPC description document from a client in v.## V Language Utilities

The `vlang_utils.v` file provides a set of utility functions for working with V language files and code. These utilities are useful for:

1. **File Operations**
   - `list_v_files(dir string) ![]string` - Lists all V files in a directory, excluding generated files
   - `get_module_dir(mod string) string` - Converts a V module path to a directory path

2. **Code Inspection and Analysis**
   - `get_function_from_file(file_path string, function_name string) !string` - Extracts a function definition from a file
   - `get_function_from_module(module_path string, function_name string) !string` - Searches for a function across all files in a module
   - `get_type_from_module(module_path string, type_name string) !string` - Searches for a type definition across all files in a module

3. **V Language Tools**
   - `vtest(fullpath string) !string` - Runs V tests on files or directories
   - `vvet(fullpath string) !string` - Runs V vet on files or directories

### Example Usage

```v
// Find and extract a function definition
function_def := code.get_function_from_module('/path/to/module', 'my_function') or {
    eprintln('Could not find function: ${err}')
    return
}
println(function_def)

// Run tests on a directory
test_results := code.vtest('/path/to/module') or {
    eprintln('Tests failed: ${err}')
    return
}
println(test_results)
```

These utilities are particularly useful when working with code generation, static analysis, or when building developer tools that need to inspect V code.
