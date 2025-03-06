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
	ctx.set_custom_header('DAV', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	// ctx.set_header(.connection, 'close')
	ctx.set_custom_header('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.access_control_allow_origin, '*')
	ctx.set_header(.access_control_allow_methods, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_header(.access_control_allow_headers, 'Authorization, Content-Type')
	ctx.set_header(.content_length, '0')
	return ctx.ok('')
}

@['/:path...'; lock]
pub fn (mut app App) lock(mut ctx Context, path string) veb.Result {
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
			return ctx.send_response_to_client('application/xml', existing_lock.xml())
		}
	}
	
	// Try to acquire the lock
	lock_result := app.lock_manager.lock(resource, lock_info.owner, depth, timeout) or {
		// If we get here, the resource is locked by a different owner
		ctx.res.set_status(.locked)
		return ctx.text('Resource is already locked by a different owner.')
	}
	ctx.res.set_status(.ok)
	ctx.set_custom_header('Lock-Token', '${lock_result.token}') or { return ctx.server_error(err.msg()) }
	
	// Create a proper WebDAV lock response
	return ctx.send_response_to_client('application/xml', lock_result.xml())
}

@['/:path...'; unlock]
pub fn (mut app App) unlock(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	token_ := ctx.get_custom_header('Lock-Token') or { return ctx.server_error(err.msg()) }
	token := token_.trim_string_left('<').trim_string_right('>')
	if token.len == 0 {
		console.print_stderr('Unlock failed: `Lock-Token` header required.')
		ctx.res.set_status(.bad_request)
		return ctx.text('Lock failed: `Owner` header missing.')
	}

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
	log.info('[WebDAV] Getting file ${path}')
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	fs_entry := app.vfs.get(path) or {
		log.error('[WebDAV] failed to get FS Entry ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	file_data := app.vfs.file_read(path) or { return ctx.server_error(err.msg()) }

	ext := fs_entry.get_metadata().name.all_after_last('.')
	content_type := veb.mime_types[ext] or { 'text/plain' }

	ctx.res.header.set(.content_length, file_data.len.str())
	ctx.res.set_status(.ok)
	return ctx.send_response_to_client(content_type, file_data.bytestr())
}

@[head]
pub fn (app &App) index(mut ctx Context) veb.Result {
	ctx.set_custom_header('DAV', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_custom_header('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.set_header(.access_control_allow_origin, '*')
	ctx.set_header(.access_control_allow_methods, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.set_header(.access_control_allow_headers, 'Authorization, Content-Type')
	ctx.set_header(.content_length, '0')
	return ctx.ok('')
}

@['/:path...'; head]
pub fn (mut app App) exists(mut ctx Context, path string) veb.Result {
	// Check if the requested path exists in the virtual filesystem
	if !app.vfs.exists(path) {
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
pub fn (mut app App) delete(mut ctx Context, path string) veb.Result {
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	fs_entry := app.vfs.get(path) or {
		console.print_stderr('failed to get FS Entry ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	// Check if the resource is locked
	if app.lock_manager.is_locked(ctx.req.url) {
		// Resource is locked, return a 207 Multi-Status response with a 423 Locked status
		ctx.res.set_status(.multi_status)
		return ctx.send_response_to_client('application/xml', $tmpl('./templates/delete_response.xml'))
	}

	// If not locked, proceed with deletion
	if fs_entry.is_dir() {
		console.print_debug('deleting directory: ${path}')
		app.vfs.dir_delete(path) or { return ctx.server_error(err.msg()) }
	}

	if fs_entry.is_file() {
		console.print_debug('deleting file: ${path}')
		app.vfs.file_delete(path) or { return ctx.server_error(err.msg()) }
	}

	// Return success response
	return ctx.no_content()
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
	log.info('[WebDAV] ${@FN} ${path}')

	// Check if resource exists
	if !app.vfs.exists(path) {
		return ctx.error(
			status: .not_found
			message: 'Path ${path} does not exist'
			tag: 'resource-must-be-null'
		)
	}
	
	// Parse PROPFIND request
	propfind_req := parse_propfind_xml(ctx.req) or {
		return ctx.error(WebDAVError{
			status: .bad_request
			message: 'Failed to parse PROPFIND XML: ${err}'
			tag: 'propfind-parse-error'
		})
	}

	log.debug('[WebDAV] ${@FN} Propfind Request: ${propfind_req.typ} ${propfind_req.depth}')

	
	// Check if resource is locked
	if app.lock_manager.is_locked(ctx.req.url) {
		// If the resource is locked, we should still return properties
		// but we might need to indicate the lock status in the response
		// This is handled in the property generation
		log.info('[WebDAV] Resource is locked: ${ctx.req.url}')
	}
	
	entry := app.vfs.get(path) or {return ctx.server_error('entry not found ${err}')}
	
	responses := app.get_responses(entry, propfind_req) or {
		return ctx.server_error('Failed to get entry properties ${err}')
	}

	// Create multistatus response using the responses
	ctx.res.set_status(.multi_status)
	return ctx.send_response_to_client('application/xml', responses.xml())
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
	} else {
		app.vfs.file_create(path) or { return ctx.server_error(err.msg()) }
	}
	if ctx.req.data.len > 0 {
		data := ctx.req.data.bytes()
		app.vfs.file_write(path, data) or { return ctx.server_error(err.msg()) }
		return ctx.ok('HTTP 200: Successfully wrote file: ${path}')
	}
	return ctx.ok('HTTP 200: Successfully created file: ${path}')
}
