module webdav

import encoding.xml
import log
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.vfs.vfs_db
import os
import time
import veb

// PropfindRequest represents a parsed PROPFIND request
pub struct PropfindRequest {
pub:
	typ         PropfindType
	props       []string    // Property names if typ is prop
	depth       int         // Depth of the request (0, 1, or -1 for infinity)
	xml_content string      // Original XML content
}

// PropfindType represents the type of PROPFIND request
pub enum PropfindType {
	allprop  // Request all properties
	propname // Request property names only
	prop     // Request specific properties
	invalid  // Invalid request
}

// parse_propfind_xml parses the XML body of a PROPFIND request
pub fn parse_propfind_xml(data string) !PropfindRequest {
	if data.len == 0 {
		// If no body is provided, default to allprop
		return PropfindRequest{
			typ: .allprop
			depth: 0
			xml_content: ''
		}
	}

	doc := xml.XMLDocument.from_string(data) or {
		return error('Failed to parse XML: ${err}')
	}

	root := doc.root
	if root.name.to_lower() != 'propfind' && !root.name.ends_with(':propfind') {
		return error('Invalid PROPFIND request: root element must be propfind')
	}

	mut typ := PropfindType.invalid
	mut props := []string{}
	
	// Check for allprop, propname, or prop elements
	for child in root.children {
		if child is xml.XMLNode {
			node := child as xml.XMLNode
			
			// Check for allprop
			if node.name == 'allprop' || node.name == 'D:allprop' {
				typ = .allprop
				break
			}
			
			// Check for propname
			if node.name == 'propname' || node.name == 'D:propname' {
				typ = .propname
				break
			}
			
			// Check for prop
			if node.name == 'prop' || node.name == 'D:prop' {
				typ = .prop
				
				// Extract property names
				for prop_child in node.children {
					if prop_child is xml.XMLNode {
						prop_node := prop_child as xml.XMLNode
						props << prop_node.name
					}
				}
				break
			}
		}
	}
	
	if typ == .invalid {
		return error('Invalid PROPFIND request: missing prop, allprop, or propname element')
	}

	return PropfindRequest{
		typ: typ
		props: props
		depth: 0
		xml_content: data
	}
}

// parse_depth parses the Depth header value
pub fn parse_depth(depth_str string) int {
	if depth_str == 'infinity' {
		return -1 // Use -1 to represent infinity
	}
	
	depth := depth_str.int()
	// Only 0, 1, and infinity are valid values for Depth
	if depth != 0 && depth != 1 {
		// Invalid depth value, default to 0
		log.warn('[WebDAV] Invalid Depth header value: ${depth_str}, defaulting to 0')
		return 0
	}
	
	return depth
}

// returns the properties of a filesystem entry
fn get_properties(entry &vfs.FSEntry) []Property {
	mut props := []Property{}

	metadata := entry.get_metadata()

	// Display name
	props << DisplayName(metadata.name)
	props << GetLastModified(format_iso8601(metadata.modified_time()))
	props << GetContentType(if entry.is_dir() {'httpd/unix-directory'} else {get_file_content_type(entry.get_path())})
	props << ResourceType(entry.is_dir())
	
	// Content length (only for files)
	if !entry.is_dir() {
		props << GetContentLength(metadata.size.str())
	}

	// Creation date
	props << CreationDate(format_iso8601(metadata.created_time()))
	return props
}

// Response represents a WebDAV response for a resource
pub struct Response {
pub:
	href           string
	found_props    	[]Property
	not_found_props []Property
}

fn (r Response) xml() string {
	return '<D:response>\n<D:href>${r.href}</D:href>
	<D:propstat>${r.found_props.xml()}<D:status>HTTP/1.1 200 OK</D:status></D:propstat>
	<D:propstat>${r.not_found_props.xml()}<D:status>HTTP/1.1 404 Not Found</D:status></D:propstat>
	</D:response>'
}

// generate_propfind_response generates a PROPFIND response XML string from Response structs
pub fn (r []Response) xml () string {
	return '<?xml version="1.0" encoding="UTF-8"?>\n<D:multistatus xmlns:D="DAV:">
	${r.map(it.xml()).join_lines()}\n</D:multistatus>'
}

fn get_file_content_type(path string) string {
	ext := path.all_after_last('.')
	content_type := if v := veb.mime_types[ext] {
		v
	} else {
		'text/plain; charset=utf-8'
	}

	return content_type
}

// get_responses returns all properties for the given path and depth
fn (mut app App) get_responses(entry vfs.FSEntry, req PropfindRequest) ![]Response {
	mut responses := []Response{}
	
	path := if entry.is_dir() && entry.get_path() != '/' {
		'${entry.get_path()}/'
	} else {
		entry.get_path()
	}
	// main entry response
	responses << Response {
		href: path
		// not_found: entry.get_unfound_properties(req)
		found_props: get_properties(entry)
	}
	
	if req.depth == 0 && entry.get_path() != '/' { return responses }

	entries := app.vfs.dir_list(path) or { 
		log.error('Failed to list directory for ${path} ${err}')
		return responses }
	for e in entries {
		responses << app.get_responses(e, PropfindRequest {
			...req,
			depth: if req.depth == 1 { 0 } else {-1}
		})!
	}
	return responses
}