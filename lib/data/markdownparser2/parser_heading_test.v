module markdownparser2

fn test_parse_heading_basic() {
	// Test basic heading parsing
	md_text := '# Heading 1'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_heading() or { panic('Failed to parse heading') }
	
	assert element.typ == .heading
	assert element.content == 'Heading 1'
	assert element.attributes['level'] == '1'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_heading_all_levels() {
	// Test all heading levels (1-6)
	headings := [
		'# Heading 1',
		'## Heading 2',
		'### Heading 3',
		'#### Heading 4',
		'##### Heading 5',
		'###### Heading 6',
	]
	
	for i, heading_text in headings {
		level := i + 1
		mut parser := Parser{
			text: heading_text
			pos: 0
			line: 1
			column: 1
			doc: new_document()
		}
		
		element := parser.parse_heading() or { panic('Failed to parse heading level $level') }
		
		assert element.typ == .heading
		assert element.content == 'Heading $level'
		assert element.attributes['level'] == level.str()
	}
}

fn test_parse_heading_with_trailing_hashes() {
	// Test heading with trailing hashes
	md_text := '# Heading 1 #####'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_heading() or { panic('Failed to parse heading with trailing hashes') }
	
	assert element.typ == .heading
	assert element.content == 'Heading 1'
	assert element.attributes['level'] == '1'
}

fn test_parse_heading_with_extra_whitespace() {
	// Test heading with extra whitespace
	md_text := '#    Heading with extra space    '
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_heading() or { panic('Failed to parse heading with extra whitespace') }
	
	assert element.typ == .heading
	assert element.content == 'Heading with extra space'
	assert element.attributes['level'] == '1'
}

fn test_parse_heading_invalid() {
	// Test invalid heading (no space after #)
	md_text := '#NoSpace'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_heading() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not heading
	assert element.typ == .paragraph
	assert element.content == '#NoSpace'
}

fn test_parse_heading_with_newline() {
	// Test heading followed by newline
	md_text := '# Heading 1\nNext line'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_heading() or { panic('Failed to parse heading with newline') }
	
	assert element.typ == .heading
	assert element.content == 'Heading 1'
	assert element.attributes['level'] == '1'
	
	// Parser position should be at the start of the next line
	assert parser.pos == 12 // "# Heading 1\n" is 12 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_heading_too_many_hashes() {
	// Test with more than 6 hashes (should be parsed as paragraph)
	md_text := '####### Heading 7'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_heading() or { panic('Failed to parse heading with too many hashes') }
	
	// Current implementation parses this as a paragraph, not a heading
	assert element.typ == .paragraph
	assert element.content == '####### Heading 7'
}
