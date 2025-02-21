module webdav

import encoding.base64

fn (app &App) auth_middleware(mut ctx Context) bool {
	// return true
	auth_header := ctx.get_header(.authorization) or {
		ctx.res.set_status(.unauthorized)
		ctx.res.header.add(.www_authenticate, 'Basic realm="WebDAV Server"')
		ctx.send_response_to_client('text', 'unauthorized')
		return false
	}

	if auth_header == '' {
		ctx.res.set_status(.unauthorized)
		ctx.res.header.add(.www_authenticate, 'Basic realm="WebDAV Server"')
		ctx.send_response_to_client('text', 'unauthorized')
		return false
	}

	if !auth_header.starts_with('Basic ') {
		ctx.res.set_status(.unauthorized)
		ctx.res.header.add(.www_authenticate, 'Basic realm="WebDAV Server"')
		ctx.send_response_to_client('text', 'unauthorized')
		return false
	}

	auth_decoded := base64.decode_str(auth_header[6..])
	split_credentials := auth_decoded.split(':')
	if split_credentials.len != 2 {
		ctx.res.set_status(.unauthorized)
		ctx.res.header.add(.www_authenticate, 'Basic realm="WebDAV Server"')
		ctx.send_response_to_client('', '')
		return false
	}
	username := split_credentials[0]
	hashed_pass := split_credentials[1]
	if user := app.user_db[username] {
		if user != hashed_pass {
			ctx.res.set_status(.unauthorized)
			ctx.send_response_to_client('text', 'unauthorized')
			return false
		}
		println('Successfully authenticated user. ${ctx.req}')
		return true
	}
	ctx.res.set_status(.unauthorized)
	ctx.send_response_to_client('text', 'unauthorized')
	return false
}
