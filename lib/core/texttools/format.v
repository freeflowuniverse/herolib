module texttools

import time

// format_rfc1123 formats a time.Time object into RFC 1123 format (e.g., "Mon, 02 Jan 2006 15:04:05 GMT").
// It specifically uses the GMT timezone as required by the standard.
pub fn format_rfc1123(t time.Time) string {
	// Use the built-in HTTP header formatter which follows RFC 1123 format
	// e.g., "Mon, 02 Jan 2006 15:04:05 GMT"
	// The method ensures the time is in UTC/GMT as required by the standard
	return t.http_header_string()
}
