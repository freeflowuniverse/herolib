module zinit

// Request Types for Zinit API
//
// This file contains all the request types used by the Zinit API.

// ZinitError represents an error returned by the zinit API
pub struct ZinitError {
pub mut:
	code    int    // Error code
	message string // Error message
	data    string // Additional error data
}

// Error implements the error interface for ZinitError
pub fn (e ZinitError) msg() string {
	return 'Zinit Error ${e.code}: ${e.message} - ${e.data}'
}
