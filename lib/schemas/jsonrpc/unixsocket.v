module jsonrpc

import net.unix
import time
import freeflowuniverse.herolib.ui.console
import net

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
	// console.print_debug('Connecting to Unix socket at: $t.socket_path')
	mut socket := unix.connect_stream(t.socket_path)!

	// Ensure socket is always closed, even if there's an error
	defer {
		// Close the socket explicitly
		unix.shutdown(socket.sock.handle)
		socket.close() or {}
		// console.print_debug('Socket closed')
	}
	
	// Set timeout if specified
	if params.timeout > 0 {
		socket.set_read_timeout(params.timeout * time.second)
		socket.set_write_timeout(params.timeout * time.second)
		// console.print_debug('Set socket timeout to ${params.timeout} seconds')
	}
	net.set_blocking(socket.sock.handle,false) !

	// Send the request
	// console.print_debug('Sending request: $request')
	socket.write_string(request + '\n')!
	// println(18)
	
	// Read the response in a single call with a larger buffer
	
	mut res_total := []u8
	for {
		// console.print_debug('Reading response from socket...')
		// Read up to 64000 bytes
		mut res := []u8{len: 64000, cap: 64000}
		n := socket.read(mut res)!
		// console.print_debug('Read ${n} bytes from socket')
		if n == 0 {
			// console.print_debug('No more data to read, breaking loop')
			break
		}
		// Append the newly read data to the total response
		res_total << res[..n]
		if n < 8192{
			// console.print_debug('No more data to read, breaking loop after ${n} bytes')
			break
		}		
	}
	// println(res_total.bytestr().trim_space())


	// println(19)
	
	// Convert response to string and trim whitespace
	mut response := res_total.bytestr().trim_space()
	// console.print_debug('Received ${response.len} bytes')

	// Basic validation
	if response.len == 0 {
		return error('Empty response received from server')
	}
	
	// console.print_debug('Response: $response')
	return response
}

// new_client creates a new zinit client instance
// socket_path: path to the Unix socket (default: /tmp/zinit.sock)
pub fn new_unix_socket_client(socket_path string) &Client {
	mut transport := new_unix_socket_transport(socket_path)
	mut rpc_client := new_client(transport)
	return rpc_client
}
