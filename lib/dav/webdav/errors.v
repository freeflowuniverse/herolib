module webdav

import net.http
import veb
import log

struct WebDAVError {
pub:
	status  http.Status
	message string
	tag     string
}

pub fn (mut ctx Context) error(err WebDAVError) veb.Result {
	message := if err.message != '' {
		err.message
	} else {
		err.status.str().replace('_', ' ').title()
	}
	log.error('[WebDAV] ${message}')
	ctx.res.set_status(err.status)
	return ctx.send_response_to_client('application/xml', $tmpl('./templates/error_response.xml'))
}
