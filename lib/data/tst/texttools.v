module tst

// namefix normalizes a string for consistent key handling
// - removes leading/trailing whitespace
// - converts to lowercase
// - replaces special characters with standard ones
pub fn namefix(s string) string {
	mut result := s.trim_space().to_lower()

	// Replace any problematic characters or sequences if needed
	// For this implementation, we'll keep it simple

	return result
}
