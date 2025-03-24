module v_do

import freeflowuniverse.herolib.mcp.v_do.logger

fn main() {
	logger.info('Starting V-Do server')
	mut server := new_server()
	server.start() or {
		logger.fatal('Error starting server: $err')
		exit(1)
	}
}
