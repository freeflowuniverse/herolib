module markdownparser2

// This file contains examples of how to use the Markdown parser

// Example of parsing and navigating a markdown document
pub fn example_navigation() {
	md_text := '# Heading 1

This is a paragraph with **bold** and *italic* text.

## Heading 2

- List item 1
- List item 2
  - Nested item
- List item 3

```v
fn main() {
	println("Hello, world!")
}
```

> This is a blockquote
> with multiple lines

| Column 1 | Column 2 | Column 3 |
|----------|:--------:|---------:|
| Left     | Center   | Right    |
| Cell 1   | Cell 2   | Cell 3   |

[Link to V language](https://vlang.io)

![Image](https://vlang.io/img/v-logo.png)

Footnote reference[^1]

[^1]: This is a footnote.
'

	// Parse the markdown text
	doc := parse(md_text)
	
	// Create a navigator
	mut nav := new_navigator(doc)
	
	// Find all headings
	headings := nav.find_all_by_type(.heading)
	println('Found ${headings.len} headings:')
	for heading in headings {
		level := heading.attributes['level']
		println('  ${'#'.repeat(level.int())} ${heading.content}')
	}
	
	// Find the first code block
	if code_block := nav.find_by_type(.code_block) {
		language := code_block.attributes['language']
		println('\nFound code block in language: ${language}')
		println('```${language}\n${code_block.content}```')
	}
	
	// Find all list items
	list_items := nav.find_all_by_type(.list_item)
	println('\nFound ${list_items.len} list items:')
	for item in list_items {
		println('  - ${item.content}')
	}
	
	// Find content containing specific text
	if element := nav.find_by_content('blockquote') {
		println('\nFound element containing "blockquote":')
		println('  Type: ${element.typ}')
		println('  Content: ${element.content}')
	}
	
	// Find table cells
	table_cells := nav.find_all_by_type(.table_cell)
	println('\nFound ${table_cells.len} table cells:')
	for cell in table_cells {
		alignment := cell.attributes['align'] or { 'left' }
		is_header := cell.attributes['is_header'] or { 'false' }
		println('  Cell: "${cell.content}" (align: ${alignment}, header: ${is_header})')
	}
	
	// Find footnotes
	println('\nFootnotes:')
	for id, footnote in nav.footnotes() {
		println('  [^${id}]: ${footnote.content}')
	}
}

// Example of rendering a markdown document
pub fn example_rendering() {
	md_text := '# Heading 1

This is a paragraph with **bold** and *italic* text.

## Heading 2

- List item 1
- List item 2
  - Nested item
- List item 3

```v
fn main() {
	println("Hello, world!")
}
```

> This is a blockquote
> with multiple lines
'

	// Parse the markdown text
	doc := parse(md_text)
	
	// Render as structure
	mut structure_renderer := new_structure_renderer()
	structure := structure_renderer.render(doc)
	println('=== STRUCTURE RENDERING ===')
	println(structure)
	
	// Render as plain text
	mut plain_text_renderer := new_plain_text_renderer()
	plain_text := plain_text_renderer.render(doc)
	println('=== PLAIN TEXT RENDERING ===')
	println(plain_text)
	
	// Using convenience functions
	println('=== USING CONVENIENCE FUNCTIONS ===')
	println(to_structure(md_text))
	println(to_plain(md_text))
}

// Main function to run the examples
pub fn main() {
	println('=== NAVIGATION EXAMPLE ===')
	example_navigation()
	
	println('\n=== RENDERING EXAMPLE ===')
	example_rendering()
}
