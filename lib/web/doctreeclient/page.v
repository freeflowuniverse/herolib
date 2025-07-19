module doctreeclient

// extract_title extracts the highest level markdown title from a page string.
// It returns the first one found, or an empty string if none are present.
pub fn extract_title(page string) string {
	lines := page.split_into_lines()
	for line in lines {
		mut hash_count := 0
		for char_idx, r in line.runes() {
			if r == ` ` {
				continue
			}
			if r == `#` {
				hash_count++
			} else {
				if hash_count > 0 {
					// Found a title, extract the text after the hashes and spaces
					return line[char_idx..].trim_space()
				}
				break // Not a title line
			}
		}
	}
	return ""
}

// set_titles renumbers markdown titles in a page string up to a specified maximum level.
// If maxnr is not set, it defaults to 3.
pub fn set_titles(page string, maxnr int) string {
	mut result_lines := []string{}
	mut current_numbers := []int{len: 6, init: 0} // Support up to H6, initialize with 0s
	mut has_h1 := false

	mut effective_maxnr := maxnr
	if effective_maxnr == 0 {
		effective_maxnr = 3 // Default to H3 if maxnr is not set
	}

	lines := page.split_into_lines()
	for line in lines {
		mut hash_count := 0
		mut first_char_idx := 0
		for char_idx, r in line.runes() {
			if r == ` ` {
				first_char_idx++
				continue
			}
			if r == `#` {
				hash_count++
				first_char_idx++
			} else {
				break
			}
		}

		if hash_count > 0 && hash_count <= effective_maxnr {
			// This is a title within the effective_maxnr
			current_numbers[hash_count - 1]++ // Increment current level
			if hash_count == 1 {
				has_h1 = true
			}
			// Reset lower levels
			for i := hash_count; i < current_numbers.len; i++ {
				current_numbers[i] = 0
			}

			mut new_prefix := ""
			mut actual_hash_count_for_prefix := hash_count
			mut first_num_override := false

			if !has_h1 && hash_count > 1 {
				// If no H1 has been encountered yet, and this is an H2 or lower,
				// the first number should be 1, and the prefix length is hash_count - 1.
				first_num_override = true
				actual_hash_count_for_prefix = hash_count - 1
			}

			for i := 0; i < actual_hash_count_for_prefix; i++ {
				if i == 0 && first_num_override {
					new_prefix += '1.'
				} else {
					new_prefix += '${current_numbers[i + (if first_num_override {1} else {0}) ]}.'
				}
			}

			// Extract the original title text (after hashes and spaces)
			mut original_title_text := line[first_char_idx..].trim_space()

			// Remove existing numbering (e.g., "1. ", "1.1. ")
			mut skip_chars := 0
			mut in_numbering := true
			for r_idx, r in original_title_text.runes() {
				if in_numbering {
					if (r >= `0` && r <= `9`) || r == `.` || r == ` ` {
						skip_chars++
					} else {
						in_numbering = false
					}
				} else {
					break
				}
			}
			original_title_text = original_title_text[skip_chars..].trim_space()

			// Construct the new line
			mut new_line := ""
			for _ in 0..hash_count {
				new_line += '#'
			}
			new_line += " ${new_prefix} ${original_title_text}"
			result_lines << new_line
		} else {
			result_lines << line // Not a title or outside maxnr, keep as is
		}
	}

	return result_lines.join_lines() + '\n'
}