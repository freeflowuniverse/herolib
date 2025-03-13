module webdav

import encoding.xml
import log
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.vfs
import os
import time
import veb

// Property represents a WebDAV property
pub interface Property {
	xml() xml.XMLNodeContents
// 	xml_name() string
// 	to_xml_node() xml.XMLNode
// }
}

type DisplayName = string
type GetETag = string
type GetLastModified = string
type GetContentType = string
type GetContentLength = string
type QuotaAvailableBytes = u64
type QuotaUsedBytes = u64
type QuotaUsed = u64
type Quota = u64
type ResourceType = bool
type CreationDate = string
type SupportedLock = string
type LockDiscovery = string

// fn (p []Property) xml() string {
// 	return '<D:propstat>
//         <D:prop>${p.map(it.xml()).join_lines()}</D:prop>
//         <D:status>HTTP/1.1 200 OK</D:status>
//     </D:propstat>'
// }

fn (p []Property) xml() xml.XMLNode {
	return xml.XMLNode{
		name: 'D:propstat'
		children: [
			xml.XMLNode{
				name: 'D:prop'
				children: p.map(it.xml())
			},
			xml.XMLNode{
				name: 'D:status'
				children: [xml.XMLNodeContents('HTTP/1.1 200 OK')]
			}
		]
	}
}

fn (p DisplayName) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:displayname'
		children: [xml.XMLNodeContents(p)]
	}
}

fn (p GetETag) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:getetag'
		children: [xml.XMLNodeContents(p)]
	}
}

fn (p GetLastModified) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:getlastmodified'
		children: [xml.XMLNodeContents(p)]
	}
}

fn (p GetContentType) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:getcontenttype'
		children: [xml.XMLNodeContents(p)]
	}
}

fn (p GetContentLength) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:getcontentlength'
		children: [xml.XMLNodeContents(p)]
	}
}

fn (p QuotaAvailableBytes) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:quota-available-bytes'
		children: [xml.XMLNodeContents(p.str())]
	}
}

fn (p QuotaUsedBytes) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:quota-used-bytes'
		children: [xml.XMLNodeContents(p.str())]
	}
}

fn (p Quota) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:quota'
		children: [xml.XMLNodeContents(p.str())]
	}
}

fn (p QuotaUsed) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:quotaused'
		children: [xml.XMLNodeContents(p.str())]
	}
}

fn (p ResourceType) xml() xml.XMLNodeContents {
	if p {
		// If it's a collection, add the collection element as a child
		mut children := []xml.XMLNodeContents{}
		children << xml.XMLNode{
			name: 'D:collection'
		}
		
		return xml.XMLNode{
			name: 'D:resourcetype'
			children: children
		}
	} else {
		// If it's not a collection, return an empty resourcetype element
		return xml.XMLNode{
			name: 'D:resourcetype'
			children: []xml.XMLNodeContents{}
		}
	}
}

fn (p CreationDate) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:creationdate'
		children: [xml.XMLNodeContents(p)]
	}
}

fn (p SupportedLock) xml() xml.XMLNodeContents {
	// Create children for the supportedlock node
	mut children := []xml.XMLNodeContents{}
	
	// First lockentry - exclusive
	mut lockscope1_children := []xml.XMLNodeContents{}
	lockscope1_children << xml.XMLNode{
		name: 'D:exclusive'
	}
	
	lockscope1 := xml.XMLNode{
		name: 'D:lockscope'
		children: lockscope1_children
	}
	
	mut locktype1_children := []xml.XMLNodeContents{}
	locktype1_children << xml.XMLNode{
		name: 'D:write'
	}
	
	locktype1 := xml.XMLNode{
		name: 'D:locktype'
		children: locktype1_children
	}
	
	mut lockentry1_children := []xml.XMLNodeContents{}
	lockentry1_children << lockscope1
	lockentry1_children << locktype1
	
	lockentry1 := xml.XMLNode{
		name: 'D:lockentry'
		children: lockentry1_children
	}
	
	// Second lockentry - shared
	mut lockscope2_children := []xml.XMLNodeContents{}
	lockscope2_children << xml.XMLNode{
		name: 'D:shared'
	}
	
	lockscope2 := xml.XMLNode{
		name: 'D:lockscope'
		children: lockscope2_children
	}
	
	mut locktype2_children := []xml.XMLNodeContents{}
	locktype2_children << xml.XMLNode{
		name: 'D:write'
	}
	
	locktype2 := xml.XMLNode{
		name: 'D:locktype'
		children: locktype2_children
	}
	
	mut lockentry2_children := []xml.XMLNodeContents{}
	lockentry2_children << lockscope2
	lockentry2_children << locktype2
	
	lockentry2 := xml.XMLNode{
		name: 'D:lockentry'
		children: lockentry2_children
	}
	
	// Add both lockentries to children
	children << lockentry1
	children << lockentry2
	
	// Return the supportedlock node
	return xml.XMLNode{
		name: 'D:supportedlock'
		children: children
	}
}

fn (p LockDiscovery) xml() xml.XMLNodeContents {
	return xml.XMLNode{
		name: 'D:lockdiscovery'
		children: [xml.XMLNodeContents(p)]
	}
}

fn format_iso8601(t time.Time) string {
	return '${t.year:04d}-${t.month:02d}-${t.day:02d}T${t.hour:02d}:${t.minute:02d}:${t.second:02d}Z'
}