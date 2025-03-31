module texttools

import time

// Test function for format_rfc1123
fn test_format_rfc1123() {
	// Create a specific time instance. The format function will handle UTC conversion.
	// Using the reference time often seen in Go examples: Mon, 02 Jan 2006 15:04:05 GMT
	known_time := time.new(year: 2006, month: 1, day: 2, hour: 15, minute: 4, second: 5)

	// Expected RFC 1123 formatted string
	expected_rfc1123 := 'Mon, 02 Jan 2006 15:04:05 GMT'

	// Call the function under test
	actual_rfc1123 := format_rfc1123(known_time)

	// Assert that the actual output matches the expected output
	assert actual_rfc1123 == expected_rfc1123, 'Expected "${expected_rfc1123}", but got "${actual_rfc1123}"'
}
