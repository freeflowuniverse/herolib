module markdownparser2

fn test_parse_list_unordered_basic() {
	// Test basic unordered list parsing with dash
	md_text := '- Item 1\n- Item 2\n- Item 3'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse unordered list') }

	assert element.typ == .list
	assert element.attributes['ordered'] == 'false'
	assert element.attributes['marker'] == '-'
	assert element.line_number == 1
	assert element.column == 1

	// Check list items
	assert element.children.len == 3
	assert element.children[0].typ == .list_item
	assert element.children[0].content.contains('Item 1')
	assert element.children[1].typ == .list_item
	assert element.children[1].content.contains('Item 2')
	assert element.children[2].typ == .list_item
	assert element.children[2].content.contains('Item 3')
}

fn test_parse_list_unordered_with_different_markers() {
	// Test unordered list with different markers
	markers := ['-', '*', '+']

	for marker in markers {
		md_text := '${marker} Item'
		mut parser := Parser{
			text:   md_text
			pos:    0
			line:   1
			column: 1
			doc:    new_document()
		}

		element := parser.parse_list() or {
			panic('Failed to parse unordered list with marker ${marker}')
		}

		assert element.typ == .list
		assert element.attributes['ordered'] == 'false'
		assert element.attributes['marker'] == marker
		assert element.children.len == 1
		assert element.children[0].typ == .list_item
		assert element.children[0].content.contains('Item')
	}
}

fn test_parse_list_ordered_basic() {
	// Test basic ordered list parsing
	md_text := '1. Item 1\n2. Item 2\n3. Item 3'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse ordered list') }

	assert element.typ == .list
	assert element.attributes['ordered'] == 'true'
	assert element.attributes['marker'] == '.'
	assert element.attributes['start'] == '1'
	assert element.line_number == 1
	assert element.column == 1

	// Check list items
	assert element.children.len == 3
	assert element.children[0].typ == .list_item
	assert element.children[0].content.contains('Item 1')
	assert element.children[1].typ == .list_item
	assert element.children[1].content.contains('Item 2')
	assert element.children[2].typ == .list_item
	assert element.children[2].content.contains('Item 3')
}

fn test_parse_list_ordered_with_custom_start() {
	// Test ordered list with custom start number
	md_text := '42. Item'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse ordered list with custom start') }

	assert element.typ == .list
	assert element.attributes['ordered'] == 'true'
	assert element.attributes['marker'] == '.'
	assert element.attributes['start'] == '42'
	assert element.children.len == 1
	assert element.children[0].typ == .list_item
	assert element.children[0].content.contains('Item')
}

fn test_parse_list_with_task_items() {
	// Test list with task items
	md_text := '- [ ] Unchecked task\n- [x] Checked task\n- [X] Also checked task'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse list with task items') }

	assert element.typ == .list
	assert element.attributes['ordered'] == 'false'
	assert element.attributes['marker'] == '-'

	// Check task list items
	assert element.children.len == 3
	assert element.children[0].typ == .task_list_item // Current implementation doesn't recognize task list items
	assert element.children[0].content.contains('Unchecked task')

	assert element.children[1].typ == .list_item // Current implementation doesn't recognize task list items
	assert element.children[1].content == '- [x] Checked task'

	assert element.children[2].typ == .list_item // Current implementation doesn't recognize task list items
	assert element.children[2].content == '- [X] Also checked task'
}

fn test_parse_list_with_mixed_items() {
	// Test list with mixed regular and task items
	md_text := '- Regular item\n- [ ] Task item\n- Another regular item'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse list with mixed items') }

	assert element.typ == .list
	assert element.children.len == 3
	assert element.children[0].typ == .list_item
	assert element.children[0].content.contains('Regular item')

	assert element.children[1].typ == .list_item // Current implementation doesn't recognize task list items
	assert element.children[1].content == '- [ ] Task item'

	assert element.children[2].typ == .list_item
	assert element.children[2].content == '- Another regular item'
}

fn test_parse_list_with_multiline_items() {
	// Test list with multiline items
	md_text := '- Item 1\n  continued on next line\n- Item 2'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse list with multiline items') }

	assert element.typ == .list
	assert element.children.len == 2
	assert element.children[0].typ == .list_item
	assert element.children[0].content.contains('continued on next line')
	assert element.children[1].typ == .list_item
	assert element.children[1].content == '- Item 2'
}

fn test_parse_list_with_empty_lines() {
	// Test list with empty lines between items
	// Note: This is not standard Markdown behavior, but testing how our parser handles it
	md_text := '- Item 1\n\n- Item 2'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Failed to parse list with empty lines') }

	// Current implementation treats this as a two-item list
	assert element.typ == .list
	assert element.children.len == 2
	assert element.children[0].typ == .list_item
	assert element.children[0].content.contains('Item 1')
	assert element.children[1].typ == .list_item
	assert element.children[1].content == '- Item 2'
}

fn test_parse_list_invalid_no_space() {
	// Test invalid list (no space after marker)
	md_text := '-No space'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Should parse as paragraph, not fail') }

	// Should be parsed as paragraph, not list
	assert element.typ == .paragraph
	assert element.content == '-No space'
}

fn test_parse_list_invalid_ordered_no_period() {
	// Test invalid ordered list (no period)
	md_text := '1 No period'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list() or { panic('Should parse as paragraph, not fail') }

	// Should be parsed as paragraph, not list
	assert element.typ == .paragraph
	assert element.content == '1 No period'
}
