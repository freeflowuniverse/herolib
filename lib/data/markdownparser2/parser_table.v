module markdownparser2

// Parse a table element
fn (mut p Parser) parse_table() ?&MarkdownElement {
	// Save starting position for potential rollback
	start_pos := p.pos // Unused but kept for consistency
	start_line := p.line
	start_column := p.column
	
	// Create the table element
	mut table := &MarkdownElement{
		typ: .table
		content: ''
		line_number: start_line
		column: start_column
	}
	
	// Parse header row
	mut header_row := &MarkdownElement{
		typ: .table_row
		content: ''
		line_number: p.line
		column: p.column
		attributes: {
			'is_header': 'true'
		}
	}
	
	// Skip initial pipe if present
	if p.text[p.pos] == `|` {
		p.pos++
		p.column++
	}
	
	// Parse header cells
	for p.pos < p.text.len && p.text[p.pos] != `\n` {
		// Parse cell content
		mut cell_content := ''
		for p.pos < p.text.len && p.text[p.pos] != `|` && p.text[p.pos] != `\n` {
			cell_content += p.text[p.pos].ascii_str()
			p.pos++
			p.column++
		}
		
		// Create cell element
		cell := &MarkdownElement{
			typ: .table_cell
			content: cell_content.trim_space()
			line_number: p.line
			column: p.column - cell_content.len
			attributes: {
				'is_header': 'true'
			}
		}
		
		// Add cell to row
		header_row.children << cell
		
		// Skip pipe
		if p.pos < p.text.len && p.text[p.pos] == `|` {
			p.pos++
			p.column++
		} else {
			break
		}
	}
	
	// Skip newline
	if p.pos < p.text.len && p.text[p.pos] == `\n` {
		p.pos++
		p.line++
		p.column = 1
	}
	
	// Add header row to table
	table.children << header_row
	
	// Parse separator row (---|---|...)
	// Skip initial pipe if present
	if p.pos < p.text.len && p.text[p.pos] == `|` {
		p.pos++
		p.column++
	}
	
	// Parse alignment information
	mut alignments := []string{}
	
	for p.pos < p.text.len && p.text[p.pos] != `\n` {
		// Skip whitespace
		for p.pos < p.text.len && (p.text[p.pos] == ` ` || p.text[p.pos] == `\t`) {
			p.pos++
			p.column++
		}
		
		// Check alignment
		mut left_colon := false
		mut right_colon := false
		
		if p.pos < p.text.len && p.text[p.pos] == `:` {
			left_colon = true
			p.pos++
			p.column++
		}
		
		// Skip dashes
		for p.pos < p.text.len && p.text[p.pos] == `-` {
			p.pos++
			p.column++
		}
		
		if p.pos < p.text.len && p.text[p.pos] == `:` {
			right_colon = true
			p.pos++
			p.column++
		}
		
		// Determine alignment
		mut alignment := 'left' // default
		if left_colon && right_colon {
			alignment = 'center'
		} else if right_colon {
			alignment = 'right'
		}
		
		alignments << alignment
		
		// Skip whitespace
		for p.pos < p.text.len && (p.text[p.pos] == ` ` || p.text[p.pos] == `\t`) {
			p.pos++
			p.column++
		}
		
		// Skip pipe
		if p.pos < p.text.len && p.text[p.pos] == `|` {
			p.pos++
			p.column++
		} else {
			break
		}
	}
	
	// Skip newline
	if p.pos < p.text.len && p.text[p.pos] == `\n` {
		p.pos++
		p.line++
		p.column = 1
	}
	
	// Set alignment for header cells
	for i, mut cell in header_row.children {
		if i < alignments.len {
			cell.attributes['align'] = alignments[i]
		}
	}
	
	// Parse data rows
	for p.pos < p.text.len && p.text[p.pos] != `\n` {
		// Create row element
		mut row := &MarkdownElement{
			typ: .table_row
			content: ''
			line_number: p.line
			column: p.column
		}
		
		// Skip initial pipe if present
		if p.text[p.pos] == `|` {
			p.pos++
			p.column++
		}
		
		// Parse cells
		mut cell_index := 0
		for p.pos < p.text.len && p.text[p.pos] != `\n` {
			// Parse cell content
			mut cell_content := ''
			for p.pos < p.text.len && p.text[p.pos] != `|` && p.text[p.pos] != `\n` {
				cell_content += p.text[p.pos].ascii_str()
				p.pos++
				p.column++
			}
			
			// Create cell element
			mut cell := &MarkdownElement{
				typ: .table_cell
				content: cell_content.trim_space()
				line_number: p.line
				column: p.column - cell_content.len
			}
			
			// Set alignment
			if cell_index < alignments.len {
				cell.attributes['align'] = alignments[cell_index]
			}
			
			// Add cell to row
			row.children << cell
			cell_index++
			
			// Skip pipe
			if p.pos < p.text.len && p.text[p.pos] == `|` {
				p.pos++
				p.column++
			} else {
				break
			}
		}
		
		// Add row to table
		table.children << row
		
		// Skip newline
		if p.pos < p.text.len && p.text[p.pos] == `\n` {
			p.pos++
			p.line++
			p.column = 1
		}
		
		// Check if we're at the end of the table
		if p.pos >= p.text.len || p.text[p.pos] != `|` {
			break
		}
	}
	
	return table
}
