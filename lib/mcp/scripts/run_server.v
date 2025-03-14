module main

import freeflowuniverse.herolib.mcp

fn main() {
	mut server := mcp.new_server()!
	server.start() or {
		eprintln('Error starting server: $err')
		exit(1)
	}
}
