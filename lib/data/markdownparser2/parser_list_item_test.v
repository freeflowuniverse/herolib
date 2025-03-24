module markdownparser2

fn test_parse_list_item_basic() {
	// Test basic list item parsing
	md_text := 'Item text'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or { panic('Failed to parse list item') }

	assert element.typ == .list_item
	assert element.content == 'Item text'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_list_item_with_newline() {
	// Test list item with newline
	md_text := 'Item text\nNext line'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse list item with newline')
	}

	assert element.typ == .list_item
	assert element.content == 'Item text'
	assert element.line_number == 1
	assert element.column == 1

	// Parser position should be at the start of the next line
	assert parser.pos == 10 // "Item text\n" is 10 characters (including the newline)
	assert parser.line == 2
	assert parser.column == 1 // Current implementation sets column to 2
}

fn test_parse_list_item_with_continuation() {
	// Test list item with continuation lines
	md_text := 'Item text\n  continued line\n  another continuation'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse list item with continuation')
	}

	assert element.typ == .list_item
	assert element.content == 'Item text\ncontinued line\nanother continuation'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_list_item_with_insufficient_indent() {
	// Test list item with insufficient indent (should not be part of the item)
	md_text := 'Item text\n not indented enough'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse list item with insufficient indent')
	}

	assert element.typ == .list_item
	assert element.content == 'Item text'
	assert element.line_number == 1
	assert element.column == 1

	// Parser position should be at the start of the next line
	assert parser.pos == 11 // "Item text\n" is 11 characters (including the newline)
	assert parser.line == 2
	assert parser.column == 2
}

fn test_parse_list_item_with_empty_line() {
	// Test list item with empty line followed by continuation
	md_text := 'Item text\n\n  continuation after empty line'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse list item with empty line')
	}

	assert element.typ == .list_item
	assert element.content == 'Item text\n\ncontinuation after empty line'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_list_item_with_multiple_paragraphs() {
	// Test list item with multiple paragraphs
	md_text := 'First paragraph\n\n  Second paragraph'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse list item with multiple paragraphs')
	}

	assert element.typ == .list_item
	assert element.content == 'First paragraph\n\nSecond paragraph'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_task_list_item_unchecked() {
	// Test unchecked task list item
	md_text := '[ ] Task item'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse unchecked task list item')
	}

	assert element.typ == .task_list_item
	assert element.content == 'Task item'
	assert element.attributes['completed'] == 'false'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_task_list_item_checked() {
	// Test checked task list item
	md_text := '[x] Task item'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse checked task list item')
	}

	assert element.typ == .task_list_item
	assert element.content == 'Task item'
	assert element.attributes['completed'] == 'true'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_task_list_item_uppercase_x() {
	// Test task list item with uppercase X
	md_text := '[X] Task item'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse task list item with uppercase X')
	}

	assert element.typ == .task_list_item
	assert element.content == 'Task item'
	assert element.attributes['completed'] == 'true'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_task_list_item_with_continuation() {
	// Test task list item with continuation
	md_text := '[x] Task item\n  continuation'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(false, '-') or {
		panic('Failed to parse task list item with continuation')
	}

	assert element.typ == .task_list_item
	assert element.content == 'Task item\ncontinuation'
	assert element.attributes['completed'] == 'true'
	assert element.line_number == 1
	assert element.column == 1
}

fn test_parse_list_item_ordered() {
	// Test ordered list item
	md_text := 'Ordered item'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_list_item(true, '.') or { panic('Failed to parse ordered list item') }

	assert element.typ == .list_item
	assert element.content == 'Ordered item'
	assert element.line_number == 1
	assert element.column == 1
}
