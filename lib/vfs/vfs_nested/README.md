# Nested Filesystem Implementation (vfs_nested)

A virtual filesystem implementation that allows mounting multiple VFS implementations at different path prefixes, creating a unified filesystem view.

## Features

- Mount multiple VFS implementations
- Path-based routing to appropriate implementations
- Transparent operation across mounted filesystems
- Hierarchical organization
- Cross-implementation file operations
- Virtual root directory showing mount points

## Implementation Details

### Structure
```
vfs_nested/
├── vfsnested.v          # Core implementation
└── nested_test.v        # Implementation tests
```

### Key Components

- `NestedVFS`: Main implementation struct that manages mounted filesystems
- `RootEntry`: Special entry type representing the root directory
- `MountEntry`: Special entry type representing mounted filesystem points

## Usage

```v
import vfs
import vfs_nested

fn main() ! {
    mut nested := vfs_nested.new()
    mut local_fs := vfs.new_vfs('local', '/tmp/local')!
    nested.add_vfs('/local', local_fs)!
    nested.file_create('/local/test.txt')!
}
```

## Limitations

- Cannot rename/move files across different implementations
- Symlinks must be contained within a single implementation
- No atomic operations across implementations
- Mount points are fixed after creation
