module webdav

// import vweb
// import os
// import freeflowuniverse.herolib.core.pathlib
// import encoding.xml
// import freeflowuniverse.herolib.ui.console
// import net.urllib

// // @['/:path...'; LOCK]
// // fn (mut app App) lock_handler(path string) vweb.Result {
// // 	// Not yet working
// // 	// TODO: Test with multiple clients
// // 	resource := app.req.url
// // 	owner := app.get_header('Owner')
// // 	if owner.len == 0 {
// // 		return app.bad_request('Owner header is required.')
// // 	}

// // 	depth := if app.get_header('Depth').len > 0 { app.get_header('Depth').int() } else { 0 }
// // 	timeout := if app.get_header('Timeout').len > 0 { app.get_header('Timeout').int() } else { 3600 }

// // 	token := app.lock_manager.lock(resource, owner, depth, timeout) or {
// // 		app.set_status(423, 'Locked')
// // 		return app.text('Resource is already locked.')
// // 	}

// // 	app.set_status(200, 'OK')
// // 	app.add_header('Lock-Token', token)
// // 	return app.text('Lock granted with token: ${token}')
// // }

// // @['/:path...'; UNLOCK]
// // fn (mut app App) unlock_handler(path string) vweb.Result {
// // 	// Not yet working
// // 	// TODO: Test with multiple clients
// // 	resource := app.req.url
// // 	token := app.get_header('Lock-Token')
// // 	if token.len == 0 {
// // 		console.print_stderr('Unlock failed: `Lock-Token` header required.')
// // 		return app.bad_request('Unlock failed: `Lock-Token` header required.')
// // 	}

// // 	if app.lock_manager.unlock_with_token(resource, token) {
// // 		app.set_status(204, 'No Content')
// // 		return app.text('Lock successfully released')
// // 	}

// // 	console.print_stderr('Resource is not locked or token mismatch.')
// // 	app.set_status(409, 'Conflict')
// // 	return app.text('Resource is not locked or token mismatch')
// // }

// @['/:path...'; get]
// fn (mut app App) get_file(path string) vweb.Result {
// 	mut file_path := pathlib.get_file(path: app.root_dir.path + path) or { return app.not_found() }
// 	if !file_path.exists() {
// 		return app.not_found()
// 	}

// 	file_data := file_path.read() or {
// 		console.print_stderr('failed to read file ${file_path.path}: ${err}')
// 		return app.server_error()
// 	}

// 	ext := os.file_ext(file_path.path)
// 	content_type := if v := vweb.mime_types[ext] {
// 		v
// 	} else {
// 		'text/plain'
// 	}

// 	app.set_status(200, 'Ok')
// 	app.send_response_to_client(content_type, file_data)

// 	return vweb.not_found() // this is for returning a dummy result
// }

// @['/:path...'; delete]
// fn (mut app App) delete(path string) vweb.Result {
// 	mut p := pathlib.get(app.root_dir.path + path)
// 	if !p.exists() {
// 		return app.not_found()
// 	}

// 	if p.is_dir() {
// 		console.print_debug('deleting directory: ${p.path}')
// 		os.rmdir_all(p.path) or { return app.server_error() }
// 	}

// 	if p.is_file() {
// 		console.print_debug('deleting file: ${p.path}')
// 		os.rm(p.path) or { return app.server_error() }
// 	}

// 	console.print_debug('entry: ${p.path} is deleted')
// 	app.set_status(204, 'No Content')

// 	return app.text('entry ${p.path} is deleted')
// }

// @['/:path...'; put]
// fn (mut app App) create_or_update(path string) vweb.Result {
// 	mut p := pathlib.get(app.root_dir.path + path)

// 	if p.is_dir() {
// 		console.print_stderr('Cannot PUT to a directory: ${p.path}')
// 		app.set_status(405, 'Method Not Allowed')
// 		return app.text('HTTP 405: Method Not Allowed')
// 	}

// 	file_data := app.req.data
// 	p = pathlib.get_file(path: p.path, create: true) or {
// 		console.print_stderr('failed to get file ${p.path}: ${err}')
// 		return app.server_error()
// 	}

// 	p.write(file_data) or {
// 		console.print_stderr('failed to write file data ${p.path}: ${err}')
// 		return app.server_error()
// 	}

// 	app.set_status(200, 'Successfully saved file: ${p.path}')
// 	return app.text('HTTP 200: Successfully saved file: ${p.path}')
// }

// @['/:path...'; copy]
// fn (mut app App) copy(path string) vweb.Result {
// 	mut p := pathlib.get(app.root_dir.path + path)
// 	if !p.exists() {
// 		return app.not_found()
// 	}

