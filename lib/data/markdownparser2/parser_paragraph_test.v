module markdownparser2

fn test_parse_paragraph_basic() {
	// Test basic paragraph parsing
	md_text := 'This is a paragraph'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph') }
	
	assert element.typ == .paragraph
	assert element.content == 'This is a paragraph'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_paragraph_with_newline() {
	// Test paragraph with newline
	md_text := 'Line 1\nLine 2'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph with newline') }
	
	assert element.typ == .paragraph
	assert element.content == 'Line 1 Line 2' // Lines are joined with spaces
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_paragraph_with_multiple_lines() {
	// Test paragraph with multiple lines
	md_text := 'Line 1\nLine 2\nLine 3'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph with multiple lines') }
	
	assert element.typ == .paragraph
	assert element.content == 'Line 1 Line 2 Line 3' // Lines are joined with spaces
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_paragraph_with_empty_line() {
	// Test paragraph ending with empty line
	md_text := 'Paragraph\n\nNext paragraph'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph with empty line') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be after the empty line
	assert parser.pos == 11 // "Paragraph\n\n" is 11 characters
	assert parser.line == 3
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_block_element() {
	// Test paragraph ending at a block element
	md_text := 'Paragraph\n# Heading'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at block element') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph |Column 1|Column 2| |---|---|'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the heading
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_blockquote() {
	// Test paragraph ending at a blockquote
	md_text := 'Paragraph\n> Blockquote'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at blockquote') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the blockquote
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_horizontal_rule() {
	// Test paragraph ending at a horizontal rule
	md_text := 'Paragraph\n---'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at horizontal rule') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the horizontal rule
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_code_block() {
	// Test paragraph ending at a code block
	md_text := 'Paragraph\n```\ncode\n```'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at code block') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the code block
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_list() {
	// Test paragraph ending at a list
	md_text := 'Paragraph\n- List item'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at list') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the list
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_table() {
	// Test paragraph ending at a table
	md_text := 'Paragraph\n|Column 1|Column 2|\n|---|---|'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at table') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the table
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_ending_at_footnote() {
	// Test paragraph ending at a footnote
	md_text := 'Paragraph\n[^1]: Footnote'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph ending at footnote') }
	
	assert element.typ == .paragraph
	assert element.content == 'Paragraph'
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the footnote
	assert parser.pos == 10 // "Paragraph\n" is 10 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_paragraph_with_inline_elements() {
	// Test paragraph with inline elements
	// Note: Currently the parser doesn't parse inline elements separately
	md_text := 'Text with **bold** and *italic*'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_paragraph() or { panic('Failed to parse paragraph with inline elements') }
	
	assert element.typ == .paragraph
	assert element.content == 'Text with **bold** and *italic*'
	assert element.line_number == 1
	assert element.column == 1
	
	// Currently, inline elements are not parsed separately
	assert element.children.len == 1
	assert element.children[0].typ == .text
	assert element.children[0].content == 'Text with **bold** and *italic*'
}
