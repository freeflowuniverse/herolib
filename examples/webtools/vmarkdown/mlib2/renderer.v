module mlib2

// Renderer is the interface for all renderers
pub interface Renderer {
	render(doc MarkdownDocument) string
}

// StructureRenderer renders a markdown document as a structure
pub struct StructureRenderer {
	indent string = '  '
}

// Creates a new structure renderer
pub fn new_structure_renderer() StructureRenderer {
	return StructureRenderer{}
}

// Render a markdown document as a structure
pub fn (r StructureRenderer) render(doc MarkdownDocument) string {
	return r.render_element(doc.root, 0)
}

// Render an element as a structure
fn (r StructureRenderer) render_element(element &MarkdownElement, level int) string {
	mut result := r.indent.repeat(level) + '${element.typ}'
	
	if element.content.len > 0 {
		// Truncate long content
		mut content := element.content
		if content.len > 50 {
			content = content[0..47] + '...'
		}
		// Escape newlines
		content = content.replace('\n', '\\n')
		result += ': "${content}"'
	}
	
	if element.attributes.len > 0 {
		result += ' {'
		mut first := true
		for key, value in element.attributes {
			if !first {
				result += ', '
			}
			result += '${key}: "${value}"'
			first = false
		}
		result += '}'
	}
	
	result += '\n'
	
	for child in element.children {
		result += r.render_element(child, level + 1)
	}
	
	return result
}

// PlainTextRenderer renders a markdown document as plain text
pub struct PlainTextRenderer {}

// Creates a new plain text renderer
pub fn new_plain_text_renderer() PlainTextRenderer {
	return PlainTextRenderer{}
}

// Render a markdown document as plain text
pub fn (r PlainTextRenderer) render(doc MarkdownDocument) string {
	return r.render_element(doc.root)
}

// Render an element as plain text
fn (r PlainTextRenderer) render_element(element &MarkdownElement) string {
	mut result := ''
	
	match element.typ {
		.document {
			for child in element.children {
				result += r.render_element(child)
				if child.typ != .horizontal_rule {
					result += '\n\n'
				}
			}
			// Trim trailing newlines
			result = result.trim_right('\n')
		}
		.heading {
			level := element.attributes['level'].int()
			result += '#'.repeat(level) + ' ' + element.content
		}
		.paragraph {
			result += element.content
		}
		.blockquote {
			lines := element.content.split('\n')
			for line in lines {
				result += '> ' + line + '\n'
			}
			result = result.trim_right('\n')
		}
		.code_block {
			language := element.attributes['language']
			result += '```${language}\n'
			result += element.content
			result += '```'
		}
		.list {
			is_ordered := element.attributes['ordered'] == 'true'
			start_number := element.attributes['start'].int()
			
			mut i := start_number
			for child in element.children {
				if is_ordered {
					result += '${i}. '
					i++
				} else {
					result += '- '
				}
				result += r.render_element(child) + '\n'
			}
			result = result.trim_right('\n')
		}
		.list_item, .task_list_item {
			if element.typ == .task_list_item {
				is_completed := element.attributes['completed'] == 'true'
				if is_completed {
					result += '[x] '
				} else {
					result += '[ ] '
				}
			}
			result += element.content
		}
		.table {
			// TODO: Implement table rendering
			result += '[Table with ${element.children.len} rows]'
		}
		.horizontal_rule {
			result += '---'
		}
		.footnote {
			identifier := element.attributes['identifier']
			result += '[^${identifier}]: ${element.content}'
		}
		.text {
			result += element.content
		}
		else {
			result += element.content
		}
	}
	
	return result
}

// Convenience function to render markdown text as a structure
pub fn to_structure(text string) string {
	doc := parse(text)
	mut renderer := new_structure_renderer()
	return renderer.render(doc)
}

// Convenience function to render markdown text as plain text
pub fn to_plain(text string) string {
	doc := parse(text)
	mut renderer := new_plain_text_renderer()
	return renderer.render(doc)
}
