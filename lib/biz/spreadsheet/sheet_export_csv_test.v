module spreadsheet

fn test_sheet_export_csv() {
	// Create a test sheet
	mut sheet := sheet_new(name: 'test_sheet', nrcol: 12)!
	
	// Add some test rows with data
	mut row1 := sheet.row_new(
		name: 'row1',
		descr: 'First test row',
		tags: 'test,row,first'
	)!
	
	mut row2 := sheet.row_new(
		name: 'row2',
		descr: 'Second test row with | pipe character',
		tags: 'test,row,second'
	)!
	
	// Set some cell values
	row1.cells[0].val = 10.5
	row1.cells[0].empty = false
	row1.cells[1].val = 20.75
	row1.cells[1].empty = false
	row1.cells[2].val = 1500
	row1.cells[2].empty = false
	row1.cells[3].val = 0.0
	row1.cells[3].empty = false
	
	row2.cells[0].val = 5.25
	row2.cells[0].empty = false
	row2.cells[1].val = 0.0
	row2.cells[1].empty = false
	row2.cells[2].val = 2500
	row2.cells[2].empty = false
	row2.cells[3].val = 3.333
	row2.cells[3].empty = false
	
	// Test default export with pipe separator
	csv_output := sheet.export_csv(path: '')!
	lines := csv_output.split('\n')
	
	// Verify header line
	assert lines.len > 0
	assert lines[0].starts_with('Name|Description|AggregateType|Tags|Subgroup|')
	
	// Verify data lines
	assert lines.len >= 3 // Header + 2 data rows
	assert lines[1].starts_with('row1|First test row|sum|test,row,first|')
	
	// Check for the cell values in the output
	assert lines[1].contains('|10.5|')
	assert lines[1].contains('|20.75|')
	assert lines[1].contains('|1500|')
	
	// Test with custom separator and include_empty option
	csv_output2 := sheet.export_csv(
		path: '',
		separator: ',',
		include_empty: true
	)!
	lines2 := csv_output2.split('\n')
	
	// Verify that empty cells are included as '0'
	assert lines2[1].contains('0')
	
	// When using comma separator, the comma in tags should be quoted, not the pipe character
	assert lines2[2].contains('Second test row with | pipe character')
	assert lines2[2].contains('"test,row,second"')
	
	// Test with different separator
	csv_output3 := sheet.export_csv(
		path: '',
		separator: ';'
	)!
	lines3 := csv_output3.split('\n')
	
	// Verify separator is used correctly
	assert lines3[0].starts_with('Name;Description;AggregateType;Tags;Subgroup;')
}
