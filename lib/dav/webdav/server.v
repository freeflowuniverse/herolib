module webdav

import time
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.ui.console
import encoding.xml
import net.urllib
import net
import net.http.chunked
import veb
import log
import strings

@[head]
pub fn (server &Server) index(mut ctx Context) veb.Result {
	ctx.set_header(.content_length, '0')
	ctx.set_custom_header('DAV', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Allow', 'OPTIONS, HEAD, GET, PROPFIND, DELETE, COPY, MOVE, PROPPATCH, LOCK, UNLOCK') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'WsgiDAV-compatible WebDAV Server') or { return ctx.server_error(err.msg()) }
	return ctx.ok('')
}

@['/:path...'; options]
pub fn (server &Server) options(mut ctx Context, path string) veb.Result {
	ctx.set_header(.content_length, '0')
	ctx.set_custom_header('DAV', '1,2') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Allow', 'OPTIONS, HEAD, GET, PROPFIND, DELETE, COPY, MOVE, PROPPATCH, LOCK, UNLOCK') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('MS-Author-Via', 'DAV') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'WsgiDAV-compatible WebDAV Server') or { return ctx.server_error(err.msg()) }
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

	// Set WsgiDAV-like headers
	ctx.res.set_status(.ok)
	ctx.set_custom_header('Lock-Token', 'opaquelocktoken:${lock_result.token}') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }
	
	// Create a proper WebDAV lock response
	return ctx.send_response_to_client('application/xml', lock_result.xml())
}

@['/:path...'; unlock]
pub fn (mut server Server) unlock(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	token_ := ctx.get_custom_header('Lock-Token') or { return ctx.server_error(err.msg()) }
	// Handle the opaquelocktoken: prefix that WsgiDAV uses
	token := token_.trim_string_left('<').trim_string_right('>')
	                .trim_string_left('opaquelocktoken:')
	if token.len == 0 {
		console.print_stderr('Unlock failed: `Lock-Token` header required.')
		ctx.res.set_status(.bad_request)
		return ctx.text('Lock failed: `Lock-Token` header missing or invalid.')
	}

	if server.lock_manager.unlock_with_token(resource, token) {
		// Add WsgiDAV-like headers
		ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
		ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }
		ctx.res.set_status(.no_content)
		return ctx.text('')
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
	content_type := veb.mime_types['.${ext}'] or { 'text/plain; charset=utf-8' }
	
	// Add WsgiDAV-like headers
	ctx.set_header(.content_length, file_data.len.str())
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_header(.accept_ranges, 'bytes') 
	ctx.set_custom_header('ETag', '"${path}-${time.now().unix()}"') or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Last-Modified', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	
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
	// ctx.set_header(.content_type, 'application/xml') // XML is common for WebDAV metadata
	ctx.set_custom_header('Allow', 'OPTIONS, GET, HEAD, PROPFIND, PROPPATCH, MKCOL, PUT, DELETE, COPY, MOVE, LOCK, UNLOCK') or {
		return ctx.server_error('Failed to set Allow header: ${err}')
	}
	ctx.set_header(.accept_ranges, 'bytes') // Allows range-based file downloads
	ctx.set_custom_header('Cache-Control', 'no-cache, no-store, must-revalidate') or {
		return ctx.server_error('Failed to set Cache-Control header: ${err}')
	}
	ctx.set_custom_header('Last-Modified', texttools.format_rfc1123(time.utc())) or {
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
	
	// Add WsgiDAV-like headers
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }
	
	server.vfs.print() or {panic(err)}
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

	// Check if destination exists
	destination_exists := server.vfs.exists(destination_path_str)

	server.vfs.copy(path, destination_path_str) or {
		log.error('[WebDAV] Failed to copy: ${err}')
		return ctx.server_error(err.msg())
	}

	// Add WsgiDAV-like headers
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }
	
	// Return 201 Created if the destination was created, 204 No Content if it was overwritten
	if destination_exists {
		return ctx.no_content()
	} else {
		ctx.res.set_status(.created)
		return ctx.text('')
	}
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

	// Check if destination exists
	destination_exists := server.vfs.exists(destination_path_str)

	log.info('[WebDAV] ${@FN} from ${path} to ${destination_path_str}')
	server.vfs.move(path, destination_path_str) or {
		log.error('Failed to move: ${err}')
		return ctx.server_error(err.msg())
	}

	// Add WsgiDAV-like headers
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }
	
	// Return 204 No Content for successful move operations (WsgiDAV behavior)
	ctx.res.set_status(.no_content)
	return ctx.text('')
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

	// Add WsgiDAV-like headers
	ctx.set_header(.content_type, 'text/html; charset=utf-8')
	ctx.set_header(.content_length, '0')
	ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
	ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }

	ctx.res.set_status(.created)
	return ctx.text('')
}

