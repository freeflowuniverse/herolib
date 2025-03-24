module markdownparser2

// Parse a footnote definition
fn (mut p Parser) parse_footnote_definition() ?&MarkdownElement {
	start_pos := p.pos
	start_line := p.line
	start_column := p.column

	// Skip the [ character
	p.pos++
	p.column++

	// Skip the ^ character
	p.pos++
	p.column++

	// Read the footnote identifier
	mut identifier := ''
	for p.pos < p.text.len && p.text[p.pos] != `]` {
		identifier += p.text[p.pos].ascii_str()
		p.pos++
		p.column++
	}

	// Skip the ] character
	if p.pos < p.text.len && p.text[p.pos] == `]` {
		p.pos++
		p.column++
	} else {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}

	// Skip the : character
	if p.pos < p.text.len && p.text[p.pos] == `:` {
		p.pos++
		p.column++
	} else {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}

	// Skip whitespace
	p.skip_whitespace()

	// Read the footnote content
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

	// Read additional lines of the footnote
	for p.pos < p.text.len {
		// Check if the line is indented (part of the current footnote)
		if p.text[p.pos] == ` ` || p.text[p.pos] == `\t` {
			// Count indentation
			mut indent := 0
			for p.pos < p.text.len && (p.text[p.pos] == ` ` || p.text[p.pos] == `\t`) {
				indent++
				p.pos++
				p.column++
			}

			// If indented enough, it's part of the current footnote
			if indent >= 2 {
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
			} else {
				// Not indented enough, end of footnote
				break
			}
		} else if p.text[p.pos] == `\n` {
			// Empty line - could be a continuation or the end of the footnote
			p.pos++
			p.line++
			p.column = 1

			// Check if the next line is indented
			if p.pos < p.text.len && (p.text[p.pos] == ` ` || p.text[p.pos] == `\t`) {
				lines << ''
			} else {
				break
			}
		} else {
			// Not an indented line, end of footnote
			break
		}
	}

	// Join the lines with newlines
	content = lines.join('\n')

	// Create the footnote element
	mut footnote := &MarkdownElement{
		typ:         .footnote
		content:     content
		line_number: start_line
		column:      start_column
		attributes:  {
			'identifier': identifier
		}
	}

	// Parse inline elements within the footnote
	footnote.children = p.parse_inline(content)

	// Add the footnote to the document
	p.doc.footnotes[identifier] = footnote

	return footnote
}
