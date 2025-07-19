module doctreeclient

pub fn extract_image_links(s string) ![]string {
	mut result := []string{}
	mut current_pos := 0
	for {
		if current_pos >= s.len {
			break
		}
		
		// Find the start of an image markdown link
		start_index := s.index_after('![', current_pos) or { -1 }
		if start_index == -1 {
			break // No more image links found
		}
		
		// Find the closing bracket for alt text
		alt_end_index := s.index_after(']', start_index) or { -1 }
		if alt_end_index == -1 {
			break
		}
		
		// Check for opening parenthesis for URL
		if alt_end_index + 1 >= s.len || s[alt_end_index + 1] != `(` {
			current_pos = alt_end_index + 1 // Move past this invalid sequence
			continue
		}
		
		// Find the closing parenthesis for URL
		url_start_index := alt_end_index + 2
		url_end_index := s.index_after(')', url_start_index) or { -1 }
		if url_end_index == -1 {
			break
		}
		
		// Extract the URL
		url := s[url_start_index..url_end_index]
		result << url
		
		// Move current_pos past the found link to continue searching
		current_pos = url_end_index + 1
	}
	return result
}
