#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.mcp.baobab
import freeflowuniverse.herolib.mcp.logger

mut server := baobab.new_mcp_server()!
server.start() or {
	logger.fatal('Error starting server: $err')
	exit(1)
}

