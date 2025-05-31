module jsonrpc

import net.unix
import time
import json

// UnixSocketTransport implements the IRPCTransportClient interface for Unix domain sockets
struct UnixSocketTransport {
mut:
	socket_path string
}

// new_unix_socket_transport creates a new Unix socket transport
pub fn new_unix_socket_transport(socket_path string) &UnixSocketTransport {
	return &UnixSocketTransport{
		socket_path: socket_path
	}
}

// send implements the IRPCTransportClient interface
pub fn (mut t UnixSocketTransport) send(request string, params SendParams) !string {
	// Create a Unix domain socket client
	mut socket := unix.connect_stream(t.socket_path)!
	defer { socket.close() or {} }
	
	// Set timeout if specified
	if params.timeout > 0 {
		socket.set_read_timeout(params.timeout * time.second)
		socket.set_write_timeout(params.timeout * time.second)
	}
	
	// Send the request
	socket.write_string(request + '\n')!
	
	// Read the response
	mut response := ''
	mut buf := []u8{len: 4096}
	
	for {
		bytes_read := socket.read(mut buf)!
		if bytes_read <= 0 {
			break
		}
		response += buf[..bytes_read].bytestr()
		
		// Check if we've received a complete JSON response
		if response.ends_with('}') {
			break
		}
	}
	
	return response
}

// Client provides a client interface to the zinit JSON-RPC API over Unix socket
// @[heap]
// pub struct UnixSocketClient {
// mut:
// 	socket_path string
// 	rpc_client  &Client
// 	request_id  int
// }

// new_client creates a new zinit client instance
// socket_path: path to the Unix socket (default: /tmp/zinit.sock)
pub fn new_unix_socket_client(socket_path string) &Client {
	mut transport := new_unix_socket_transport(socket_path)
	mut rpc_client := new_client(transport)
	// return &UnixSocketClient{
	// 	socket_path: socket_path
	// 	rpc_client: rpc_client
	// 	request_id: 0
	// }
	return rpc_client
}