@['/:path...'; put]
fn (mut server Server) create_or_update(mut ctx Context, path string) veb.Result {
	// Check if parent directory exists (RFC 4918 9.7.1: A PUT that would result in the creation of a resource
	// without an appropriately scoped parent collection MUST fail with a 409 Conflict)
	parent_path := path.all_before_last('/')
	if parent_path != '' && !server.vfs.exists(parent_path) {
		log.error('[WebDAV] Parent directory ${parent_path} does not exist for ${path}')
		ctx.res.set_status(.conflict)
		return ctx.text('HTTP 409: Conflict - Parent collection does not exist')
	}

	is_update := server.vfs.exists(path)
	if is_update {
		log.debug('[WebDAV] ${path} exists, updating')
		if fs_entry := server.vfs.get(path) {
			log.debug('[WebDAV] Got FSEntry ${fs_entry}')
			// RFC 4918 9.7.2: PUT for Collections - A PUT request to an existing collection MAY be treated as an error
			if fs_entry.is_dir() {
				log.error('[WebDAV] Cannot PUT to a directory: ${path}')
				ctx.res.set_status(.method_not_allowed)
				ctx.set_header(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, DELETE')
				return ctx.text('HTTP 405: Method Not Allowed - Cannot PUT to a collection')
			}
		} else {
			log.error('[WebDAV] Failed to get FS Entry for ${path}\n${err.msg()}')
			return ctx.server_error('Failed to get FS Entry ${path}: ${err.msg()}')
		}
	} else {
		log.debug('[WebDAV] ${path} does not exist, creating')
		server.vfs.file_create(path) or {
			log.error('[WebDAV] Failed to create file ${path}: ${err.msg()}')
			return ctx.server_error('Failed to create file: ${err.msg()}')
		}
	}

	// Process Content-Type if provided
	content_type := ctx.req.header.get(.content_type) or { '' }
	if content_type != '' {
		log.debug('[WebDAV] Content-Type provided: ${content_type}')
	}

	// Check if we have a Content-Length header
	content_length_str := ctx.req.header.get(.content_length) or { '0' }
	content_length := content_length_str.int()
	log.debug('[WebDAV] Content-Length: ${content_length}')

	// Check for chunked transfer encoding
	transfer_encoding := ctx.req.header.get_custom('Transfer-Encoding') or { '' }
	is_chunked := transfer_encoding.to_lower().contains('chunked')
	log.debug('[WebDAV] Transfer-Encoding: ${transfer_encoding}, is_chunked: ${is_chunked}')

	// Handle the file upload based on the request type
	if is_chunked || content_length > 0 {
		// Take over the connection to handle streaming data
		ctx.takeover_conn()

		// Create a buffer for reading chunks
		mut buffer := []u8{len: 8200} // 8KB buffer for reading chunks
		mut total_bytes := 0
		mut all_data := []u8{}

		// Process any data that's already been read
		if ctx.req.data.len > 0 {
			all_data << ctx.req.data.bytes()
			total_bytes += ctx.req.data.len
			log.debug('[WebDAV] Added ${ctx.req.data.len} initial bytes from request data')
		}

		// Read data in chunks from the connection
		if is_chunked {
			// For chunked encoding, we need to read until we get a zero-length chunk
			log.info('[WebDAV] Reading chunked data for ${path}')
			
			// Write initial data to the file
			if all_data.len > 0 {
				server.vfs.file_write(path, all_data) or {
					log.error('[WebDAV] Failed to write initial data to ${path}: ${err.msg()}')
					// Send error response
					ctx.res.set_status(.internal_server_error)
					ctx.res.header.set(.content_type, 'text/plain')
					ctx.res.header.set(.content_length, '${err.msg().len}')
					ctx.conn.write(ctx.res.bytestr().bytes()) or {}
					ctx.conn.write(err.msg().bytes()) or {}
					ctx.conn.close() or {}
					return veb.no_result()
				}
			}

			// Continue reading chunks from the connection
			for {
				// Read a chunk from the connection
				n := ctx.conn.read(mut buffer) or {
					if err.code() == net.err_timed_out_code {
						log.info('[WebDAV] Connection timed out, finished reading')
						break
					}
					log.error('[WebDAV] Error reading from connection: ${err}')
					break
				}

				if n <= 0 {
					log.info('[WebDAV] Reached end of data stream')
					break
				}


				// Process the chunk using the chunked module
				chunk := buffer[..n].clone()
				chunk_str := chunk.bytestr()
				
				// Try to decode the chunk if it looks like a valid chunked format
				if chunk_str.contains('\r\n') {
					log.debug('[WebDAV] Attempting to decode chunked data')
					decoded := chunked.decode(chunk_str) or {
						log.error('[WebDAV] Failed to decode chunked data: ${err}')
						// If decoding fails, just use the raw chunk
						server.vfs.file_concatenate(path, chunk) or {
							log.error('[WebDAV] Failed to append chunk to ${path}: ${err.msg()}')
							// Send error response
							ctx.res.set_status(.internal_server_error)
							ctx.res.header.set(.content_type, 'text/plain')
							ctx.res.header.set(.content_length, '${err.msg().len}')
							ctx.conn.write(ctx.res.bytestr().bytes()) or {}
							ctx.conn.write(err.msg().bytes()) or {}
							ctx.conn.close() or {}
							return veb.no_result()
						}
					}
					
					// If decoding succeeds, write the decoded data
					if decoded.len > 0 {
						log.debug('[WebDAV] Successfully decoded chunked data: ${decoded.len} bytes')
						server.vfs.file_concatenate(path, decoded.bytes()) or {
							log.error('[WebDAV] Failed to append decoded chunk to ${path}: ${err.msg()}')
							// Send error response
							ctx.res.set_status(.internal_server_error)
							ctx.res.header.set(.content_type, 'text/plain')
							ctx.res.header.set(.content_length, '${err.msg().len}')
							ctx.conn.write(ctx.res.bytestr().bytes()) or {}
							ctx.conn.write(err.msg().bytes()) or {}
							ctx.conn.close() or {}
							return veb.no_result()
						}
					}
				} else {
					// If it doesn't look like chunked data, use the raw chunk
					server.vfs.file_concatenate(path, chunk) or {
						log.error('[WebDAV] Failed to append chunk to ${path}: ${err.msg()}')
						// Send error response
						ctx.res.set_status(.internal_server_error)
						ctx.res.header.set(.content_type, 'text/plain')
						ctx.res.header.set(.content_length, '${err.msg().len}')
						ctx.conn.write(ctx.res.bytestr().bytes()) or {}
						ctx.conn.write(err.msg().bytes()) or {}
						ctx.conn.close() or {}
						return veb.no_result()
					}
				}

				total_bytes += n
				log.debug('[WebDAV] Read ${n} bytes, total: ${total_bytes}')
			}
		} else if content_length > 0 {
			// For Content-Length uploads, read exactly that many bytes
			log.info('[WebDAV] Reading ${content_length} bytes for ${path}')
			mut remaining := content_length - all_data.len

			// Write initial data to the file
			if all_data.len > 0 {
				server.vfs.file_write(path, all_data) or {
					log.error('[WebDAV] Failed to write initial data to ${path}: ${err.msg()}')
					// Send error response
					ctx.res.set_status(.internal_server_error)
					ctx.res.header.set(.content_type, 'text/plain')
					ctx.res.header.set(.content_length, '${err.msg().len}')
					ctx.conn.write(ctx.res.bytestr().bytes()) or {}
					ctx.conn.write(err.msg().bytes()) or {}
					ctx.conn.close() or {}
					return veb.no_result()
				}
			}

			// Continue reading until we've read all the content
			for remaining > 0 {
				// Adjust buffer size for the last chunk if needed
				read_size := if remaining < buffer.len { remaining } else { buffer.len }
				
				// Read a chunk from the connection
				n := ctx.conn.read(mut buffer[..read_size]) or {
					if err.code() == net.err_timed_out_code {
						log.info('[WebDAV] Connection timed out, finished reading')
						break
					}
					log.error('[WebDAV] Error reading from connection: ${err}')
					break
				}

				if n <= 0 {
					log.info('[WebDAV] Reached end of data stream')
					break
				}

				// Append the chunk to our file
				chunk := buffer[..n].clone()
				server.vfs.file_concatenate(path, chunk) or {
					log.error('[WebDAV] Failed to append chunk to ${path}: ${err.msg()}')
					// Send error response
					ctx.res.set_status(.internal_server_error)
					ctx.res.header.set(.content_type, 'text/plain')
					ctx.res.header.set(.content_length, '${err.msg().len}')
					ctx.conn.write(ctx.res.bytestr().bytes()) or {}
					ctx.conn.write(err.msg().bytes()) or {}
					return veb.no_result()
				}

				total_bytes += n
				remaining -= n
				log.debug('[WebDAV] Read ${n} bytes, remaining: ${remaining}')
			}
		}

		log.info('[WebDAV] Successfully wrote ${total_bytes} bytes to ${path}')

		// Send success response
		ctx.res.header.set(.content_type, 'text/html; charset=utf-8')
		ctx.res.header.set(.content_length, '0')
		ctx.res.header.set_custom('Date', texttools.format_rfc1123(time.utc())) or {}
		ctx.res.header.set_custom('Server', 'veb WebDAV Server') or {}

		if is_update {
			ctx.res.set_status(.no_content) // 204 No Content
		} else {
			ctx.res.set_status(.created) // 201 Created
		}

		ctx.conn.write(ctx.res.bytestr().bytes()) or {
			log.error('[WebDAV] Failed to write response: ${err}')
		}
		ctx.conn.close() or {}

		return veb.no_result()
	} else {
		// Empty PUT is still valid (creates empty file or replaces with empty content)
		server.vfs.file_write(path, []u8{}) or {
			log.error('[WebDAV] Failed to write empty data to ${path}: ${err.msg()}')
			return ctx.server_error('Failed to write file: ${err.msg()}')
		}
		log.info('[WebDAV] Created empty file at ${path}')
		
		// Add WsgiDAV-like headers
		ctx.set_header(.content_type, 'text/html; charset=utf-8')
		ctx.set_header(.content_length, '0')
		ctx.set_custom_header('Date', texttools.format_rfc1123(time.utc())) or { return ctx.server_error(err.msg()) }
		ctx.set_custom_header('Server', 'veb WebDAV Server') or { return ctx.server_error(err.msg()) }
		
		// Set appropriate status code based on whether this was a create or update
		if is_update {
			return ctx.no_content()
		} else {
			ctx.res.set_status(.created)
			return ctx.text('')
		}
	}
}
