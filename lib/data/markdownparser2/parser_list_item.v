module markdownparser2

// Parse a list item
fn (mut p Parser) parse_list_item(is_ordered bool, marker string) ?&MarkdownElement {
	// Save starting position for potential rollback
	start_pos := p.pos // Unused but kept for consistency
	start_line := p.line
	start_column := p.column
	
	// Skip whitespace
	p.skip_whitespace()
	
	// Check for task list item
	mut is_task := false
	mut is_completed := false
	
	if p.pos + 3 < p.text.len && p.text[p.pos] == `[` && 
	   (p.text[p.pos + 1] == ` ` || p.text[p.pos + 1] == `x` || p.text[p.pos + 1] == `X`) && 
	   p.text[p.pos + 2] == `]` && (p.text[p.pos + 3] == ` ` || p.text[p.pos + 3] == `\t`) {
		is_task = true
		is_completed = p.text[p.pos + 1] == `x` || p.text[p.pos + 1] == `X`
		p.pos += 3
		p.column += 3
		p.skip_whitespace()
	}
	
	// Read item content until end of line or next list item
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
	
	// Read additional lines of the list item
	for p.pos < p.text.len {
		// Check if the line is indented (part of the current item)
		if p.text[p.pos] == ` ` || p.text[p.pos] == `\t` {
			// Count indentation
			mut indent := 0
			for p.pos < p.text.len && (p.text[p.pos] == ` ` || p.text[p.pos] == `\t`) {
				indent++
				p.pos++
				p.column++
			}
			
			// If indented enough, it's part of the current item
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
				// Not indented enough, end of list item
				break
			}
		} else if p.text[p.pos] == `\n` {
			// Empty line - could be a continuation or the end of the list item
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
			// Not an indented line, end of list item
			break
		}
	}
	
	// Join the lines with newlines
	content = lines.join('\n')
	
	// Create the list item element
	mut item := &MarkdownElement{
		typ: if is_task { .task_list_item } else { .list_item }
		content: content
		line_number: start_line
		column: start_column
		attributes: if is_task {
			{
				'completed': is_completed.str()
			}
		} else {
			map[string]string{}
		}
	}
	
	// Parse inline elements within the list item
	item.children = p.parse_inline(content)
	
	return item
}
