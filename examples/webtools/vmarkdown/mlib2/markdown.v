module mlib2

// MarkdownElement represents a single element in a markdown document
pub struct MarkdownElement {
pub:
	typ ElementType
	content string
	children []&MarkdownElement
	attributes map[string]string
	line_number int
	column int
}

// ElementType represents the type of a markdown element
pub enum ElementType {
	document
	heading
	paragraph
	blockquote
	code_block
	list
	list_item
	table
	table_row
	table_cell
	horizontal_rule
	link
	image
	emphasis
	strong
	strikethrough
	inline_code
	html
	text
	footnote
	footnote_ref
	task_list_item
}

// MarkdownDocument represents a parsed markdown document
pub struct MarkdownDocument {
pub mut:
	root &MarkdownElement
	footnotes map[string]&MarkdownElement
}

// Creates a new markdown document
pub fn new_document() MarkdownDocument {
	root := &MarkdownElement{
		typ: .document
		content: ''
		children: []
	}
	return MarkdownDocument{
		root: root
		footnotes: map[string]&MarkdownElement{}
	}
}

// Parses markdown text and returns a MarkdownDocument
pub fn parse(text string) MarkdownDocument {
	mut parser := Parser{
		text: text
		pos: 0
		line: 1
		column: 1
	}
	return parser.parse()
}

