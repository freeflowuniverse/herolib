# Core Module

The Core module provides fundamental system-level functionality for the Hero framework. It handles platform detection, system operations, and provides essential utilities used throughout the framework.

## Main Features

### Platform Management
- Platform detection (OSX, Ubuntu, Alpine, Arch)
- CPU architecture detection (Intel, ARM)
- System information retrieval (hostname, init system)
- Cross-platform compatibility utilities

### Memory Database
- Thread-safe in-memory key-value store
- Global state management
- Caching for system information

### Sudo Operations
- Permission management and verification
- Sudo requirement detection
- Path access rights checking
- Command elevation handling

### Submodules

- **base**: Context and session management
- **httpconnection**: HTTP client functionality
- **logger**: Logging infrastructure
- **pathlib**: Path manipulation and handling
- **playbook**: Execution playbooks
- **redisclient**: Redis database client
- **rootpath**: Root path management
- **smartid**: Identifier management
- **texttools**: Text manipulation utilities
- **vexecutor**: Command execution

## Platform Support

The module supports multiple platforms:
- macOS (Intel and ARM)
- Ubuntu
- Alpine Linux
- Arch Linux

And CPU architectures:
- x86_64 (Intel)
- ARM64/AArch64

## Usage

The core module provides essential functionality used by other Hero framework components. Key features include:

### Platform Detection
```v
// Check platform type
if core.is_linux()! {
    // Linux-specific code
}

// Check CPU architecture
if core.is_linux_arm()! {
    // ARM-specific code
}
```

### Memory Database
```v
// Store values
core.memdb_set('key', 'value')

// Retrieve values
value := core.memdb_get('key')
```

### Sudo Operations

```v
// Check sudo requirements
if core.sudo_required()! {
    // Handle sudo requirements
}

// Verify path permissions
path := core.sudo_path_check('/protected/path', true)!
```

