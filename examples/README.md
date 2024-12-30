# HeroLib Examples

This repository contains examples and utilities for working with HeroLib, a comprehensive library for V language.

## Sync Do Script

The `sync_do.sh` script is a utility for development that:

- Synchronizes the local HeroLib codebase with a remote server
- Uses rsync to efficiently transfer only changed files
- Automatically connects to a tmux session on the remote server
- Helps maintain development environment consistency

## Examples Structure

The examples directory demonstrates various capabilities of HeroLib:

- **builder/**: Examples of builder patterns and remote execution
- **core/**: Core functionality examples including configuration, database operations, and API integrations
- **data/**: Data handling examples including encryption and encoding
- **develop/**: Development tools including git integration and OpenAI examples
- **hero/**: Hero-specific implementations and API examples
- **installers/**: Various installation scripts for different tools and services
- **lang/**: Language integration examples (e.g., Python)
- **osal/**: Operating system abstraction layer examples
- **threefold/**: ThreeFold Grid related examples and utilities
- **tools/**: Utility examples for imagemagick, tmux, etc.
- **ui/**: User interface examples including console and telegram
- **virt/**: Virtualization examples for Docker, Lima, Windows, etc.
- **webtools/**: Web-related tools and utilities

## V Script Requirements

When creating V scripts (.vsh files), always use the following shebang:

```bash
#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run
```

This shebang ensures:

- Direct execution of V shell scripts without needing to use the V command
- No main() function requirement in .vsh files
- Proper compilation flags and settings
- OpenSSL support enabled
- Global variables enabled
- TCC compiler usage
- No retry compilation

These examples serve as practical demonstrations and reference implementations for various HeroLib features and integrations.
