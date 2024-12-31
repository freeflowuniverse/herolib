module base

import freeflowuniverse.herolib.core.logger

pub fn (session Session) logger() !logger.Logger {
	return session.logger_ or { 
		mut l2 := logger.new("${session.path()!.path}/logs")!
		l2
	}
}
