module markdownparser2

// Parse a horizontal rule element
fn (mut p Parser) parse_horizontal_rule() ?&MarkdownElement {
	start_pos := p.pos
	start_line := p.line
	start_column := p.column

	// Check for at least 3 of the same character (-, *, _)
	hr_char := p.text[p.pos]
	if hr_char != `-` && hr_char != `*` && hr_char != `_` {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}

	mut count := 0
	for p.pos < p.text.len && p.text[p.pos] == hr_char {
		count++
		p.pos++
		p.column++
	}

	// Must have at least 3 characters
	if count < 3 {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}

	// Skip whitespace
	p.skip_whitespace()

	// Must be at end of line
	if p.pos < p.text.len && p.text[p.pos] != `\n` {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}

	// Skip the newline
	if p.pos < p.text.len && p.text[p.pos] == `\n` {
		p.pos++
		p.line++
		p.column = 1
	}

	// Create the horizontal rule element
	return &MarkdownElement{
		typ:         .horizontal_rule
		content:     ''
		line_number: start_line
		column:      start_column
	}
}
