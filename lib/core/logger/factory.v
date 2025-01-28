module logger

import freeflowuniverse.herolib.core.pathlib

pub fn new(path string) !Logger {
	mut p := pathlib.get_dir(path: path, create: true)!
	return Logger{
		path:         p
		lastlog_time: 0
	}
}
