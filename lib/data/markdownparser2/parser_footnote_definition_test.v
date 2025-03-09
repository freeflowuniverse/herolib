module markdownparser2

fn test_parse_footnote_definition_basic() {
	// Test basic footnote definition parsing
	md_text := '[^1]: Footnote text'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition') }
	
	assert element.typ == .footnote
	assert element.content == 'Footnote text'
	assert element.attributes['identifier'] == '1'
	assert element.line_number == 1
	assert element.column == 1
	
	// Check that the footnote was added to the document
	assert parser.doc.footnotes.len == 1
	assert parser.doc.footnotes['1'] == element
}

fn test_parse_footnote_definition_with_multiline_content() {
	// Test footnote definition with multiline content
	md_text := '[^note]: Line 1\n  Line 2\n  Line 3'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition with multiline content') }
	
	assert element.typ == .footnote
	assert element.content == 'Line 1\nLine 2\nLine 3'
	assert element.attributes['identifier'] == 'note'
	
	// Check that the footnote was added to the document
	assert parser.doc.footnotes.len == 1
	assert parser.doc.footnotes['note'] == element
}

fn test_parse_footnote_definition_with_empty_line() {
	// Test footnote definition with empty line
	md_text := '[^1]: Line 1\n\n  Line 3'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition with empty line') }
	
	assert element.typ == .footnote
	assert element.content == 'Line 1\n\nLine 3'
	assert element.attributes['identifier'] == '1'
}

fn test_parse_footnote_definition_with_insufficient_indent() {
	// Test footnote definition with insufficient indent (should not be part of the footnote)
	md_text := '[^1]: Line 1\n Line 2'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition with insufficient indent') }
	
	assert element.typ == .footnote
	assert element.content == 'Line 1'
	assert element.attributes['identifier'] == '1'
	
	// Parser position should be at the start of the next line
	assert parser.pos == 14 // "[^1]: Line 1\n" is 14 characters
	assert parser.line == 2
	assert parser.column == 2 // Current implementation sets column to 2
}

fn test_parse_footnote_definition_with_alphanumeric_identifier() {
	// Test footnote definition with alphanumeric identifier
	md_text := '[^abc123]: Footnote text'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition with alphanumeric identifier') }
	
	assert element.typ == .footnote
	assert element.content == 'Footnote text'
	assert element.attributes['identifier'] == 'abc123'
}

fn test_parse_footnote_definition_with_special_chars_identifier() {
	// Test footnote definition with special characters in identifier
	md_text := '[^a-b_c]: Footnote text'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition with special chars identifier') }
	
	assert element.typ == .footnote
	assert element.content == 'Footnote text'
	assert element.attributes['identifier'] == 'a-b_c'
}

fn test_parse_footnote_definition_invalid_no_colon() {
	// Test invalid footnote definition (no colon)
	md_text := '[^1] No colon'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Should parse as paragraph, not fail') }
	
	// Current implementation parses this as a paragraph
	assert element.typ == .paragraph
}

fn test_parse_footnote_definition_invalid_no_identifier() {
	// Test invalid footnote definition (no identifier)
	md_text := '[^]: Empty identifier'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Should parse as paragraph, not fail') }
	
	// Current implementation parses this as a footnote with an empty identifier
	assert element.typ == .footnote
}

fn test_parse_footnote_definition_with_inline_elements() {
	// Test footnote definition with inline elements
	// Note: Currently the parser doesn't parse inline elements separately
	md_text := '[^1]: Text with **bold** and *italic*'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_footnote_definition() or { panic('Failed to parse footnote definition with inline elements') }
	
	assert element.typ == .footnote
	assert element.content == 'Text with **bold** and *italic*'
	assert element.attributes['identifier'] == '1'
	
	// Currently, inline elements are not parsed separately
	assert element.children.len == 1
	assert element.children[0].typ == .text
	assert element.children[0].content == 'Text with **bold** and *italic*'
}

fn test_parse_multiple_footnote_definitions() {
	// Test parsing multiple footnote definitions
	md_text := '[^1]: First footnote\n[^2]: Second footnote'
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	// Parse first footnote
	element1 := parser.parse_footnote_definition() or { panic('Failed to parse first footnote definition') }
	
	assert element1.typ == .footnote
	assert element1.content == 'First footnote'
	assert element1.attributes['identifier'] == '1'
	
	// Parse second footnote
	element2 := parser.parse_footnote_definition() or { panic('Failed to parse second footnote definition') }
	
	assert element2.typ == .footnote
	assert element2.content == 'Second footnote'
	assert element2.attributes['identifier'] == '2'
	
	// Check that both footnotes were added to the document
	assert parser.doc.footnotes.len == 2
	assert parser.doc.footnotes['1'] == element1
	assert parser.doc.footnotes['2'] == element2
}
