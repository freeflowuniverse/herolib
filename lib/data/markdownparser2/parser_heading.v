module markdownparser2

// Parse a heading element
fn (mut p Parser) parse_heading() ?&MarkdownElement {
	start_pos := p.pos
	start_line := p.line
	start_column := p.column
	
	// Count the number of # characters
	mut level := 0
	for p.pos < p.text.len && p.text[p.pos] == `#` && level < 6 {
		level++
		p.pos++
		p.column++
	}
	
	// Must be followed by a space
	if p.pos >= p.text.len || (p.text[p.pos] != ` ` && p.text[p.pos] != `\t`) {
		p.pos = start_pos
		p.line = start_line
		p.column = start_column
		return p.parse_paragraph()
	}
	
	// Skip whitespace after #
	p.skip_whitespace()
	
	// Read the heading text until end of line
	mut content := ''
	for p.pos < p.text.len && p.text[p.pos] != `\n` {
		content += p.text[p.pos].ascii_str()
		p.pos++
		p.column++
	}
	
	// Skip the newline
	if p.pos < p.text.len && p.text[p.pos] == `\n` {
		p.pos++
		p.line++
		p.column = 1
	}
	
	// Trim trailing whitespace and optional closing #s
	content = content.trim_right(' \t')
	for content.ends_with('#') {
		content = content.trim_right('#').trim_right(' \t')
	}
	
	// Create the heading element
	mut heading := &MarkdownElement{
		typ: .heading
		content: content
		line_number: start_line
		column: start_column
		attributes: {
			'level': level.str()
		}
	}
	
	// Parse inline elements within the heading
	heading.children = p.parse_inline(content)
	
	return heading
}
