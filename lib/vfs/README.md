# Virtual File System (VFS) Module

This module provides a pluggable virtual filesystem interface that allows different storage backends to implement a common set of filesystem operations.

## Interface

The VFS interface (`VFSImplementation`) defines the following operations:

### Basic Operations
- `root_get() !FSEntry` - Get the root directory entry

### File Operations
- `file_create(path string) !FSEntry` - Create a new file
- `file_read(path string) ![]u8` - Read file contents as bytes
- `file_write(path string, data []u8) !` - Write bytes to a file
- `file_delete(path string) !` - Delete a file

### Directory Operations
- `dir_create(path string) !FSEntry` - Create a new directory
- `dir_list(path string) ![]FSEntry` - List directory contents
- `dir_delete(path string) !` - Delete a directory

### Symlink Operations
- `link_create(target_path string, link_path string) !FSEntry` - Create a symbolic link
- `link_read(path string) !string` - Read symlink target
- `link_delete(path string) !` - Delete a symlink

### Common Operations
- `exists(path string) bool` - Check if path exists
- `get(path string) !FSEntry` - Get entry at path
- `rename(old_path string, new_path string) !FSEntry` - Rename/move an entry
- `copy(src_path string, dst_path string) !FSEntry` - Copy an entry
- `move(src_path string, dst_path string) !FSEntry` - Move an entry
- `delete(path string) !` - Delete any type of entry
- `destroy() !` - Clean up VFS resources

## FSEntry Interface

All filesystem entries implement the FSEntry interface:

```v
interface FSEntry {
    get_metadata() Metadata
    get_path() string
    is_dir() bool
    is_file() bool
    is_symlink() bool
}
```

## Implementations

### Local Filesystem (vfs_local)
Direct passthrough to the operating system's filesystem.

Features:
- Native filesystem access
- Full POSIX compliance
- Preserves file permissions and metadata

### Database Filesystem (vfs_db) 
Stores files and metadata in a database backend.

Features:
- Persistent storage in database
- Transactional operations
- Structured metadata storage

### Nested Filesystem (vfs_nested)
Allows mounting other VFS implementations at specific paths.

Features:
- Composite filesystem views
- Mix different implementations
- Flexible organization

## Implementation Standards

When creating a new VFS implementation:

1. Directory Structure:
```
vfs_<name>/
├── factory.v           # Implementation factory/constructor
├── vfs_implementation.v # Core interface implementation
├── model_*.v          # Data structure definitions
├── README.md          # Implementation documentation
└── *_test.v          # Tests
```

2. Naming Conventions:
- Implementation module: `vfs_<name>`
- Main struct: `<Name>VFS` (e.g., LocalVFS, DatabaseVFS)
- Factory function: `new_<name>_vfs()`

3. Error Handling:
- Use descriptive error messages
- Include path information in errors
- Handle edge cases (e.g., missing files, type mismatches)

4. Documentation:
- Document implementation-specific behavior
- Note any limitations or special features
- Include usage examples

## Usage Example

```v
import vfs

fn main() ! {
    // Create a local filesystem implementation
    mut fs := vfs.new_vfs('local', '/tmp/test')!
    
    // Create and write to a file
    fs.file_create('test.txt')!
    fs.file_write('test.txt', 'Hello, World!'.bytes())!
    
    // Read file contents
    content := fs.file_read('test.txt')!
    println(content.bytestr())
    
    // Create and list directory
    fs.dir_create('subdir')!
    entries := fs.dir_list('subdir')!
    
    // Create symlink
    fs.link_create('test.txt', 'test_link.txt')!
    
    // Clean up
    fs.destroy()!
}
```

## Contributing

To add a new VFS implementation:

1. Create a new directory `vfs_<name>` following the structure above
2. Implement the `VFSImplementation` interface
3. Add factory function to create your implementation
4. Include comprehensive tests
5. Document implementation details and usage
6. Update the main VFS documentation

## Testing

Each implementation must include tests that verify:
- All interface methods
- Error conditions
- Edge cases
- Implementation-specific features

Run tests with:
```bash
v test vfs/
