module main

import os

fn main() {
	// Create a buffer for reading
	mut buf := []u8{len: 1}
	mut stdin := os.stdin()
	mut stdout := os.stdout()
	
	// Read one byte at a time from stdin and immediately write to stdout
	for {
		// Read a byte from stdin
		bytes_read := stdin.read(mut buf) or {
			// Exit loop if error (e.g., EOF)
			break
		}
		
		// If no bytes were read, break
		if bytes_read <= 0 {
			break
		}
		
		// Write the byte to stdout immediately
		stdout.write(buf) or {
			eprintln('Error writing to stdout: ${err}')
			break
		}
		
		// Flush stdout to ensure immediate output
		stdout.flush()
	}
}
