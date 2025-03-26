module markdownparser2

fn test_parse_table_basic() {
	// Test basic table parsing
	md_text := '|Column 1|Column 2|\n|---|---|\n|Cell 1|Cell 2|'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table') }

	assert element.typ == .table
	assert element.line_number == 1
	assert element.column == 1

	// Check rows
	assert element.children.len == 2 // Header row + 1 data row

	// Check header row
	header_row := element.children[0]
	assert header_row.typ == .table_row
	assert header_row.attributes['is_header'] == 'true'
	assert header_row.children.len == 2 // 2 header cells
	assert header_row.children[0].typ == .table_cell
	assert header_row.children[0].content == 'Column 1'
	assert header_row.children[0].attributes['is_header'] == 'true'
	assert header_row.children[0].attributes['align'] == 'left' // Default alignment
	assert header_row.children[1].typ == .table_cell
	assert header_row.children[1].content == 'Column 2'
	assert header_row.children[1].attributes['is_header'] == 'true'
	assert header_row.children[1].attributes['align'] == 'left' // Default alignment

	// Check data row
	data_row := element.children[1]
	assert data_row.typ == .table_row
	assert data_row.children.len == 2 // 2 data cells
	assert data_row.children[0].typ == .table_cell
	assert data_row.children[0].content == 'Cell 1'
	assert data_row.children[0].attributes['align'] == 'left' // Default alignment
	assert data_row.children[1].typ == .table_cell
	assert data_row.children[1].content == 'Cell 2'
	assert data_row.children[1].attributes['align'] == 'left' // Default alignment
}

fn test_parse_table_with_alignment() {
	// Test table with column alignment
	md_text := '|Left|Center|Right|\n|:---|:---:|---:|\n|1|2|3|'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table with alignment') }

	assert element.typ == .table

	// Check header row
	header_row := element.children[0]
	assert header_row.children.len == 3 // 3 header cells
	assert header_row.children[0].attributes['align'] == 'left'
	assert header_row.children[1].attributes['align'] == 'center'
	assert header_row.children[2].attributes['align'] == 'right'

	// Check data row
	data_row := element.children[1]
	assert data_row.children.len == 3 // 3 data cells
	assert data_row.children[0].attributes['align'] == 'left'
	assert data_row.children[1].attributes['align'] == 'center'
	assert data_row.children[2].attributes['align'] == 'right'
}

fn test_parse_table_without_leading_pipe() {
	// Test table without leading pipe
	md_text := 'Column 1|Column 2\n---|---\nCell 1|Cell 2'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table without leading pipe') }

	assert element.typ == .table

	// Check rows
	assert element.children.len == 2 // Header row + 1 data row

	// Check header row
	header_row := element.children[0]
	assert header_row.children.len == 2 // 2 header cells
	assert header_row.children[0].content == 'Column 1'
	assert header_row.children[1].content == 'Column 2'

	// Check data row
	data_row := element.children[1]
	assert data_row.children.len == 2 // 2 data cells
	assert data_row.children[0].content == 'Cell 1'
	assert data_row.children[1].content == 'Cell 2'
}

fn test_parse_table_without_trailing_pipe() {
	// Test table without trailing pipe
	md_text := '|Column 1|Column 2\n|---|---\n|Cell 1|Cell 2'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table without trailing pipe') }

	assert element.typ == .table

	// Check rows
	assert element.children.len == 2 // Header row + 1 data row

	// Check header row
	header_row := element.children[0]
	assert header_row.children.len == 2 // 2 header cells
	assert header_row.children[0].content == 'Column 1'
	assert header_row.children[1].content == 'Column 2'

	// Check data row
	data_row := element.children[1]
	assert data_row.children.len == 2 // 2 data cells
	assert data_row.children[0].content == 'Cell 1'
	assert data_row.children[1].content == 'Cell 2'
}

fn test_parse_table_with_empty_cells() {
	// Test table with empty cells
	md_text := '|Column 1|Column 2|Column 3|\n|---|---|---|\n|Cell 1||Cell 3|'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table with empty cells') }

	assert element.typ == .table

	// Check data row
	data_row := element.children[1]
	assert data_row.children.len == 3 // 3 data cells
	assert data_row.children[0].content == 'Cell 1'
	assert data_row.children[1].content == '' // Empty cell
	assert data_row.children[2].content == 'Cell 3'
}

fn test_parse_table_with_multiple_data_rows() {
	// Test table with multiple data rows
	md_text := '|Column 1|Column 2|\n|---|---|\n|Row 1, Cell 1|Row 1, Cell 2|\n|Row 2, Cell 1|Row 2, Cell 2|'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table with multiple data rows') }

	assert element.typ == .table

	// Check rows
	assert element.children.len == 3 // Header row + 2 data rows

	// Check header row
	header_row := element.children[0]
	assert header_row.children.len == 2 // 2 header cells

	// Check first data row
	data_row1 := element.children[1]
	assert data_row1.children.len == 2 // 2 data cells
	assert data_row1.children[0].content == 'Row 1, Cell 1'
	assert data_row1.children[1].content == 'Row 1, Cell 2'

	// Check second data row
	data_row2 := element.children[2]
	assert data_row2.children.len == 2 // 2 data cells
	assert data_row2.children[0].content == 'Row 2, Cell 1'
	assert data_row2.children[1].content == 'Row 2, Cell 2'
}

fn test_parse_table_with_whitespace() {
	// Test table with whitespace in cells
	md_text := '| Column 1 | Column 2 |\n| --- | --- |\n| Cell 1 | Cell 2 |'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table with whitespace') }

	assert element.typ == .table

	// Check header row
	header_row := element.children[0]
	assert header_row.children.len == 2 // 2 header cells
	assert header_row.children[0].content == 'Column 1'
	assert header_row.children[1].content == 'Column 2'

	// Check data row
	data_row := element.children[1]
	assert data_row.children.len == 2 // 2 data cells
	assert data_row.children[0].content == 'Cell 1'
	assert data_row.children[1].content == 'Cell 2'
}

fn test_parse_table_with_uneven_columns() {
	// Test table with uneven columns
	md_text := '|Column 1|Column 2|Column 3|\n|---|---|\n|Cell 1|Cell 2|'
	mut parser := Parser{
		text:   md_text
		pos:    0
		line:   1
		column: 1
		doc:    new_document()
	}

	element := parser.parse_table() or { panic('Failed to parse table with uneven columns') }

	assert element.typ == .table

	// Check header row
	header_row := element.children[0]
	assert header_row.children.len == 3 // 3 header cells

	// Check data row
	data_row := element.children[1]
	assert data_row.children.len == 2 // 2 data cells (as defined by the separator row)
}
