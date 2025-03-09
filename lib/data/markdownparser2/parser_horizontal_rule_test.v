module markdownparser2

fn test_parse_horizontal_rule_basic() {
	// Test basic horizontal rule parsing with dashes
	md_text := '---'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Failed to parse horizontal rule') }
	
	assert element.typ == .horizontal_rule
	assert element.content == ''
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_horizontal_rule_with_asterisks() {
	// Test horizontal rule with asterisks
	md_text := '***'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Failed to parse horizontal rule with asterisks') }
	
	assert element.typ == .horizontal_rule
	assert element.content == ''
}

fn test_parse_horizontal_rule_with_underscores() {
	// Test horizontal rule with underscores
	md_text := '___'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Failed to parse horizontal rule with underscores') }
	
	assert element.typ == .horizontal_rule
	assert element.content == ''
}

fn test_parse_horizontal_rule_with_more_characters() {
	// Test horizontal rule with more than 3 characters
	md_text := '-----'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Failed to parse horizontal rule with more characters') }
	
	assert element.typ == .horizontal_rule
	assert element.content == ''
}

fn test_parse_horizontal_rule_with_spaces() {
	// Test horizontal rule with spaces
	md_text := '- - -'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	// Current implementation doesn't support spaces between characters
	// so this should be parsed as a list item, not a horizontal rule
	element := parser.parse_horizontal_rule() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not horizontal rule
	assert element.typ == .paragraph
}

fn test_parse_horizontal_rule_with_whitespace() {
	// Test horizontal rule with whitespace
	md_text := '---   '
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Failed to parse horizontal rule with whitespace') }
	
	assert element.typ == .horizontal_rule
	assert element.content == ''
}

fn test_parse_horizontal_rule_with_newline() {
	// Test horizontal rule followed by newline
	md_text := '---\nNext line'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Failed to parse horizontal rule with newline') }
	
	assert element.typ == .horizontal_rule
	assert element.content == ''
	
	// Parser position should be at the start of the next line
	assert parser.pos == 4 // "---\n" is 4 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_horizontal_rule_invalid_too_few_chars() {
	// Test invalid horizontal rule (too few characters)
	md_text := '--'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not horizontal rule
	assert element.typ == .paragraph
	assert element.content == '--'
}

fn test_parse_horizontal_rule_invalid_with_text() {
	// Test invalid horizontal rule (with text)
	md_text := '--- text'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not horizontal rule
	assert element.typ == .paragraph
	assert element.content == '--- text'
}

fn test_parse_horizontal_rule_mixed_characters() {
	// Test horizontal rule with mixed characters (not supported)
	md_text := '-*-'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_horizontal_rule() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not horizontal rule
	assert element.typ == .paragraph
	assert element.content == '-*-'
}
