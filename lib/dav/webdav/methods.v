module webdav

import time
import freeflowuniverse.herolib.ui.console
import encoding.xml
import net.urllib
import veb
import log
import strings

@['/:path...'; options]
pub fn (app &App) options(mut ctx Context, path string) veb.Result {
	ctx.res.set_status(.ok)
	ctx.res.header.add_custom('dav', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.res.header.add(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.res.header.add_custom('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.res.header.add(.access_control_allow_origin, '*')
	ctx.res.header.add(.access_control_allow_methods, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.res.header.add(.access_control_allow_headers, 'Authorization, Content-Type')
	ctx.res.header.add(.content_length, '0')
	return ctx.text('')
}

// parse_lock_xml parses the XML data from a WebDAV LOCK request
// and extracts the lock parameters (scope, type, owner)
fn parse_lock_xml(xml_data string) !LockInfo {
	mut lock_info := LockInfo{
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
	println('Parsed lock info: scope=${lock_info.scope}, type=${lock_info.lock_type}, owner=${lock_info.owner}')
	
	return lock_info
}

// LockInfo holds the parsed information from a WebDAV LOCK request
struct LockInfo {
pub mut:
	scope     string // 'exclusive' or 'shared'
	lock_type string // typically 'write'
	owner     string // owner identifier
}

@['/:path...'; lock]
pub fn (mut app App) lock_handler(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	
	// Parse lock information from XML body instead of headers
	lock_info := parse_lock_xml(ctx.req.data) or {
		console.print_stderr('Failed to parse lock XML: ${err}')
		ctx.res.set_status(.bad_request)
		return ctx.text('Invalid lock request: ${err}')
	}
		
	// Get depth and timeout from headers (these are still in headers)
	depth := ctx.get_custom_header('Depth') or { '0' }.int()
	
	// Parse timeout header which can be in format "Second-600"
	timeout_str := ctx.get_custom_header('Timeout') or { 'Second-3600' }
	mut timeout := 3600 // Default 1 hour
	
	if timeout_str.to_lower().starts_with('second-') {
		timeout_val := timeout_str.all_after('Second-')
		if timeout_val.int() > 0 {
			timeout = timeout_val.int()
		}
	}
		
	// Check if the resource is already locked by a different owner
	if existing_lock := app.lock_manager.get_lock(resource) {
		if existing_lock.owner != lock_info.owner {
			// Resource is locked by a different owner
			// Return a 423 Locked status with information about the existing lock
			ctx.res.set_status(.locked)
			
			// Create a response with information about the existing lock
			lock_discovery_response := create_lock_discovery_response(existing_lock)
			ctx.res.header.add(.content_type, 'application/xml; charset="utf-8"')
			
			return ctx.text(lock_discovery_response)
		}
	}
	
	// Try to acquire the lock
	lock_result := app.lock_manager.lock(resource, lock_info.owner, depth, timeout) or {
		// If we get here, the resource is locked by a different owner
		ctx.res.set_status(.locked)
		return ctx.text('Resource is already locked by a different owner.')
	}
	ctx.res.set_status(.ok)
	ctx.res.header.add_custom('Lock-Token', '${lock_result.token}') or { return ctx.server_error(err.msg()) }
	
	// Create a proper WebDAV lock response
	lock_response := create_lock_response(lock_result.token, lock_info, resource, timeout)
	println('debugzo4444 ${lock_response}')
	return ctx.send_response_to_client('application/xml', lock_response)
}

// create_lock_discovery_response generates an XML response with information about an existing lock
fn create_lock_discovery_response(lock_ Lock) string {
	mut sb := strings.new_builder(500)
	sb.write_string('<?xml version="1.0" encoding="utf-8"?>\n')
	// sb.write_string('<D:prop xmlns:D="DAV:">\n')
	// sb.write_string('  <D:lockdiscovery>\n')
	sb.write_string('    <D:activelock>\n')
	sb.write_string('      <D:locktype><D:write/></D:locktype>\n')
	sb.write_string('      <D:lockscope><D:exclusive/></D:lockscope>\n')
	sb.write_string('      <D:depth>${lock_.depth}</D:depth>\n')
	sb.write_string('      <D:owner>\n')
	sb.write_string('        <D:href>${lock_.owner}</D:href>\n')
	sb.write_string('      </D:owner>\n')
	sb.write_string('      <D:timeout>Second-${lock_.timeout}</D:timeout>\n')
	sb.write_string('      <D:locktoken>\n')
	sb.write_string('        <D:href>${lock_.token}</D:href>\n')
	sb.write_string('      </D:locktoken>\n')
	sb.write_string('      <D:lockroot>\n')
	sb.write_string('        <D:href>${lock_.resource}</D:href>\n')
	sb.write_string('      </D:lockroot>\n')
	sb.write_string('    </D:activelock>\n')
	// sb.write_string('  </D:lockdiscovery>\n')
	// sb.write_string('</D:prop>\n')
	
	return sb.str()
}

// create_lock_response generates the XML response for a successful lock request
fn create_lock_response(token string, lock_info LockInfo, resource string, timeout int) string {
	mut sb := strings.new_builder(500)
	sb.write_string('<?xml version="1.0" encoding="utf-8"?>\n')
	sb.write_string('<D:prop xmlns:D="DAV:">\n')
	sb.write_string('  <D:lockdiscovery xmlns:D="DAV:">\n')
	sb.write_string('    <D:activelock>\n')
	sb.write_string('      <D:locktype><D:${lock_info.lock_type}/></D:locktype>\n')
	sb.write_string('      <D:lockscope><D:${lock_info.scope}/></D:lockscope>\n')
	sb.write_string('      <D:depth>infinity</D:depth>\n')
	sb.write_string('      <D:owner>\n')
	sb.write_string('        <D:href>${lock_info.owner}</D:href>\n')
	sb.write_string('      </D:owner>\n')
	sb.write_string('      <D:timeout>Second-${timeout}</D:timeout>\n')
	sb.write_string('      <D:locktoken>\n')
	sb.write_string('        <D:href>${token}</D:href>\n')
	sb.write_string('      </D:locktoken>\n')
	sb.write_string('      <D:lockroot>\n')
	sb.write_string('        <D:href>${resource}</D:href>\n')
	sb.write_string('      </D:lockroot>\n')
	sb.write_string('    </D:activelock>\n')
	sb.write_string('  </D:lockdiscovery>\n')
	sb.write_string('</D:prop>\n')
	
	return sb.str()
}

@['/:path...'; unlock]
pub fn (mut app App) unlock_handler(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	token_ := ctx.get_custom_header('Lock-Token') or { return ctx.server_error(err.msg()) }
	token := token_.trim_string_left('<').trim_string_right('>')
	if token.len == 0 {
		console.print_stderr('Unlock failed: `Lock-Token` header required.')
		ctx.res.set_status(.bad_request)
		return ctx.text('Lock failed: `Owner` header missing.')
	}

	println('debugzoZ ${token}')
	if app.lock_manager.unlock_with_token(resource, token) {
		ctx.res.set_status(.no_content)
		return ctx.text('Lock successfully released')
	}

	console.print_stderr('Resource is not locked or token mismatch.')
	ctx.res.set_status(.conflict)
	return ctx.text('Resource is not locked or token mismatch')
}

@['/:path...'; get]
pub fn (mut app App) get_file(mut ctx Context, path string) veb.Result {
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	fs_entry := app.vfs.get(path) or {
		console.print_stderr('failed to get FS Entry ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	println('debugzone-- ${fs_entry.get_path()} >> ${path}')
	file_data := app.vfs.file_read(path) or { return ctx.server_error(err.msg()) }

	ext := fs_entry.get_metadata().name.all_after_last('.')
	content_type := veb.mime_types[ext] or { 'text/plain' }

	ctx.res.set_status(.ok)
	return ctx.text(file_data.str())
}

@[head]
pub fn (app &App) index(mut ctx Context) veb.Result {
	ctx.res.header.add(.content_length, '0')
	return ctx.ok('')
}

@['/:path...'; head]
pub fn (mut app App) exists(mut ctx Context, path string) veb.Result {
	// Check if the requested path exists in the virtual filesystem
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	// Add necessary WebDAV headers
	ctx.res.header.add(.authorization, 'Basic') // Indicates Basic auth usage
	ctx.res.header.add_custom('DAV', '1, 2') or {
		return ctx.server_error('Failed to set DAV header: ${err}')
	}
	ctx.res.header.add_custom('Etag', 'abc123xyz') or {
		return ctx.server_error('Failed to set ETag header: ${err}')
	}
	ctx.res.header.add(.content_length, '0') // HEAD request, so no body
	ctx.res.header.add(.date, time.now().as_utc().format()) // Correct UTC date format
	// ctx.res.header.add(.content_type, 'application/xml') // XML is common for WebDAV metadata
	ctx.res.header.add_custom('Allow', 'OPTIONS, GET, HEAD, PROPFIND, PROPPATCH, MKCOL, PUT, DELETE, COPY, MOVE, LOCK, UNLOCK') or {
		return ctx.server_error('Failed to set Allow header: ${err}')
	}
	ctx.res.header.add(.accept_ranges, 'bytes') // Allows range-based file downloads
	ctx.res.header.add_custom('Cache-Control', 'no-cache, no-store, must-revalidate') or {
		return ctx.server_error('Failed to set Cache-Control header: ${err}')
	}
	ctx.res.header.add_custom('Last-Modified', time.now().as_utc().format()) or {
		return ctx.server_error('Failed to set Last-Modified header: ${err}')
	}
	ctx.res.set_status(.ok)
	ctx.res.set_version(.v1_1)

	// Debugging output (can be removed in production)
	println('HEAD response: ${ctx.res}')

	return ctx.ok('')
}

@['/:path...'; delete]
pub fn (mut app App) delete(mut ctx Context, path string) veb.Result {
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	fs_entry := app.vfs.get(path) or {
		console.print_stderr('failed to get FS Entry ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	if fs_entry.is_dir() {
		console.print_debug('deleting directory: ${path}')
		app.vfs.dir_delete(path) or { return ctx.server_error(err.msg()) }
	}

	if fs_entry.is_file() {
		console.print_debug('deleting file: ${path}')
		app.vfs.file_delete(path) or { return ctx.server_error(err.msg()) }
	}

	ctx.res.set_status(.no_content)
	return ctx.text('entry ${path} is deleted')
}

@['/:path...'; copy]
pub fn (mut app App) copy(mut ctx Context, path string) veb.Result {
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	destination := ctx.req.header.get_custom('Destination') or {
		return ctx.server_error(err.msg())
	}
	destination_url := urllib.parse(destination) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('Invalid Destination ${destination}: ${err}')
	}
	destination_path_str := destination_url.path

	app.vfs.copy(path, destination_path_str) or {
		console.print_stderr('failed to copy: ${err}')
		return ctx.server_error(err.msg())
	}

	ctx.res.set_status(.ok)
	return ctx.text('HTTP 200: Successfully copied entry: ${path}')
}

@['/:path...'; move]
pub fn (mut app App) move(mut ctx Context, path string) veb.Result {
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	destination := ctx.req.header.get_custom('Destination') or {
		return ctx.server_error(err.msg())
	}
	destination_url := urllib.parse(destination) or {
		ctx.res.set_status(.bad_request)
		return ctx.text('Invalid Destination ${destination}: ${err}')
	}
	destination_path_str := destination_url.path

	log.info('[WebDAV] ${@FN} from ${path} to ${destination_path_str}')
	app.vfs.move(path, destination_path_str) or {
		console.print_stderr('failed to move: ${err}')
		return ctx.server_error(err.msg())
	}

	ctx.res.set_status(.ok)
	return ctx.text('HTTP 200: Successfully copied entry: ${path}')
}

@['/:path...'; mkcol]
pub fn (mut app App) mkcol(mut ctx Context, path string) veb.Result {
	if app.vfs.exists(path) {
		ctx.res.set_status(.bad_request)
		return ctx.text('Another collection exists at ${path}')
	}

	log.info('[WebDAV] Make Collection ${path}')
	app.vfs.dir_create(path) or {
		console.print_stderr('failed to create directory ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	ctx.res.set_status(.created)
	return ctx.text('HTTP 201: Created')
}

@['/:path...'; propfind]
fn (mut app App) propfind(mut ctx Context, path string) veb.Result {
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}
	depth := ctx.req.header.get_custom('Depth') or { '0' }.int()

	responses := app.get_responses(path, depth) or {
		console.print_stderr('failed to get responses: ${err}')
		return ctx.server_error(err.msg())
	}
	doc := xml.XMLDocument{
		root: xml.XMLNode{
			name:       'D:multistatus'
			children:   responses
			attributes: {
				'xmlns:D': 'DAV:'
			}
		}
	}
	res := '<?xml version="1.0" encoding="UTF-8"?>${doc.pretty_str('').split('\n')[1..].join('')}'
	ctx.res.set_status(.multi_status)
	return ctx.send_response_to_client('application/xml', res)
	// return veb.not_found()
}

@['/:path...'; put]
fn (mut app App) create_or_update(mut ctx Context, path string) veb.Result {
	if app.vfs.exists(path) {
		if fs_entry := app.vfs.get(path) {
			if fs_entry.is_dir() {
				console.print_stderr('Cannot PUT to a directory: ${path}')
				ctx.res.set_status(.method_not_allowed)
				return ctx.text('HTTP 405: Method Not Allowed')
			}
		} else {
			return ctx.server_error('failed to get FS Entry ${path}: ${err.msg()}')
		}
		data := ctx.req.data.bytes()
		app.vfs.file_write(path, data) or { return ctx.server_error(err.msg()) }
		return ctx.ok('HTTP 200: Successfully saved file: ${path}')
	} else {
		app.vfs.file_create(path) or { return ctx.server_error(err.msg()) }
	}
	return ctx.ok('HTTP 200: Successfully created file: ${path}')

}
