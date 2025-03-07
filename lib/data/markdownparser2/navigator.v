module markdownparser2

// Navigator provides an easy way to navigate through the document structure
@[heap]
pub struct Navigator {
pub:
	doc MarkdownDocument
pub mut:
	current_element &MarkdownElement
}

// Creates a new navigator for a markdown document
pub fn new_navigator(doc MarkdownDocument) Navigator {
	return Navigator{
		doc: doc
		current_element: doc.root
	}
}

// Reset the navigator to the root element
pub fn (mut n Navigator) reset() {
	n.current_element = n.doc.root
}

// Find an element by type
pub fn (mut n Navigator) find_by_type(typ ElementType) ?&MarkdownElement {
	return n.find_by_type_from(n.doc.root, typ)
}

// Find an element by type starting from a specific element
fn (mut n Navigator) find_by_type_from(element &MarkdownElement, typ ElementType) ?&MarkdownElement {
	if element.typ == typ {
		n.current_element = element
		return element
	}
	
	for child in element.children {
		if child.typ == typ {
			n.current_element = child
			return child
		}
		
		if result := n.find_by_type_from(child, typ) {
			return result
		}
	}
	
	return none
}

// Find all elements by type
pub fn (mut n Navigator) find_all_by_type(typ ElementType) []&MarkdownElement {
	return n.find_all_by_type_from(n.doc.root, typ)
}

// Find all elements by type starting from a specific element
fn (mut n Navigator) find_all_by_type_from(element &MarkdownElement, typ ElementType) []&MarkdownElement {
	mut results := []&MarkdownElement{}
	
	if element.typ == typ {
		results << element
	}
	
	for child in element.children {
		if child.typ == typ {
			results << child
		}
		
		results << n.find_all_by_type_from(child, typ)
	}
	
	return results
}

// Find an element by content
pub fn (mut n Navigator) find_by_content(text string) ?&MarkdownElement {
	return n.find_by_content_from(n.doc.root, text)
}

// Find an element by content starting from a specific element
fn (mut n Navigator) find_by_content_from(element &MarkdownElement, text string) ?&MarkdownElement {
	if element.content.contains(text) {
		n.current_element = element
		return element
	}
	
	for child in element.children {
		if child.content.contains(text) {
			n.current_element = child
			return child
		}
		
		if result := n.find_by_content_from(child, text) {
			return result
		}
	}
	
	return none
}

// Find all elements by content
pub fn (mut n Navigator) find_all_by_content(text string) []&MarkdownElement {
	return n.find_all_by_content_from(n.doc.root, text)
}

// Find all elements by content starting from a specific element
fn (mut n Navigator) find_all_by_content_from(element &MarkdownElement, text string) []&MarkdownElement {
	mut results := []&MarkdownElement{}
	
	if element.content.contains(text) {
		results << element
	}
	
	for child in element.children {
		if child.content.contains(text) {
			results << child
		}
		
		results << n.find_all_by_content_from(child, text)
	}
	
	return results
}

// Find an element by attribute
pub fn (mut n Navigator) find_by_attribute(key string, value string) ?&MarkdownElement {
	return n.find_by_attribute_from(n.doc.root, key, value)
}

// Find an element by attribute starting from a specific element
fn (mut n Navigator) find_by_attribute_from(element &MarkdownElement, key string, value string) ?&MarkdownElement {
	if element.attributes[key] == value {
		n.current_element = element
		return element
	}
	
	for child in element.children {
		if child.attributes[key] == value {
			n.current_element = child
			return child
		}
		
		if result := n.find_by_attribute_from(child, key, value) {
			return result
		}
	}
	
	return none
}

// Find all elements by attribute
pub fn (mut n Navigator) find_all_by_attribute(key string, value string) []&MarkdownElement {
	return n.find_all_by_attribute_from(n.doc.root, key, value)
}

// Find all elements by attribute starting from a specific element
fn (mut n Navigator) find_all_by_attribute_from(element &MarkdownElement, key string, value string) []&MarkdownElement {
	mut results := []&MarkdownElement{}
	
	if element.attributes[key] == value {
		results << element
	}
	
	for child in element.children {
		if child.attributes[key] == value {
			results << child
		}
		
		results << n.find_all_by_attribute_from(child, key, value)
	}
	
	return results
}

// Find the parent of an element
pub fn (mut n Navigator) find_parent(target &MarkdownElement) ?&MarkdownElement {
	return n.find_parent_from(n.doc.root, target)
}

// Find the parent of an element starting from a specific element
fn (mut n Navigator) find_parent_from(root &MarkdownElement, target &MarkdownElement) ?&MarkdownElement {
	for child in root.children {
		if child == target {
			n.current_element = root
			return root
		}
		
		if result := n.find_parent_from(child, target) {
			return result
		}
	}
	
	return none
}

// Get the parent of the current element
pub fn (mut n Navigator) parent() ?&MarkdownElement {
	return n.find_parent(n.current_element)
}

// Get the next sibling of the current element
pub fn (mut n Navigator) next_sibling() ?&MarkdownElement {
	parent := n.parent() or { return none }
	
	mut found := false
	for child in parent.children {
		if found {
			n.current_element = child
			return child
		}
		
		if child == n.current_element {
			found = true
		}
	}
	
	return none
}

// Get the previous sibling of the current element
pub fn (mut n Navigator) prev_sibling() ?&MarkdownElement {
	parent := n.parent() or { return none }
	
	mut prev := &MarkdownElement(unsafe { nil })
	for i, child in parent.children {
		if child == n.current_element && prev != unsafe { nil } {
			n.current_element = prev
			return prev
		}
		
		if i < parent.children.len - 1 {
			prev = parent.children[i]
		}
	}
	
	return none
}

// Get the first child of the current element
pub fn (mut n Navigator) first_child() ?&MarkdownElement {
	if n.current_element.children.len == 0 {
		return none
	}
	
	n.current_element = n.current_element.children[0]
	return n.current_element
}

// Get the last child of the current element
pub fn (mut n Navigator) last_child() ?&MarkdownElement {
	if n.current_element.children.len == 0 {
		return none
	}
	
	n.current_element = n.current_element.children[n.current_element.children.len - 1]
	return n.current_element
}

// Get all footnotes in the document
pub fn (n Navigator) footnotes() map[string]&MarkdownElement {
	return n.doc.footnotes
}

// Get a footnote by identifier
pub fn (n Navigator) footnote(id string) ?&MarkdownElement {
	if id in n.doc.footnotes {
		return unsafe { n.doc.footnotes[id] }
	}
	
	return none
}
