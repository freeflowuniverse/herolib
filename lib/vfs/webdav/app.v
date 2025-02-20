module webdav

import veb
import freeflowuniverse.herolib.ui.console
import freeflowuniverse.herolib.vfs.vfscore

pub struct App {
	veb.Middleware[Context]
	server_port  int
pub mut:
	lock_manager LockManager
	user_db 	 map[string]string @[required]
	vfs          vfscore.VFSImplementation @[veb_global]
}
	
pub struct Context {
	veb.Context
}

@[params]
pub struct AppArgs {
pub mut:
	user_db     map[string]string @[required]
	vfs         vfscore.VFSImplementation
}

pub fn new_app(args AppArgs) !&App {
	mut app := &App{
		user_db:     args.user_db.clone()
		vfs:         args.vfs
	}

    // register middlewares for all routes
    app.use(handler: logging_middleware)
    app.use(handler: unsafe{app.auth_middleware})

	return app
}


@[params]
pub struct RunParams {
pub mut:
	port int = 8088
	background bool
}

pub fn (mut app App) run(params RunParams) {
	console.print_green('Running the server on port: ${app.server_port}')
	if params.background {
		spawn veb.run[App, Context](mut app, params.port)
	} else {
		veb.run[App, Context](mut app, params.port)
	}
}