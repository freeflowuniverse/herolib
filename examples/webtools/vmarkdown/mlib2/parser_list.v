module mlib2

// Parse a list element
fn (mut p Parser) parse_list() ?&MarkdownElement {
	start_pos := p.pos
	start_line := p.line
	start_column := p.column
	
	// Determine list type (ordered or unordered)
	mut is_ordered := false
	mut start_number := 1
	mut marker := ''
	
	if p.text[p.pos].is_digit() {
		// Ordered list
		is_ordered = true
		
		// Parse start number
		mut num_str := ''
		for p.pos < p.text.len && p.text[p.pos].is_digit() {
			num_str += p.text[p.pos].ascii_str()
			p.pos++
			p.column++
		}
		
		start_number = num_str.int()
		
		// Must be followed by a period
		if p.pos >= p.text.len || p.text[p.pos] != `.` {
			p.pos = start_pos
			p.line = start_line
			p.column = start_column
			return p.parse_paragraph()
		}
		
		marker = '.'
		p.pos++
		p.column++
	} else {
		// Unordered list
		marker = p.text[p.pos].ascii_str()
		p.pos++
		p.column++
	}
	
	// Must be followed by whitespace
	if p.pos >= p.text.len || (p.text[p.pos] != ` ` && p.text[p.pos] != `\t`) {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}
	
	// Create the list element
	mut list := &MarkdownElement{
		typ: .list
		content: ''
		line_number: start_line
		column: start_column
		attributes: {
			'ordered': is_ordered.str()
			'start': start_number.str()
			'marker': marker
		}
	}
	
	// Parse list items
	for {
		// Parse list item
		if item := p.parse_list_item(is_ordered, marker) {
			list.children << item
		} else {
			break
		}
		
		// Check if we're at the end of the list
		p.skip_whitespace()
		
		if p.pos >= p.text.len {
			break
		}
		
		// Check for next list item
		if is_ordered {
			if !p.text[p.pos].is_digit() {
				break
			}
		} else {
			if p.text[p.pos] != marker[0] {
				break
			}
		}
	}
	
	return list
}
