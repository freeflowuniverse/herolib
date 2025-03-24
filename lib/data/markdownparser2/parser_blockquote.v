module markdownparser2

// Parse a blockquote element
fn (mut p Parser) parse_blockquote() ?&MarkdownElement {
	start_pos := p.pos // Unused but kept for consistency
	start_line := p.line
	start_column := p.column
	
	// Skip the > character
	p.pos++
	p.column++
	
	// Skip whitespace after >
	p.skip_whitespace()
	
	mut content := ''
	mut lines := []string{}
	
	// Read the first line
	for p.pos < p.text.len && p.text[p.pos] != `\n` {
		content += p.text[p.pos].ascii_str()
		p.pos++
		p.column++
	}
	lines << content
	
	// Skip the newline
	if p.pos < p.text.len && p.text[p.pos] == `\n` {
		p.pos++
		p.line++
		p.column = 1
	}
	
	// Read additional lines of the blockquote
	for p.pos < p.text.len {
		// Check if the line starts with >
		if p.text[p.pos] == `>` {
			p.pos++
			p.column++
			p.skip_whitespace()
			
			mut line := ''
			for p.pos < p.text.len && p.text[p.pos] != `\n` {
				line += p.text[p.pos].ascii_str()
				p.pos++
				p.column++
			}
			lines << line
			
			// Skip the newline
			if p.pos < p.text.len && p.text[p.pos] == `\n` {
				p.pos++
				p.line++
				p.column = 1
			}
		} else if p.text[p.pos] == `\n` {
			// Empty line - could be a continuation or the end of the blockquote
			p.pos++
			p.line++
			p.column = 1
			
			// Check if the next line is part of the blockquote
			if p.pos < p.text.len && p.text[p.pos] == `>` {
				lines << ''
			} else {
				break
			}
		} else {
			// Not a blockquote line, end of blockquote
			break
		}
	}
	
	// Join the lines with newlines
	content = lines.join('\n')
	
	// Create the blockquote element
	mut blockquote := &MarkdownElement{
		typ: .blockquote
		content: content
		line_number: start_line
		column: start_column
	}
	
	// Parse nested blocks within the blockquote
	mut nested_parser := Parser{
		text: content
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	nested_doc := nested_parser.parse()
	blockquote.children = nested_doc.root.children
	
	return blockquote
}
