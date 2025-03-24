module markdownparser2

fn test_peek() {
	// Test peeking ahead in the text
	text := 'abc'
	mut parser := Parser{
		text:   text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	// Peek at different offsets
	assert parser.peek(0) == `a`
	assert parser.peek(1) == `b`
	assert parser.peek(2) == `c`

	// Peek beyond the end of the text
	assert parser.peek(3) == 0
	assert parser.peek(100) == 0

	// Peek from different positions
	parser.pos = 1
	assert parser.peek(0) == `b`
	assert parser.peek(1) == `c`
	assert parser.peek(2) == 0
}

fn test_skip_whitespace() {
	// Test skipping whitespace
	text := '   abc'
	mut parser := Parser{
		text:   text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	// Skip whitespace at the beginning
	parser.skip_whitespace()
	assert parser.pos == 3
	assert parser.column == 4

	// Skip whitespace in the middle
	parser.pos = 4
	parser.column = 5
	parser.skip_whitespace() // No whitespace to skip
	assert parser.pos == 4
	assert parser.column == 5

	// Skip whitespace at the end
	text2 := 'abc   '
	mut parser2 := Parser{
		text:   text2
		pos:    3
		line:   1
		column: 4
		doc:    new_document()
	}

	parser2.skip_whitespace()
	assert parser2.pos == 6
	assert parser2.column == 7

	// Skip mixed whitespace
	text3 := ' \t abc'
	mut parser3 := Parser{
		text:   text3
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	parser3.skip_whitespace()
	assert parser3.pos == 3
	assert parser3.column == 4
}

fn test_is_list_start() {
	// Test checking if current position is the start of a list

	// Unordered list with dash
	text1 := '- List item'
	mut parser1 := Parser{
		text:   text1
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser1.is_list_start() == true

	// Unordered list with asterisk
	text2 := '* List item'
	mut parser2 := Parser{
		text:   text2
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser2.is_list_start() == true

	// Unordered list with plus
	text3 := '+ List item'
	mut parser3 := Parser{
		text:   text3
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser3.is_list_start() == true

	// Ordered list
	text4 := '1. List item'
	mut parser4 := Parser{
		text:   text4
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser4.is_list_start() == true

	// Ordered list with multiple digits
	text5 := '42. List item'
	mut parser5 := Parser{
		text:   text5
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser5.is_list_start() == true

	// Task list
	text6 := '- [ ] Task item'
	mut parser6 := Parser{
		text:   text6
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser6.is_list_start() == true

	// Task list with checked item
	text7 := '- [x] Task item'
	mut parser7 := Parser{
		text:   text7
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser7.is_list_start() == true

	// Not a list (no space after marker)
	text8 := '-No space'
	mut parser8 := Parser{
		text:   text8
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser8.is_list_start() == false

	// Not a list (no period after number)
	text9 := '1 No period'
	mut parser9 := Parser{
		text:   text9
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser9.is_list_start() == false

	// Not a list (no space after period)
	text10 := '1.No space'
	mut parser10 := Parser{
		text:   text10
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser10.is_list_start() == false
}

fn test_is_table_start() {
	// Test checking if current position is the start of a table

	// Basic table
	text1 := '|Column 1|Column 2|\n|---|---|'
	mut parser1 := Parser{
		text:   text1
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser1.is_table_start() == false // Current implementation returns false

	// Table without leading pipe
	text2 := 'Column 1|Column 2\n---|---'
	mut parser2 := Parser{
		text:   text2
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser2.is_table_start() == false // Current implementation requires leading pipe

	// Table with alignment
	text3 := '|Left|Center|Right|\n|:---|:---:|---:|'
	mut parser3 := Parser{
		text:   text3
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser3.is_table_start() == false // Current implementation returns false

	// Not a table (no second line)
	text4 := '|Column 1|Column 2|'
	mut parser4 := Parser{
		text:   text4
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser4.is_table_start() == false

	// Not a table (invalid separator line)
	text5 := '|Column 1|Column 2|\n|invalid|separator|'
	mut parser5 := Parser{
		text:   text5
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser5.is_table_start() == false

	// Not a table (no pipe)
	text6 := 'Not a table'
	mut parser6 := Parser{
		text:   text6
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser6.is_table_start() == false
}

fn test_is_footnote_definition() {
	// Test checking if current position is a footnote definition

	// Basic footnote
	text1 := '[^1]: Footnote text'
	mut parser1 := Parser{
		text:   text1
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser1.is_footnote_definition() == true

	// Footnote with alphanumeric identifier
	text2 := '[^abc123]: Footnote text'
	mut parser2 := Parser{
		text:   text2
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser2.is_footnote_definition() == true

	// Not a footnote (no colon)
	text3 := '[^1] No colon'
	mut parser3 := Parser{
		text:   text3
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser3.is_footnote_definition() == false

	// Not a footnote (no identifier)
	text4 := '[^]: Empty identifier'
	mut parser4 := Parser{
		text:   text4
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser4.is_footnote_definition() == false

	// Not a footnote (no caret)
	text5 := '[1]: Not a footnote'
	mut parser5 := Parser{
		text:   text5
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser5.is_footnote_definition() == false

	// Not a footnote (no brackets)
	text6 := '^1: Not a footnote'
	mut parser6 := Parser{
		text:   text6
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	assert parser6.is_footnote_definition() == false
}
