# Code Model

A set of models that represent code structures, such as structs, functions, imports, and constants. The motivation behind this module is to provide a more generic and lighter alternative to v.ast code models, that can be used for code parsing and code generation across multiple languages.

## Features

- **Struct Modeling**: Complete struct representation including:
  - Fields with types, visibility, and mutability
  - Embedded structs
  - Generic type support
  - Attributes
  - Documentation comments

- **Function Modeling**: Comprehensive function support with:
  - Parameters and return types
  - Receiver methods
  - Optional and result types
  - Function body content
  - Visibility modifiers

- **Type System**: Rich type representation including:
  - Basic types
  - Reference types
  - Arrays and maps
  - Optional and result types
  - Mutable and shared types

- **Code Organization**:
  - Import statements with module and type specifications
  - Constants (both single and grouped)
  - Custom code blocks for specialized content
  - Documentation through single and multi-line comments

## Using Codemodel

The codemodel module provides a set of types and utilities for working with code structures. Here are some examples of how to use the module:

### Working with Functions

```v
// Parse a function definition
fn_def := 'pub fn (mut app App) process() !string'
function := codemodel.parse_function(fn_def)!
println(function.name) // prints: process
println(function.receiver.name) // prints: app
println(function.result.typ.symbol) // prints: string

// Create a function model
my_fn := Function{
    name: 'add'
    is_pub: true
    params: [
        Param{
            name: 'x'
            typ: Type{symbol: 'int'}
        },
        Param{
            name: 'y'
            typ: Type{symbol: 'int'}
        }
    ]
    result: Result{
        typ: Type{symbol: 'int'}
    }
    body: 'return x + y'
}
```

### Working with Imports

```v
// Parse an import statement
import_def := 'import os { exists }'
imp := codemodel.parse_import(import_def)
println(imp.mod) // prints: os
println(imp.types) // prints: ['exists']

// Create an import model
my_import := Import{
    mod: 'json'
    types: ['encode', 'decode']
}
```

### Working with Constants

```v
// Parse constant definitions
const_def := 'const max_size = 1000'
constant := codemodel.parse_const(const_def)!
println(constant.name) // prints: max_size
println(constant.value) // prints: 1000

// Parse grouped constants
const_block := 'const (
    pi = 3.14
    e = 2.718
)'
constants := codemodel.parse_consts(const_block)!
```

### Working with Types

The module provides rich type modeling capabilities:

```v
// Basic type
basic := Type{
    symbol: 'string'
}

// Array type
array := Type{
    symbol: 'string'
    is_array: true
}

// Optional type
optional := Type{
    symbol: 'int'
    is_optional: true
}

// Result type
result := Type{
    symbol: 'string'
    is_result: true
}
```

## Code Generation

The codemodel types can be used as intermediate structures for code generation. For example, generating documentation:

```v
mut doc := ''

// Document a struct
for field in my_struct.fields {
    doc += '- ${field.name}: ${field.typ.symbol}'
    if field.description != '' {
        doc += ' // ${field.description}'
    }
    doc += '\n'
}
```

The codemodel module provides a foundation for building tools that need to work with code structures, whether for analysis, transformation, or generation purposes.
