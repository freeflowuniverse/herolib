# PostgreSQL Client

The PostgreSQL client provides a simple interface to interact with PostgreSQL databases through HeroScript.

## Configuration

The PostgreSQL client can be configured using HeroScript. Configuration settings are stored on the filesystem for future use.

### Basic Configuration Example

```v
#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core
import os
import freeflowuniverse.herolib.clients.postgresql_client

heroscript := "
!!postgresql_client.configure 
    name:'test'
    user: 'root'
    port: 5432
    host: 'localhost'
    password: '1234'
    dbname: 'postgres'
"

// Process the heroscript
postgresql_client.play(heroscript:heroscript)!

// Get the configured client
mut db_client := postgresql_client.get(name:"test")!

println(db_client)
```

### Configuration Parameters

| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| name | Unique identifier for this configuration | 'default' |
| user | PostgreSQL user | 'root' |
| port | PostgreSQL server port | 5432 |
| host | PostgreSQL server host | 'localhost' |
| password | PostgreSQL user password | '' |
| dbname | Default database name | 'postgres' |

## Database Operations

### Check Connection

```v
// Check if connection is working
db_client.check()!
```

### Database Management

```v
// Check if database exists
exists := db_client.db_exists('mydb')!

// Create database
db_client.db_create('mydb')!

// Delete database
db_client.db_delete('mydb')!

// List all databases
db_names := db_client.db_names()!
```

### Query Execution

```v
// Execute a query
rows := db_client.exec('SELECT * FROM mytable;')!

// Query without semicolon is automatically appended
rows := db_client.exec('SELECT * FROM mytable')!
```

## Backup Functionality

The client provides functionality to backup databases:

```v
// Backup a specific database
db_client.backup(dbname: 'mydb', dest: '/path/to/backup/dir')!

// Backup all databases
db_client.backup(dest: '/path/to/backup/dir')!
```

Backups are created in custom PostgreSQL format (.bak files) which can be restored using pg_restore.

## Default Configuration

If no configuration is provided, the client uses these default settings:

```v
heroscript := "
!!postgresql_client.configure 
    name:'default'
    user: 'root'
    port: 5432
    host: 'localhost'
    password: ''
    dbname: 'postgres'
"
```

You can override these defaults by providing your own configuration using the HeroScript configure command.
