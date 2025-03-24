module mock_module

// TestConfig represents a configuration for testing
pub struct TestConfig {
pub:
	name    string
	enabled bool
	count   int
	value   float64
}

// TestResult represents the result of a test operation
pub struct TestResult {
pub:
	success bool
	message string
	code    int
}

// test_function is a simple function for testing the MCP tool code generation
// It takes a config and returns a result
pub fn test_function(config TestConfig) !TestResult {
	// This is just a mock implementation for testing purposes
	if config.name == '' {
		return error('Name cannot be empty')
	}

	return TestResult{
		success: config.enabled
		message: 'Test completed for ${config.name}'
		code:    if config.enabled { 0 } else { 1 }
	}
}

// simple_function is a function with primitive types for testing
pub fn simple_function(name string, count int) string {
	return '${name} count: ${count}'
}
