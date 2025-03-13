module qdrant

import freeflowuniverse.herolib.core.httpconnection

// QDrant usage
pub struct QDrantUsage {
pub mut:
	cpu      int // CPU usage
	io_read  int // I/O read usage
	io_write int // I/O write usage
}

// Top-level response structure
pub struct QDrantResponse[T] {
pub mut:
	usage  QDrantUsage // Usage information
	result T           // The result
	status string      // Response status
	time   f64         // Response time
}

// httpclient creates a new HTTP connection to the Qdrant API
fn (mut self QDrantClient) httpclient() !&httpconnection.HTTPConnection {
	mut http_conn := httpconnection.new(
		name: 'Qdrant_vclient'
		url:  self.url
	)!

	// Add authentication header if API key is provided
	if self.secret.len > 0 {
		http_conn.default_header.add_custom('api-key', self.secret)!
	}

	return http_conn
}
