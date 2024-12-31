## Context & Sessions

Everything we do in hero lives in a context, each context has a unique name and ID. A context can have multiple sessions, where each session represents a specific execution environment.

### Context

Each context has:
- A unique ID and name
- Secret management (encrypted)
- Database collection
- Configuration storage
- Code root path
- Parameters

### Sessions

Sessions exist within a context and provide:
- Unique name within the context
- Interactive mode control
- Environment variables
- Start/End time tracking
- Parameter storage
- Database access
- Logging

### Storage Structure

Redis is used to manage contexts and sessions:

- Redis DB X (where X is context ID):
  - `context:config` - JSON encoded context configuration
  - `sessions:config:$name` - JSON encoded session configuration for each session

### Database Structure

Each context has a database collection located at `~/hero/db/$contextid/`. Within this:
- Each session gets its own database named `session_$name`
- A shared `config` database exists for context-wide configuration

### Hero Configuration

Contexts support hero-specific configuration files:
- Stored at `~/hero/context/$contextname/$category__$name.yaml`
- Supports categories for organization
- Automatically handles shell expansions

### Example Usage

```v
import freeflowuniverse.herolib.core.base

// Create a new context
mut context := context_new(
    id: 1
    name: 'mycontext'
    coderoot: '/tmp/code'
    interactive: true
)!

// Create a new session in the context
mut session := session_new(
    context: context
    name: 'mysession1'
    interactive: true
)!

// Work with environment variables
session.env_set('KEY', 'value')!
value := session.env_get('KEY')!

// Work with hero config
context.hero_config_set('category', 'name', 'content')!
content := context.hero_config_get('category', 'name')!

// Access session database
mut db := session.db_get()!

// Access context-wide config database
mut config_db := session.db_config_get()!
```

### Security

- Context secrets are stored as MD5 hashes
- Support for encryption of sensitive data
- Interactive secret configuration available

### File Structure

Each context and session has its own directory structure:
- Context root: `~/hero/context/$contextname/`
- Session directory: `~/hero/context/$contextname/$sessionname/`

This structure helps organize configuration files, logs, and other session-specific data.

### Logging

Each session has its own logger:

```v
mut logger := session.logger()!
logger.log(log:'My log message')
```

For detailed logging capabilities and options, see the logger documentation in `lib/core/logger/readme.md`.
