module webdav

import encoding.xml
import log
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.vfs.vfs_db
import os
import time
import net.http
import veb

// PropfindRequest represents a parsed PROPFIND request
pub struct PropfindRequest {
pub:
	typ         PropfindType
	props       []string    // Property names if typ is prop
	depth       Depth         // Depth of the request (0, 1, or -1 for infinity)
	xml_content string      // Original XML content
}

pub enum Depth {
	infinity = -1
	zero = 0
	one = 1
}

// PropfindType represents the type of PROPFIND request
pub enum PropfindType {
	allprop  // Request all properties
	propname // Request property names only
	prop     // Request specific properties
	invalid  // Invalid request
}

// parse_propfind_xml parses the XML body of a PROPFIND request
pub fn parse_propfind_xml(req http.Request) !PropfindRequest {

	data := req.data
	// Parse Depth header
	depth_str := req.header.get_custom('Depth') or { '0' }
	depth := parse_depth(depth_str)
	

	if data.len == 0 {
		// If no body is provided, default to allprop
		return PropfindRequest{
			typ: .allprop
			depth: depth
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
		depth: depth
		xml_content: data
	}
}

// parse_depth parses the Depth header value
pub fn parse_depth(depth_str string) Depth {
	if depth_str == 'infinity' { return .infinity}
	else if depth_str == '0' { return .zero}
	else if depth_str == '1' { return .one}
	else {
		log.warn('[WebDAV] Invalid Depth header value: ${depth_str}, defaulting to infinity')
		return .infinity
	}
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
	<D:propstat><D:prop>${r.found_props.map(it.xml()).join_lines()}</D:prop><D:status>HTTP/1.1 200 OK</D:status></D:propstat>
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
