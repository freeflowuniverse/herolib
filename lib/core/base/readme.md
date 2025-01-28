# Base Module

The Base module is a foundational component of the Hero framework that provides essential context and session management functionality.

## Features

- **Context Management**: Handles application context with support for:
  - Parameter management
  - Redis integration
  - Database collections
  - Configuration storage and retrieval
  - Path management

- **Session Handling**: Provides session management capabilities through the Base and Session structures

- **Configuration Management**: 
  - heroscript configuration system
  - Support for environment variable expansion

- **Security Features**:
  - Secret management
  - AES symmetric encryption/decryption
  - Secure configuration storage

- **Database Integration**:
  - Redis database support with automatic database selection
  - File-based database collections
  - Key-value storage capabilities

## Core Components

### Context

The `Context` struct is the central component that manages:
- Application parameters
- Database connections
- Redis client
- File paths
- Configuration settings

### Base

The `Base` struct provides:
- Session management
- Instance tracking
- Configuration type handling

## Usage

The base module is typically used as a foundation for other Hero framework components. It provides the necessary infrastructure for:

- Managing application state
- Handling configurations
- Managing database connections
- Securing sensitive data
- Organizing application resources

## Configuration

The module supports various configuration options through the `ContextConfig` struct:
- `id`: Unique identifier for the context
- `name`: Context name (defaults to 'default')
- `params`: Parameter string
- `coderoot`: Root path for code
- `interactive`: Interactive mode flag
- `secret`: Hashed secret for encryption
- `db_path`: Path to database collection
- `encrypt`: Encryption flag

## Security

The module includes built-in security features:
- Secret management with encryption
- Secure configuration storage
- MD5 hashing for secrets
- AES symmetric encryption for sensitive data
