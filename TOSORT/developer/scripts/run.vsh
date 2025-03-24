#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.mcp.developer
import freeflowuniverse.herolib.mcp.logger

mut server := developer.new_mcp_server(&developer.Developer{})!
server.start() or {
	logger.fatal('Error starting server: ${err}')
	exit(1)
}
