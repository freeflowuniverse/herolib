# V Markdown Parser

A pure V implementation of a Markdown parser that supports extended Markdown syntax and provides an easy way to navigate through the document structure.

## Features

- Parses Markdown text into a structured representation
- Supports both basic and extended Markdown syntax
- Provides an easy way to navigate through the document structure
- Includes renderers for different output formats
- No external dependencies

## Supported Markdown Syntax

- Headings (# to ######)
- Paragraphs
- Blockquotes
- Lists (ordered and unordered)
- Task lists
- Code blocks (fenced with language support)
- Tables with alignment
- Horizontal rules
- Footnotes
- Basic text elements (currently as plain text, with planned support for inline formatting)

## Usage

### Parsing Markdown

```v
import mlib2

// Parse Markdown text
md_text := '# Hello World\n\nThis is a paragraph.'
doc := mlib2.parse(md_text)

// Access the document structure
root := doc.root
for child in root.children {
    println(child.typ)
}
```

### Navigating the Document

```v
import mlib2

// Parse Markdown text
md_text := '# Hello World\n\nThis is a paragraph.'
doc := mlib2.parse(md_text)

// Create a navigator
mut nav := mlib2.new_navigator(doc)

// Find elements by type
headings := nav.find_all_by_type(.heading)
for heading in headings {
    level := heading.attributes['level']
    println('Heading level ${level}: ${heading.content}')
}

// Find elements by content
if para := nav.find_by_content('paragraph') {
    println('Found paragraph: ${para.content}')
}

// Navigate through the document
if first_heading := nav.find_by_type(.heading) {
    println('First heading: ${first_heading.content}')
    
    // Move to next sibling
    if next := nav.next_sibling() {
        println('Next element after heading: ${next.typ}')
    }
}
```

### Rendering the Document

```v
import mlib2

// Parse Markdown text
md_text := '# Hello World\n\nThis is a paragraph.'

// Render as structure (for debugging)
structure := mlib2.to_structure(md_text)
println(structure)

// Render as plain text
plain_text := mlib2.to_plain(md_text)
println(plain_text)
```

## Element Types

The parser recognizes the following element types:

- `document`: The root element of the document
- `heading`: A heading element (h1-h6)
- `paragraph`: A paragraph of text
- `blockquote`: A blockquote
- `code_block`: A code block
- `list`: A list (ordered or unordered)
- `list_item`: An item in a list
- `task_list_item`: A task list item with checkbox
- `table`: A table
- `table_row`: A row in a table
- `table_cell`: A cell in a table
- `horizontal_rule`: A horizontal rule
- `footnote`: A footnote definition
- `footnote_ref`: A reference to a footnote
- `text`: A text element
- `link`, `image`, `emphasis`, `strong`, `strikethrough`, `inline_code`: Inline formatting elements (planned for future implementation)

## Element Structure

Each Markdown element has the following properties:

- `typ`: The type of the element
- `content`: The text content of the element
- `children`: Child elements
- `attributes`: Additional attributes specific to the element type
- `line_number`: The line number where the element starts in the source
- `column`: The column number where the element starts in the source

## Future Improvements

- Implement parsing of inline elements (bold, italic, links, etc.)
- Add HTML renderer
- Support for more extended Markdown syntax
- Performance optimizations
