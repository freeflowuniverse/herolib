module ourdb

import freeflowuniverse.herolib.ui.console
import veb
import rand
import time
import json

// Represents the server context, extending the veb.Context
pub struct ServerContext {
	veb.Context
}

// Represents the OurDB server instance
@[heap]
pub struct OurDBServer {
	veb.Middleware[ServerContext]
pub mut:
	db                 &OurDB   // Reference to the database instance
	port               int      // Port on which the server runs
	allowed_hosts      []string // List of allowed hostnames
	allowed_operations []string // List of allowed operations (e.g., set, get, delete)
	secret_key         string   // Secret key for authentication
}

// Represents the arguments required to initialize the OurDB server
@[params]
pub struct OurDBServerArgs {
pub mut:
	port               int      = 3000                     // Server port, default is 3000
	allowed_hosts      []string = ['localhost']            // Allowed hosts
	allowed_operations []string = ['set', 'get', 'delete'] // Allowed operations
	secret_key         string   = rand.string_from_set('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
	32) // Generated secret key
	config             OurDBConfig // Database configuration parameters
}

// Creates a new instance of the OurDB server
pub fn new_server(args OurDBServerArgs) !OurDBServer {
	mut db := new(
		record_nr_max:    args.config.record_nr_max
		record_size_max:  args.config.record_size_max
		file_size:        args.config.file_size
		path:             args.config.path
		incremental_mode: args.config.incremental_mode
		reset:            args.config.reset
	) or { return error('Failed to create ourdb: ${err}') }

	mut server := OurDBServer{
		port:               args.port
		allowed_hosts:      args.allowed_hosts
		allowed_operations: args.allowed_operations
		secret_key:         args.secret_key
		db:                 &db
	}

	server.use(handler: server.logger_handler)
	server.use(handler: server.allowed_hosts_handler)
	server.use(handler: server.allowed_operations_handler)
	return server
}

// Middleware for logging incoming requests and responses
fn (self &OurDBServer) logger_handler(mut ctx ServerContext) bool {
	start_time := time.now()
	request := ctx.req
	method := request.method.str().to_upper()
	client_ip := ctx.req.header.get(.x_forwarded_for) or { ctx.req.host.str().split(':')[0] }
	user_agent := ctx.req.header.get(.user_agent) or { 'Unknown' }

	console.print_header('${start_time.format()} | [Request] IP: ${client_ip} | Method: ${method} | Path: ${request.url} | User-Agent: ${user_agent}')
	return true
}

// Middleware to check if the client host is allowed
fn (self &OurDBServer) allowed_hosts_handler(mut ctx ServerContext) bool {
	client_host := ctx.req.host.str().split(':')[0].to_lower()
	if !self.allowed_hosts.contains(client_host) {
		ctx.request_error('403 Forbidden: Host not allowed')
		console.print_stderr('Unauthorized host: ${client_host}')
		return false
	}
	return true
}

// Middleware to check if the requested operation is allowed
fn (self &OurDBServer) allowed_operations_handler(mut ctx ServerContext) bool {
	url_parts := ctx.req.url.split('/')
	operation := url_parts[1]
	if operation !in self.allowed_operations {
		ctx.request_error('403 Forbidden: Operation not allowed')
		console.print_stderr('Unauthorized operation: ${operation}')
		return false
	}
	return true
}

// Parameters for running the server
@[params]
pub struct RunParams {
pub mut:
	background bool // If true, the server runs in the background
}

// Starts the OurDB server
pub fn (mut self OurDBServer) run(params RunParams) {
	if params.background {
		spawn veb.run[OurDBServer, ServerContext](mut self, self.port)
	} else {
		veb.run[OurDBServer, ServerContext](mut self, self.port)
	}
}

// Represents a generic success response
@[params]
struct SuccessResponse[T] {
	message string // Success message
	data    T      // Response data
}

// Represents an error response
@[params]
struct ErrorResponse {
	error   string @[required] // Error type
	message string @[required] // Error message
}

// Returns an error response
fn (server OurDBServer) error(args ErrorResponse) ErrorResponse {
	return args
}

// Returns a success response
fn (server OurDBServer) success[T](args SuccessResponse[T]) SuccessResponse[T] {
	return args
}

// Request body structure for the `/set` endpoint
struct SetRequestBody {
mut:
	id    u32    // Record ID
	value string // Value to store
}

// API endpoint to set a key-value pair in the database
@['/set'; post]
pub fn (mut server OurDBServer) set(mut ctx ServerContext) veb.Result {
	request_body := ctx.req.data.str()
	mut decoded_body := json.decode(SetRequestBody, request_body) or {
		ctx.res.set_status(.bad_request)
		return ctx.json[ErrorResponse](server.error(
			error:   'bad_request'
			message: 'Invalid request body'
		))
	}

	if server.db.incremental_mode && decoded_body.id > 0 {
		ctx.res.set_status(.bad_request)
		return ctx.json[ErrorResponse](server.error(
			error:   'bad_request'
			message: 'Cannot set id when incremental mode is enabled'
		))
	}

	mut record := if server.db.incremental_mode {
		server.db.set(data: decoded_body.value.bytes()) or {
			ctx.res.set_status(.bad_request)
			return ctx.json[ErrorResponse](server.error(
				error:   'bad_request'
				message: 'Failed to set key: ${err}'
			))
		}
	} else {
		server.db.set(id: decoded_body.id, data: decoded_body.value.bytes()) or {
			ctx.res.set_status(.bad_request)
			return ctx.json[ErrorResponse](server.error(
				error:   'bad_request'
				message: 'Failed to set key: ${err}'
			))
		}
	}

	decoded_body.id = record
	ctx.res.set_status(.created)
	return ctx.json(server.success(message: 'Successfully set the key', data: decoded_body))
}

// API endpoint to retrieve a record by ID
@['/get/:id'; get]
pub fn (mut server OurDBServer) get(mut ctx ServerContext, id string) veb.Result {
	id_ := id.u32()
	record := server.db.get(id_) or {
		ctx.res.set_status(.not_found)
		return ctx.json[ErrorResponse](server.error(
			error:   'not_found'
			message: 'Record does not exist: ${err}'
		))
	}

	data := SetRequestBody{
		id:    id_
		value: record.bytestr()
	}

	ctx.res.set_status(.ok)
	return ctx.json(server.success(message: 'Successfully get record', data: data))
}

// API endpoint to delete a record by ID
@['/delete/:id'; delete]
pub fn (mut server OurDBServer) delete(mut ctx ServerContext, id string) veb.Result {
	id_ := id.u32()

	server.db.delete(id_) or {
		ctx.res.set_status(.not_found)
		return ctx.json[ErrorResponse](server.error(
			error:   'not_found'
			message: 'Failed to delete key: ${err}'
		))
	}

	ctx.res.set_status(.no_content)
	return ctx.json({
		'message': 'Successfully deleted record'
	})
}
