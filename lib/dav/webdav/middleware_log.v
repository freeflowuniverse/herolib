module webdav

import freeflowuniverse.herolib.ui.console
import log

fn middleware_log_request(mut ctx Context) bool {
	log.debug('[WebDAV] New Request: Method: ${ctx.req.method.str()} Path: ${ctx.req.url}')
	log.debug('[WebDAV] New Request: Method: ${ctx.req.method.str()} Path: ${ctx.req.url}')
	return true
}

fn middleware_log_response(mut ctx Context) bool {
	log.debug('[WebDAV] Response: Method: ${ctx.req.method.str()} Path: ${ctx.req.url}')
	log.debug('[WebDAV] Response: ${ctx.res}')
	return true
}
 