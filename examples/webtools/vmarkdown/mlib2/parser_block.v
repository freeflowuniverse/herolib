module mlib2

// Parse a block-level element
fn (mut p Parser) parse_block() ?&MarkdownElement {
	// Skip whitespace at the beginning of a line
	p.skip_whitespace()
	
	// Check for end of input
	if p.pos >= p.text.len {
		return none
	}
	
	// Check for different block types
	if p.text[p.pos] == `#` {
		return p.parse_heading()
	} else if p.text[p.pos] == `>` {
		return p.parse_blockquote()
	} else if p.text[p.pos] == `-` && p.peek(1) == `-` && p.peek(2) == `-` {
		return p.parse_horizontal_rule()
	} else if p.text[p.pos] == '`' && p.peek(1) == '`' && p.peek(2) == '`' {
		return p.parse_fenced_code_block()
	} else if p.is_list_start() {
		return p.parse_list()
	} else if p.is_table_start() {
		return p.parse_table()
	} else if p.is_footnote_definition() {
		return p.parse_footnote_definition()
	} else {
		return p.parse_paragraph()
	}
}
