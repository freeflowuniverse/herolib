module jsonrpc

import log
import net.websocket

// JSON-RPC WebSoocket Server

pub struct Handler {
pub:
	// map of method names to procedure handlers
	procedures map[string]ProcedureHandler
}

// ProcedureHandler handles executing procedure calls
// decodes payload, execute procedure function, return encoded result
type ProcedureHandler = fn (payload string) !string

pub fn new_handler(handler Handler) !&Handler {
	return &Handler{...handler}
}

pub fn (handler Handler) handler(client &websocket.Client, message string) string {
	return handler.handle(message) or { panic(err) }
}

pub fn (handler Handler) handle(message string) !string {
	method := decode_request_method(message)!
	log.info('Handling remote procedure call to method: ${method}')
	procedure_func := handler.procedures[method] or {
		log.error('No procedure handler for method ${method} found')
		return method_not_found
	}
	response := procedure_func(message) or { panic(err) }
	return response
}