// 	destination := app.get_header('Destination')
// 	destination_url := urllib.parse(destination) or {
// 		return app.bad_request('Invalid Destination ${destination}: ${err}')
// 	}
// 	destination_path_str := destination_url.path

// 	mut destination_path := pathlib.get(app.root_dir.path + destination_path_str)
// 	if destination_path.exists() {
// 		return app.bad_request('Destination ${destination_path.path} already exists')
// 	}

// 	os.cp_all(p.path, destination_path.path, false) or {
// 		console.print_stderr('failed to copy: ${err}')
// 		return app.server_error()
// 	}

// 	app.set_status(200, 'Successfully copied entry: ${p.path}')
// 	return app.text('HTTP 200: Successfully copied entry: ${p.path}')
// }

// @['/:path...'; move]
// fn (mut app App) move(path string) vweb.Result {
// 	mut p := pathlib.get(app.root_dir.path + path)
// 	if !p.exists() {
// 		return app.not_found()
// 	}

// 	destination := app.get_header('Destination')
// 	destination_url := urllib.parse(destination) or {
// 		return app.bad_request('Invalid Destination ${destination}: ${err}')
// 	}
// 	destination_path_str := destination_url.path

// 	mut destination_path := pathlib.get(app.root_dir.path + destination_path_str)
// 	if destination_path.exists() {
// 		return app.bad_request('Destination ${destination_path.path} already exists')
// 	}

// 	os.mv(p.path, destination_path.path) or {
// 		console.print_stderr('failed to copy: ${err}')
// 		return app.server_error()
// 	}

// 	app.set_status(200, 'Successfully moved entry: ${p.path}')
// 	return app.text('HTTP 200: Successfully moved entry: ${p.path}')
// }

// @['/:path...'; mkcol]
// fn (mut app App) mkcol(path string) vweb.Result {
// 	mut p := pathlib.get(app.root_dir.path + path)
// 	if p.exists() {
// 		return app.bad_request('Another collection exists at ${p.path}')
// 	}

// 	p = pathlib.get_dir(path: p.path, create: true) or {
// 		console.print_stderr('failed to create directory ${p.path}: ${err}')
// 		return app.server_error()
// 	}

// 	app.set_status(201, 'Created')
// 	return app.text('HTTP 201: Created')
// }

// @['/:path...'; options]
// fn (mut app App) options(path string) vweb.Result {
// 	app.set_status(200, 'OK')
// 	app.add_header('DAV', '1,2')
// 	app.add_header('Allow', 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
// 	app.add_header('MS-Author-Via', 'DAV')
// 	app.add_header('Access-Control-Allow-Origin', '*')
// 	app.add_header('Access-Control-Allow-Methods', 'OPTIONS, PROPFIND, MKCOL, GET, HEAD, POST, PUT, DELETE, COPY, MOVE')
// 	app.add_header('Access-Control-Allow-Headers', 'Authorization, Content-Type')
// 	app.send_response_to_client('text/plain', '')
// 	return vweb.not_found()
// }

// @['/:path...'; propfind]
// fn (mut app App) propfind(path string) vweb.Result {
// 	mut p := pathlib.get(app.root_dir.path + path)
// 	if !p.exists() {
// 		return app.not_found()
// 	}

// 	depth := app.get_header('Depth').int()

// 	responses := app.get_responses(p.path, depth) or {
// 		console.print_stderr('failed to get responses: ${err}')
// 		return app.server_error()
// 	}

// 	doc := xml.XMLDocument{
// 		root: xml.XMLNode{
// 			name:       'D:multistatus'
// 			children:   responses
// 			attributes: {
// 				'xmlns:D': 'DAV:'
// 			}
// 		}
// 	}

// 	res := '<?xml version="1.0" encoding="UTF-8"?>${doc.pretty_str('').split('\n')[1..].join('')}'
// 	// println('res: ${res}')

// 	app.set_status(207, 'Multi-Status')
// 	app.send_response_to_client('application/xml', res)
// 	return vweb.not_found()
// }

// fn (mut app App) generate_element(element string, space_cnt int) string {
// 	mut spaces := ''
// 	for i := 0; i < space_cnt; i++ {
// 		spaces += ' '
// 	}

// 	return '${spaces}<${element}>\n'
// }

// // TODO: implement
// // @['/'; proppatch]
// // fn (mut app App) prop_patch() vweb.Result {
// // }

// // TODO: implement, now it's used with PUT
// // @['/'; post]
// // fn (mut app App) post() vweb.Result {
// // }
