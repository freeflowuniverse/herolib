module webdav

import time
import freeflowuniverse.herolib.ui.console
import encoding.xml
import net.urllib
import veb
import log
import strings

@[head]
pub fn (server &Server) index(mut ctx Context) veb.Result {
	ctx.set_custom_header('DAV', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_custom_header('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.access_control_allow_origin, '*')
	ctx.set_header(.access_control_allow_methods, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_header(.access_control_allow_headers, 'Authorization, Content-Type')
	ctx.set_header(.content_length, '0')
	return ctx.ok('')
}

@['/:path...'; options]
pub fn (server &Server) options(mut ctx Context, path string) veb.Result {
	ctx.set_custom_header('DAV', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_custom_header('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.access_control_allow_origin, '*')
	ctx.set_header(.access_control_allow_methods, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_header(.access_control_allow_headers, 'Authorization, Content-Type')
	ctx.set_header(.content_length, '0')
	return ctx.ok('')
}

@['/:path...'; lock]
pub fn (mut server Server) lock(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	
	// Parse lock information from XML body instead of headers
	lock_info := parse_lock_xml(ctx.req.data) or {
		console.print_stderr('Failed to parse lock XML: ${err}')
		ctx.res.set_status(.bad_request)
		return ctx.text('Invalid lock request: ${err}')
	}

	// Get depth and timeout from headers (these are still in headers)
	// Parse timeout header which can be in format "Second-600"
	timeout_str := ctx.get_custom_header('Timeout') or { 'Second-3600' }
	mut timeout := 3600 // Default 1 hour
	
	if timeout_str.to_lower().starts_with('second-') {
		timeout_val := timeout_str.all_after('Second-')
		if timeout_val.int() > 0 {
			timeout = timeout_val.int()
		}
	}

	new_lock := Lock {
		...lock_info,
		resource: ctx.req.url
		depth: ctx.get_custom_header('Depth') or { '0' }.int()
		timeout: timeout
	}
	
	// Try to acquire the lock
	lock_result := server.lock_manager.lock(new_lock) or {
		// If we get here, the resource is locked by a different owner
		ctx.res.set_status(.locked)
		return ctx.text('Resource is already locked by a different owner.')
	}

	// log.debug('[WebDAV] Received lock result ${lock_result.xml()}')
	ctx.res.set_status(.ok)
	ctx.set_custom_header('Lock-Token', '${lock_result.token}') or { return ctx.server_error(err.msg()) }
	
	// Create a proper WebDAV lock response
	return ctx.send_response_to_client('application/xml', lock_result.xml())
}

@['/:path...'; unlock]
pub fn (mut server Server) unlock(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	token_ := ctx.get_custom_header('Lock-Token') or { return ctx.server_error(err.msg()) }
	token := token_.trim_string_left('<').trim_string_right('>')
	if token.len == 0 {
		console.print_stderr('Unlock failed: `Lock-Token` header required.')
		ctx.res.set_status(.bad_request)
		return ctx.text('Lock failed: `Owner` header missing.')
	}

	if server.lock_manager.unlock_with_token(resource, token) {
		ctx.res.set_status(.no_content)
		return ctx.text('Lock successfully released')
	}

	console.print_stderr('Resource is not locked or token mismatch.')
	ctx.res.set_status(.conflict)
	return ctx.text('Resource is not locked or token mismatch')
}

@['/:path...'; get]
pub fn (mut server Server) get_file(mut ctx Context, path string) veb.Result {
	log.info('[WebDAV] Getting file ${path}')
	file_data := server.vfs.file_read(path) or { 
		log.error('[WebDAV] ${err.msg()}')
		return ctx.server_error(err.msg()) 
	}
	ext := path.all_after_last('.')
	content_type := veb.mime_types['.${ext}'] or { 'text/plain' }
	// ctx.res.header.set(.content_length, file_data.len.str())
	// ctx.res.set_status(.ok)
	return ctx.send_response_to_client(content_type, file_data.bytestr())
}

@['/:path...'; head]
pub fn (mut server Server) exists(mut ctx Context, path string) veb.Result {
	// Check if the requested path exists in the virtual filesystem
	if !server.vfs.exists(path) {
		return ctx.not_found()
	}

	// Add necessary WebDAV headers
	// ctx.set_header(.authorization, 'Basic') // Indicates Basic auth usage
	ctx.set_custom_header('dav', '1, 2') or {
		return ctx.server_error('Failed to set DAV header: ${err}')
	}
	ctx.set_header(.content_length, '0') // HEAD request, so no body
	// ctx.set_header(.date, time.now().as_utc().format_rfc1123()) // Correct UTC date format
	// ctx.set_header(.content_type, 'application/xml') // XML is common for WebDAV metadata
	ctx.set_custom_header('Allow', 'OPTIONS, GET, HEAD, PROPFIND, PROPPATCH, MKCOL, PUT, DELETE, COPY, MOVE, LOCK, UNLOCK') or {
		return ctx.server_error('Failed to set Allow header: ${err}')
	}
	ctx.set_header(.accept_ranges, 'bytes') // Allows range-based file downloads
	ctx.set_custom_header('Cache-Control', 'no-cache, no-store, must-revalidate') or {
		return ctx.server_error('Failed to set Cache-Control header: ${err}')
	}
	ctx.set_custom_header('Last-Modified', time.now().as_utc().format()) or {
		return ctx.server_error('Failed to set Last-Modified header: ${err}')
	}
	ctx.res.set_version(.v1_1)

	// Debugging output (can be removed in production)
	return ctx.ok('')
}

@['/:path...'; delete]
pub fn (mut server Server) delete(mut ctx Context, path string) veb.Result {
	server.vfs.delete(path) or {
		return ctx.server_error(err.msg())
	}
	
	// Return success response
	return ctx.no_content()
}

@['/:path...'; copy]
pub fn (mut server Server) copy(mut ctx Context, path string) veb.Result {
	if !server.vfs.exists(path) {
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

	server.vfs.copy(path, destination_path_str) or {
	log.set_level(.debug)
		
		println('[WebDAV] Failed to copy: ${err}')
		return ctx.server_error(err.msg())
	}

	ctx.res.set_status(.ok)
	return ctx.text('HTTP 200: Successfully copied entry: ${path}')
}

@['/:path...'; move]
pub fn (mut server Server) move(mut ctx Context, path string) veb.Result {
	if !server.vfs.exists(path) {
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
	server.vfs.move(path, destination_path_str) or {
		log.error('Failed to move: ${err}')
		return ctx.server_error(err.msg())
	}

	ctx.res.set_status(.ok)
	return ctx.text('HTTP 200: Successfully copied entry: ${path}')
}

@['/:path...'; mkcol]
pub fn (mut server Server) mkcol(mut ctx Context, path string) veb.Result {
	if server.vfs.exists(path) {
		ctx.res.set_status(.bad_request)
		return ctx.text('Another collection exists at ${path}')
	}

	log.info('[WebDAV] Make Collection ${path}')
	server.vfs.dir_create(path) or {
		console.print_stderr('failed to create directory ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	ctx.res.set_status(.created)
	return ctx.text('HTTP 201: Created')
}

@['/:path...'; put]
fn (mut server Server) create_or_update(mut ctx Context, path string) veb.Result {
	if server.vfs.exists(path) {
		if fs_entry := server.vfs.get(path) {
			if fs_entry.is_dir() {
				console.print_stderr('Cannot PUT to a directory: ${path}')
				ctx.res.set_status(.method_not_allowed)
				return ctx.text('HTTP 405: Method Not Allowed')
			}
		} else {
			return ctx.server_error('failed to get FS Entry ${path}: ${err.msg()}')
		}
	} else {
		server.vfs.file_create(path) or { return ctx.server_error(err.msg()) }
	}
	if ctx.req.data.len > 0 {
		data := ctx.req.data.bytes()
		server.vfs.file_write(path, data) or { return ctx.server_error(err.msg()) }
		return ctx.ok('HTTP 200: Successfully wrote file: ${path}')
	}
	return ctx.ok('HTTP 200: Successfully created file: ${path}')
}