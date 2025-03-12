module logger

import os

// LogLevel defines the severity of log messages
pub enum LogLevel {
	debug
	info
	warn
	error
	fatal
}

// log outputs a message to stderr with the specified log level
pub fn log(level LogLevel, message string) {
	level_str := match level {
		.debug { 'DEBUG' }
		.info { 'INFO ' }
		.warn { 'WARN ' }
		.error { 'ERROR' }
		.fatal { 'FATAL' }
	}
	eprintln('[$level_str] $message')
}

// debug logs a debug message to stderr
pub fn debug(message string) {
	log(.debug, message)
}

// info logs an info message to stderr
pub fn info(message string) {
	log(.info, message)
}

// warn logs a warning message to stderr
pub fn warn(message string) {
	log(.warn, message)
}

// error logs an error message to stderr
pub fn error(message string) {
	log(.error, message)
}

// fatal logs a fatal error message to stderr and exits the program
pub fn fatal(message string) {
	log(.fatal, message)
	exit(1)
}
