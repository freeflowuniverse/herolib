module webdav

import veb
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.vfs

@[heap]
pub struct App {
	veb.Middleware[Context]
pub mut:
	lock_manager LockManager
	user_db      map[string]string @[required]
	vfs          vfs.VFSImplementation
}

pub struct Context {
	veb.Context
}

@[params]
pub struct AppArgs {
pub mut:
	user_db map[string]string @[required]
	vfs     vfs.VFSImplementation
}

pub fn new_app(args AppArgs) !&App {
	mut app := &App{
		user_db: args.user_db.clone()
		vfs:     args.vfs
	}

	// register middlewares for all routes
	app.use(handler: app.auth_middleware)
	app.use(handler: middleware_log_request)
	app.use(handler: middleware_log_response, after: true)
	return app
}

@[params]
pub struct RunParams {
pub mut:
	port       int = 8088
	background bool
}

pub fn (mut app App) run(params RunParams) {
	console.print_green('Running the server on port: ${params.port}')
	if params.background {
		spawn veb.run[App, Context](mut app, params.port)
	} else {
		veb.run[App, Context](mut app, params.port)
	}
}
