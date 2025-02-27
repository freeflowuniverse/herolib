### Local Filesystem (LocalVFS)

The LocalVFS implementation provides a direct passthrough to the operating system's filesystem. It implements all vfscore operations by delegating to the corresponding OS filesystem operations.

Features:
- Direct access to local filesystem
- Full support for all vfscore operations
- Preserves file permissions and metadata
- Efficient for local file operations