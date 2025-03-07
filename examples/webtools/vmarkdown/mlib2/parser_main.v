module mlib2

// Parser is responsible for parsing markdown text
struct Parser {
mut:
	text string
	pos int
	line int
	column int
	doc MarkdownDocument
}

// Main parsing function
fn (mut p Parser) parse() MarkdownDocument {
	p.doc = new_document()
	
	// Parse blocks until end of input
	for p.pos < p.text.len {
		element := p.parse_block() or { break }
		p.doc.root.children << element
	}
	
	// Process footnotes
	p.process_footnotes()
	
	return p.doc
}

// Process footnotes and add them to the document
fn (mut p Parser) process_footnotes() {
	// Nothing to do if no footnotes
	if p.doc.footnotes.len == 0 {
		return
	}
	
	// Add a horizontal rule before footnotes
	hr := &MarkdownElement{
		typ: .horizontal_rule
		content: ''
		line_number: p.line
		column: p.column
	}
	p.doc.root.children << hr
	
	// Add footnotes section
	for key, footnote in p.doc.footnotes {
		p.doc.root.children << footnote
	}
}
