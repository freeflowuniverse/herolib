module markdownparser2

fn test_parse_blockquote_basic() {
	// Test basic blockquote parsing
	md_text := '> This is a blockquote'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_blockquote() or { panic('Failed to parse blockquote') }

	assert element.typ == .blockquote
	assert element.content == 'This is a blockquote'
	assert element.line_number == 1
	assert element.column == 1

	// Blockquote should have a child paragraph
	assert element.children.len == 1
	assert element.children[0].typ == .paragraph
	assert element.children[0].content == 'This is a blockquote'
}

fn test_parse_blockquote_multiline() {
	// Test multi-line blockquote
	md_text := '> Line 1\n> Line 2\n> Line 3'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_blockquote() or { panic('Failed to parse multi-line blockquote') }

	assert element.typ == .blockquote
	assert element.content == 'Line 1\nLine 2\nLine 3'

	// Blockquote should have a child paragraph
	assert element.children.len == 1
	assert element.children[0].typ == .paragraph
	assert element.children[0].content == 'Line 1 Line 2 Line 3' // Paragraphs join lines with spaces
}

fn test_parse_blockquote_with_empty_lines() {
	// Test blockquote with empty lines
	md_text := '> Line 1\n>\n> Line 3'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_blockquote() or { panic('Failed to parse blockquote with empty lines') }

	assert element.typ == .blockquote
	assert element.content == 'Line 1\n\nLine 3'

	// Blockquote should have two paragraphs separated by the empty line
	assert element.children.len == 2
	assert element.children[0].typ == .paragraph
	assert element.children[0].content == 'Line 1'
	assert element.children[1].typ == .paragraph
	assert element.children[1].content == 'Line 3'
}

fn test_parse_blockquote_with_nested_elements() {
	// Test blockquote with nested elements
	md_text := '> # Heading\n> \n> - List item 1\n> - List item 2'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_blockquote() or {
		panic('Failed to parse blockquote with nested elements')
	}

	assert element.typ == .blockquote
	assert element.content == '# Heading\n\n- List item 1\n- List item 2'

	// The nested parser will parse the content as a document
	// and the blockquote will have the document's children
	// In this case, it should have a heading, an empty paragraph, and a paragraph with the list items
	assert element.children.len == 3
	assert element.children[0].typ == .heading
	assert element.children[0].content == 'Heading'
	assert element.children[0].attributes['level'] == '1'
	// Second child is an empty paragraph from the empty line
	assert element.children[1].typ == .paragraph
	assert element.children[1].content == ''
	// Third child is a paragraph with the list items (not parsed as a list)
	assert element.children[2].typ == .list
	assert element.children[2].children.len == 2 // Two list items
}

fn test_parse_blockquote_without_space() {
	// Test blockquote without space after >
	md_text := '>No space after >'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_blockquote() or { panic('Failed to parse blockquote without space') }

	assert element.typ == .blockquote
	assert element.content == 'No space after >'

	// Blockquote should have a child paragraph
	assert element.children.len == 1
	assert element.children[0].typ == .paragraph
	assert element.children[0].content == 'No space after >'
}

fn test_parse_blockquote_with_lazy_continuation() {
	// Test blockquote with lazy continuation (lines without > that are part of the blockquote)
	// Note: This is not currently supported by the parser, but could be added in the future
	md_text := '> Line 1\nLine 2 (lazy continuation)\n> Line 3'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_blockquote() or {
		panic('Failed to parse blockquote with lazy continuation')
	}

	assert element.typ == .blockquote
	assert element.content == 'Line 1'

	// Current implementation doesn't support lazy continuation,
	// so the blockquote should end at the first line
	assert element.children.len == 1
	assert element.children[0].typ == .paragraph
	assert element.children[0].content == 'Line 1'

	// Parser position should be at the start of the second line
	assert parser.pos == 9 // "> Line 1\n" is 9 characters
	assert parser.line == 2
	assert parser.column == 1
}
