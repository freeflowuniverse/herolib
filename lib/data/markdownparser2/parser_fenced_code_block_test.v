module markdownparser2

fn test_parse_fenced_code_block_basic() {
	// Test basic fenced code block parsing with backticks
	md_text := "```\ncode\n```"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block') }
	
	assert element.typ == .code_block
	assert element.content == 'code\n'
	assert element.attributes['language'] == ''
	assert element.line_number == 1
	assert element.column == 1
	
	// Parser position should be at the start of the next line
	assert parser.pos == 5 // "```\n" is 3 characters
	assert parser.line == 2
	assert parser.column == 1
}

fn test_parse_fenced_code_block_with_language() {
	// Test fenced code block with language
	md_text := "```v\nfn main() {\n\tprintln('Hello')\n}\n```"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block with language') }
	
	assert element.typ == .code_block
	assert element.content == "fn main() {\n\tprintln('Hello')\n}\n"
	assert element.attributes['language'] == 'v'
}

fn test_parse_fenced_code_block_with_tildes() {
	// Test fenced code block with tildes
	md_text := "~~~\ncode\n~~~"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block with tildes') }
	
	assert element.typ == .code_block
	assert element.content == 'code\n'
	assert element.attributes['language'] == ''
}

fn test_parse_fenced_code_block_with_more_fence_chars() {
	// Test fenced code block with more than 3 fence characters
	md_text := "````\ncode\n````"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block with more fence chars') }
	
	assert element.typ == .code_block
	assert element.content == 'code\n'
	assert element.attributes['language'] == ''
}

fn test_parse_fenced_code_block_with_empty_lines() {
	// Test fenced code block with empty lines
	md_text := "```\n\ncode\n\n```"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block with empty lines') }
	
	assert element.typ == .code_block
	assert element.content == '\ncode\n\n'
	assert element.attributes['language'] == ''
}

fn test_parse_fenced_code_block_with_indented_code() {
	// Test fenced code block with indented code
	md_text := "```\n    indented code\n```"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block with indented code') }
	
	assert element.typ == .code_block
	assert element.content == '    indented code\n'
	assert element.attributes['language'] == ''
}

fn test_parse_fenced_code_block_with_fence_chars_in_content() {
	// Test fenced code block with fence characters in content
	md_text := "```\n``\n```"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Failed to parse fenced code block with fence chars in content') }
	
	assert element.typ == .code_block
	assert element.content == '``\n'
	assert element.attributes['language'] == ''
}

fn test_parse_fenced_code_block_invalid_too_few_chars() {
	// Test invalid fenced code block (too few characters)
	md_text := "``\ncode\n``"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not code block
	assert element.typ == .paragraph
}

fn test_parse_fenced_code_block_without_closing_fence() {
	// Test fenced code block without closing fence
	md_text := "```\ncode"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not code block
	assert element.typ == .paragraph
}

fn test_parse_fenced_code_block_with_different_closing_fence() {
	// Test fenced code block with different closing fence
	md_text := "```\ncode\n~~~"
	mut parser := Parser{
		text: md_text
		pos: 0
		line: 1
		column: 1
		doc: new_document()
	}
	
	element := parser.parse_fenced_code_block() or { panic('Should parse as paragraph, not fail') }
	
	// Should be parsed as paragraph, not code block
	assert element.typ == .paragraph
}
