module webdav

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.ui.console
import encoding.xml
import net.urllib
import os
import vweb

@['/:path...'; get]
fn (mut app App) get_file(path string) vweb.Result {
	if !app.vfs.exists(path) {
		return app.not_found()
	}

	fs_entry := app.vfs.get(path) or {
		console.print_stderr('failed to get FS Entry ${path}: ${err}')
		return app.server_error()
	}

	file_data := app.vfs.file_read(fs_entry.get_path()) or { return app.server_error() }

	ext := fs_entry.get_metadata().name.all_after_last('.')
	content_type := if v := vweb.mime_types[ext] {
		v
	} else {
		'text/plain'
	}

	app.set_status(200, 'Ok')
	app.send_response_to_client(content_type, file_data.str())
	return vweb.not_found() // this is for returning a dummy result
}
