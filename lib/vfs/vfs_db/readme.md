# VFS DB: A Virtual File System with Database Backend

A virtual file system implementation that provides a filesystem interface on top of a database backend (OURDb). This module enables hierarchical file system operations while storing all data in a key-value database.

## Overview

VFS DB implements a complete virtual file system that:
- Uses OURDb as the storage backend
- Supports files, directories, and symbolic links
- Provides standard file system operations
- Maintains hierarchical structure
- Handles metadata and file data efficiently

## Architecture

### Core Components

#### 1. Database Backend (OURDb)
- Uses key-value store with u32 keys and []u8 values
- Stores both metadata and file content
- Provides atomic operations for data consistency

#### 2. File System Entries
All entries (files, directories, symlinks) share common metadata:
```v
struct Metadata {
    id          u32    // unique identifier used as key in DB
    name        string // name of file or directory
    file_type   FileType
    size        u64
    created_at  i64    // unix epoch timestamp
    modified_at i64    // unix epoch timestamp
    accessed_at i64    // unix epoch timestamp
    mode        u32    // file permissions
    owner       string
    group       string
}
```

The system supports three types of entries:
- Files: Store actual file data
- Directories: Maintain parent-child relationships
- Symlinks: Store symbolic link targets

### Key Features

1. **File Operations**
   - Create/delete files
   - Read/write file content
   - Copy and move files
   - Rename files
   - Check file existence

2. **Directory Operations**
   - Create/delete directories
   - List directory contents
   - Traverse directory tree
   - Manage parent-child relationships

3. **Symbolic Link Support**
   - Create symbolic links
   - Read link targets
   - Delete links

4. **Metadata Management**
   - Track creation, modification, and access times
   - Handle file permissions
   - Store owner and group information

### Implementation Details

1. **Entry Types**
```v
pub type FSEntry = Directory | File | Symlink
```

2. **Database Interface**
```v
pub interface Database {
mut:
    get(id u32) ![]u8
    set(ourdb.OurDBSetArgs) !u32
    delete(id u32)!
}
```

3. **VFS Structure**
```v
pub struct DatabaseVFS {
pub mut:
    root_id          u32    
    block_size       u32    
    data_dir         string 
    metadata_dir     string 
    db_data          &Database
    last_inserted_id u32
}
```

### Usage Example

```v
// Create a new VFS instance
mut fs := vfs_db.new(data_dir: "/path/to/data", metadata_dir: "/path/to/metadata")!

// Create a directory
fs.dir_create("/mydir")!

// Create and write to a file
fs.file_create("/mydir/test.txt")!
fs.file_write("/mydir/test.txt", "Hello World".bytes())!

// Read file content
content := fs.file_read("/mydir/test.txt")!

// Create a symbolic link
fs.link_create("/mydir/test.txt", "/mydir/link.txt")!

// List directory contents
entries := fs.dir_list("/mydir")!

// Delete files/directories
fs.file_delete("/mydir/test.txt")!
fs.dir_delete("/mydir")!
```

### Data Encoding

The system uses an efficient binary encoding format for storing entries:
- First byte: Version number for format compatibility
- Second byte: Entry type indicator
- Remaining bytes: Entry-specific data

This ensures minimal storage overhead while maintaining data integrity.

## Error Handling

The implementation uses V's error handling system with descriptive error messages for:
- File/directory not found
- Permission issues
- Invalid operations
- Database errors

## Thread Safety

The implementation is designed to be thread-safe through:
- Proper mutex usage
- Atomic operations
- Clear ownership semantics

## Future Improvements

1. **Performance Optimizations**
   - Caching frequently accessed entries
   - Batch operations support
   - Improved directory traversal

2. **Feature Additions**
   - Extended attribute support
   - Access control lists
   - Quota management
   - Transaction support

3. **Robustness**
   - Recovery mechanisms
   - Consistency checks
   - Better error recovery
