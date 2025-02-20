module webdav

import freeflowuniverse.herolib.ui.console
import encoding.xml
import net.urllib
import veb

@['/:path...'; options]
pub fn (app &App) options(mut ctx Context, path string) veb.Result {
	ctx.res.set_status(.ok)
	ctx.res.header.add_custom('dav', '1,2') or {return ctx.server_error(err.msg())}
	ctx.res.header.add(.allow, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.res.header.add_custom('MS-Author-Via', 'DAV') or {return ctx.server_error(err.msg())}
	ctx.res.header.add(.access_control_allow_origin, '*')
	ctx.res.header.add(.access_control_allow_methods, 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
	ctx.res.header.add(.access_control_allow_headers, 'Authorization, Content-Type')
	return ctx.text('')
}

@['/:path...'; lock]
pub fn (mut app App) lock_handler(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	owner := ctx.get_custom_header('owner') or {return ctx.server_error(err.msg())}
	if owner.len == 0 {
		ctx.res.set_status(.bad_request)
		return ctx.text('Owner header is required.')
	}

	depth := ctx.get_custom_header('Depth') or { '0' }.int()
	timeout := ctx.get_custom_header('Timeout') or { '3600' }.int()
	token := app.lock_manager.lock(resource, owner, depth, timeout) or {
		ctx.res.set_status(.locked)
		return ctx.text('Resource is already locked.')
	}

	ctx.res.set_status(.ok)
	ctx.res.header.add_custom('Lock-Token', token) or {return ctx.server_error(err.msg())}
	return ctx.text('Lock granted with token: ${token}')
}

@['/:path...'; unlock]
pub fn (mut app App) unlock_handler(mut ctx Context, path string) veb.Result {
	resource := ctx.req.url
	token := ctx.get_custom_header('Lock-Token') or {return ctx.server_error(err.msg())}
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
	if !app.vfs.exists(path) {
		return ctx.not_found()
	}

	fs_entry := app.vfs.get(path) or {
		console.print_stderr('failed to get FS Entry ${path}: ${err}')
		return ctx.server_error(err.msg())
	}

	file_data := app.vfs.file_read(fs_entry.get_path()) or { return ctx.server_error(err.msg()) }

	ext := fs_entry.get_metadata().name.all_after_last('.')
	content_type := veb.mime_types[ext] or { 'text/plain' }

	ctx.res.set_status(.ok)
	return ctx.text(file_data.str())
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

	depth := ctx.req.header.get_custom('Depth') or {'0'}.int()

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
	// println('res: ${res}')

	ctx.res.set_status(.multi_status)
	return ctx.send_response_to_client('application/xml', res)
	// return veb.not_found()
}