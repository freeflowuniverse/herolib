# Local Filesystem Implementation (vfs_local)

The LocalVFS implementation provides a direct passthrough to the operating system's filesystem. It implements all VFS operations by delegating to the corresponding OS filesystem operations.

## Features

- Native filesystem access with full POSIX compliance
- Preserves file permissions and metadata
- Efficient direct access to local files
- Support for all VFS operations including symlinks
- Path-based access relative to root directory

## Implementation Details

### Structure
```
vfs_local/
├── factory.v               # VFS factory implementation
├── vfs_implementation.v    # Core VFS interface implementation
├── vfs_local.v            # LocalVFS type definition
├── model_fsentry.v        # FSEntry implementation
└── vfs_implementation_test.v  # Implementation tests
```

### Key Components

- `LocalVFS`: Main implementation struct that handles filesystem operations
- `LocalFSEntry`: Implementation of FSEntry interface for local filesystem entries
- `factory.v`: Provides `new_local_vfs()` for creating instances

### Error Handling

The implementation provides detailed error messages including:
- Path validation
- Permission checks
- File existence verification
- Type checking (file/directory/symlink)

## Usage

```v
import vfs

fn main() ! {
    // Create a new local VFS instance rooted at /tmp/test
    mut fs := vfs.new_vfs('local', '/tmp/test')!
    
    // Basic file operations
    fs.file_create('example.txt')!
    fs.file_write('example.txt', 'Hello from LocalVFS'.bytes())!
    
    // Read file contents
    content := fs.file_read('example.txt')!
    println(content.bytestr())
    
    // Directory operations
    fs.dir_create('subdir')!
    fs.file_create('subdir/nested.txt')!
    
    // List directory contents
    entries := fs.dir_list('subdir')!
    for entry in entries {
        println('Found: ${entry.get_path()}')
    }
    
    // Symlink operations
    fs.link_create('example.txt', 'link.txt')!
    target := fs.link_read('link.txt')!
    println('Link target: ${target}')
    
    // Clean up
    fs.destroy()!
}
```

## Limitations

- Operations are restricted to the root directory specified during creation
- Symlink support depends on OS capabilities
- File permissions follow OS user context

## Implementation Notes

1. Path Handling:
   - All paths are made relative to the VFS root
   - Absolute paths are converted to relative
   - Parent directory (..) references are resolved

2. Error Cases:
   - Non-existent files/directories
   - Permission denied
   - Invalid operations (e.g., reading directory as file)
   - Path traversal attempts

3. Metadata:
   - Preserves OS file metadata
   - Maps OS attributes to VFS metadata structure
   - Maintains creation/modification times

## Testing

The implementation includes comprehensive tests covering:
- Basic file operations
- Directory manipulation
- Symlink handling
- Error conditions
- Edge cases

Run tests with:
```bash
v test vfs/vfs_local/
