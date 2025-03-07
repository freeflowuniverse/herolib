module mlib2

// Parse a fenced code block element
fn (mut p Parser) parse_fenced_code_block() ?&MarkdownElement {
	start_pos := p.pos
	start_line := p.line
	start_column := p.column
	
	// Check for opening fence (``` or ~~~)
	fence_char := p.text[p.pos]
	if fence_char != '`' && fence_char != '~' {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}
	
	// Count fence characters
	mut fence_len := 0
	for p.pos < p.text.len && p.text[p.pos] == fence_char {
		fence_len++
		p.pos++
		p.column++
	}
	
	// Must have at least 3 characters
	if fence_len < 3 {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}
	
	// Read language identifier
	mut language := ''
	for p.pos < p.text.len && p.text[p.pos] != `\n` {
		language += p.text[p.pos].ascii_str()
		p.pos++
		p.column++
	}
	language = language.trim_space()
	
	// Skip the newline
	if p.pos < p.text.len && p.text[p.pos] == `\n` {
		p.pos++
		p.line++
		p.column = 1
	}
	
	// Read code content until closing fence
	mut content := ''
	mut found_closing_fence := false
	
	for p.pos < p.text.len {
		// Check for closing fence
		if p.text[p.pos] == fence_char {
			mut i := p.pos
			mut count := 0
			
			// Count fence characters
			for i < p.text.len && p.text[i] == fence_char {
				count++
				i++
			}
			
			// Check if it's a valid closing fence
			if count >= fence_len {
				// Skip to end of line
				for i < p.text.len && p.text[i] != `\n` {
					i++
				}
				
				// Update position
				p.pos = i
				if p.pos < p.text.len && p.text[p.pos] == `\n` {
					p.pos++
					p.line++
					p.column = 1
				}
				
				found_closing_fence = true
				break
			}
		}
		
		// Add character to content
		content += p.text[p.pos].ascii_str()
		
		// Move to next character
		if p.text[p.pos] == `\n` {
			p.line++
			p.column = 1
		} else {
			p.column++
		}
		p.pos++
	}
	
	// If no closing fence was found, treat as paragraph
	if !found_closing_fence {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}
	
	// Create the code block element
	return &MarkdownElement{
		typ: .code_block
		content: content
		line_number: start_line
		column: start_column
		attributes: {
			'language': language
		}
	}
}
