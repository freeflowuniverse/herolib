# OurDB Server

OurDBServer is a lightweight key-value store server built in V, designed for simplicity and performance. It provides basic CRUD operations with security features such as host and operation restrictions.

## Features
- Supports `set`, `get`, and `delete` operations.
- Allows configurable host restrictions.
- Middleware for logging and security.
- Incremental mode for automatic ID assignment.
- Configurable storage options.

## Installation
- Ensure you have V installed on your system:

## Usage
### Starting the Server
You can start the server using the following command:
```v
mut server := new_server(OurDBServerArgs{
    port:               3000
    allowed_hosts:      ['localhost'] // Add more hosts as needed
    allowed_operations: ['set', 'get', 'delete'] // Add more operations as needed, these are the current supported operations
    secret_key:         'your-secret-key'
    config:             OurDBConfig{
        path:             '/tmp/ourdb'
        incremental_mode: true
        reset:            true
    }
}) or { panic(err) }
server.run(background: false )
```

### API Endpoints

#### 1. Set a Record
**Endpoint:**
```http
POST /set
```
**Request Body:**
```json
{
    "id": 0,  // ID is optional in incremental mode
    "value": "Some data"
}
```


#### 2. Get a Record
**Endpoint:**
```http
GET /get/:id
```

#### 3. Delete a Record
**Endpoint:**
```http
DELETE /delete/:id
```

## Configuration
You can customize the server settings by modifying `OurDBServerArgs` when initializing the server.

| Parameter            | Description                           | Default Value |
|---------------------|-----------------------------------|--------------|
| `port`             | Server port                        | `3000`       |
| `allowed_hosts`    | List of allowed hosts              | `['localhost']` |
| `allowed_operations` | List of permitted operations      | `['set', 'get', 'delete']` |
| `secret_key`       | Secret key for authentication      | Auto-generated |
| `record_nr_max`    | Max number of records             | `100`        |
| `record_size_max`  | Max size per record (bytes)       | `1024`       |
| `file_size`        | Max file storage size (bytes)     | `10_000`     |
| `incremental_mode` | Auto-generate IDs if enabled      | `true`       |
| `reset`           | Clears storage on restart         | `true`       |

## Middleware
OurDB includes middleware for logging, host verification, and operation control:
- **Logger Middleware:** Logs incoming requests with details.
- **Allowed Hosts Middleware:** Blocks requests from unauthorized hosts.
- **Allowed Operations Middleware:** Blocks requests for unsupported operations.

## Running Tests
You can test the server using:
```sh
v -enable-globals -stats test lib/data/ourdb/server_test.v
```

## Running Server
You can run the server using:
```sh
v -enable-globals -stats run lib/data/ourdb/server.v
```

or use the created example

```sh
examples/data/ourdb_server.vsh
```
