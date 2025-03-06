module webdav

import encoding.xml
import time

pub struct Lock {
pub mut:
	resource   string
	owner      string
	token      string
	depth      int // 0 for a single resource, 1 for recursive
	timeout    int // in seconds
	created_at time.Time
	lock_type string // typically 'write'
	scope     string // 'exclusive' or 'shared'
}

fn (l Lock) xml() string {
	return $tmpl('./templates/lock_response.xml')
}

// parse_lock_xml parses the XML data from a WebDAV LOCK request
// and extracts the lock parameters (scope, type, owner)
fn parse_lock_xml(xml_data string) !Lock {
	mut lock_info := Lock{
		scope: 'exclusive' // default values
		lock_type: 'write'
		owner: ''
	}
	
	// Parse the XML document
	doc := xml.XMLDocument.from_string(xml_data) or { 
		return error('Failed to parse XML: ${err}')
	}
	
	// Get the root element (lockinfo)
	root := doc.root
	
	// Handle namespace prefixes (D:) in element names
	// WebDAV uses namespaces, so we need to check for both prefixed and non-prefixed names
	
	// Extract lockscope
	for child in root.children {
		if child is xml.XMLNode {
			node := child as xml.XMLNode
			
			// Check for lockscope (with or without namespace prefix)
			if node.name == 'lockscope' || node.name == 'D:lockscope' {
				for scope_child in node.children {
					if scope_child is xml.XMLNode {
						scope_node := scope_child as xml.XMLNode
						if scope_node.name == 'exclusive' || scope_node.name == 'D:exclusive' {
							lock_info.scope = 'exclusive'
						} else if scope_node.name == 'shared' || scope_node.name == 'D:shared' {
							lock_info.scope = 'shared'
						}
					}
				}
			}
			
			// Check for locktype (with or without namespace prefix)
			if node.name == 'locktype' || node.name == 'D:locktype' {
				for type_child in node.children {
					if type_child is xml.XMLNode {
						type_node := type_child as xml.XMLNode
						if type_node.name == 'write' || type_node.name == 'D:write' {
							lock_info.lock_type = 'write'
						}
					}
				}
			}
			
			// Check for owner (with or without namespace prefix)
			if node.name == 'owner' || node.name == 'D:owner' {
				for owner_child in node.children {
					if owner_child is xml.XMLNode {
						owner_node := owner_child as xml.XMLNode
						if owner_node.name == 'href' || owner_node.name == 'D:href' {
							for href_content in owner_node.children {
								if href_content is string {
									lock_info.owner = (href_content as string).trim_space()
									break
								}
							}
						}
					} else if owner_child is string {
						// Some clients might include owner text directly
						lock_info.owner = (owner_child as string).trim_space()
					}
				}
			}
		}
	}
	
	// If owner is still empty, try to extract it from any text content in the owner node
	if lock_info.owner.len == 0 {
		for child in root.children {
			if child is xml.XMLNode {
				node := child as xml.XMLNode
				if node.name == 'owner' || node.name == 'D:owner' {
					for content in node.children {
						if content is string {
							lock_info.owner = (content as string).trim_space()
							break
						}
					}
				}
			}
		}
	}
	
	// Use a default owner if none was found
	if lock_info.owner.len == 0 {
		lock_info.owner = 'unknown-client'
	}
	
	// Debug output
	// println('Parsed lock info: scope=${lock_info.scope}, type=${lock_info.lock_type}, owner=${lock_info.owner}')
	
	return lock_info
}

