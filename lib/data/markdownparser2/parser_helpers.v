module markdownparser2

// Helper function to peek ahead in the text
fn (p Parser) peek(offset int) u8 {
	if p.pos + offset >= p.text.len {
		return 0
	}
	return p.text[p.pos + offset]
}

// Skip whitespace characters
fn (mut p Parser) skip_whitespace() {
	for p.pos < p.text.len && (p.text[p.pos] == ` ` || p.text[p.pos] == `\t`) {
		p.pos++
		p.column++
	}
}

// Check if current position is the start of a list
fn (p Parser) is_list_start() bool {
	if p.pos >= p.text.len {
		return false
	}
	
	// Unordered list: *, -, +
	if (p.text[p.pos] == `*` || p.text[p.pos] == `-` || p.text[p.pos] == `+`) && 
	   (p.peek(1) == ` ` || p.peek(1) == `\t`) {
		return true
	}
	
	// Ordered list: 1., 2., etc.
	if p.pos + 2 < p.text.len && p.text[p.pos].is_digit() {
		mut i := p.pos + 1
		for i < p.text.len && p.text[i].is_digit() {
			i++
		}
		if i < p.text.len && p.text[i] == `.` && i + 1 < p.text.len && (p.text[i + 1] == ` ` || p.text[i + 1] == `\t`) {
			return true
		}
	}
	
	// Task list: - [ ], - [x], etc.
	if p.pos + 4 < p.text.len && 
	   (p.text[p.pos] == `-` || p.text[p.pos] == `*` || p.text[p.pos] == `+`) && 
	   p.text[p.pos + 1] == ` ` && p.text[p.pos + 2] == `[` && 
	   (p.text[p.pos + 3] == ` ` || p.text[p.pos + 3] == `x` || p.text[p.pos + 3] == `X`) && 
	   p.text[p.pos + 4] == `]` {
		return true
	}
	
	return false
}

// Check if current position is the start of a table
fn (p Parser) is_table_start() bool {
	if p.pos >= p.text.len || p.text[p.pos] != `|` {
		return false
	}
	
	// Look for a pipe character at the beginning of the line
	// and check if there's at least one more pipe in the line
	mut has_second_pipe := false
	mut i := p.pos + 1
	for i < p.text.len && p.text[i] != `\n` {
		if p.text[i] == `|` {
			has_second_pipe = true
			break
		}
		i++
	}
	
	if !has_second_pipe {
		return false
	}
	
	// Check if the next line has a header separator (---|---|...)
	mut next_line_start := i + 1
	if next_line_start >= p.text.len {
		return false
	}
	
	// Skip whitespace at the beginning of the next line
	for next_line_start < p.text.len && (p.text[next_line_start] == ` ` || p.text[next_line_start] == `\t`) {
		next_line_start++
	}
	
	if next_line_start >= p.text.len || p.text[next_line_start] != `|` {
		return false
	}
	
	// Check for pattern like |---|---|...
	// We just need to check if there's a valid separator line
	mut j := next_line_start + 1
	for j < p.text.len && p.text[j] != `\n` {
		// Only allow -, |, :, space, or tab in the separator line
		if p.text[j] != `-` && p.text[j] != `|` && p.text[j] != `:` && 
		   p.text[j] != ` ` && p.text[j] != `\t` {
			return false
		}
		j++
	}
	
	return true
}

// Check if current position is a footnote definition
fn (p Parser) is_footnote_definition() bool {
	if p.pos + 3 >= p.text.len {
		return false
	}
	
	// Check for pattern like [^id]:
	return p.text[p.pos] == `[` && p.text[p.pos + 1] == `^` && 
	       p.text[p.pos + 2] != `]` && p.text.index_after(']:', p.pos + 2) > p.pos + 2
}
