module heroprompt

import veb
import os

// Public Context type for veb
pub struct Context {
	veb.Context
}

// Factory args for starting the server
@[params]
pub struct FactoryArgs {
pub mut:
	host  string = 'localhost'
	port  int    = 8090
	title string = 'Heroprompt'
}

// App holds server state and config
pub struct App {
	veb.StaticHandler
pub mut:
	title     string
	port      int
	base_path string // absolute path to this module directory
}

// Create a new App instance (does not start the server)
pub fn new(args FactoryArgs) !&App {
	base := os.dir(@FILE)
	mut app := App{
		title: args.title
		port: args.port
		base_path: base
	}
	// Serve static assets from this module at /static
	app.mount_static_folder_at(os.join_path(base, 'static'), '/static')!
	return &app
}

// Start the webserver (blocking)
pub fn start(args FactoryArgs) ! {
	mut app := new(args)!
	veb.run[App, Context](mut app, app.port)
}

// Routes

@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	return ctx.html(render_index(app))
}

// Rendering helpers
fn render_index(app &App) string {
	tpl := os.join_path(app.base_path, 'templates', 'index.html')
	content := os.read_file(tpl) or { return render_index_fallback(app) }
	return render_template(content, {
		'title': app.title
	})
}

fn render_index_fallback(app &App) string {
	return '<!doctype html>\n<html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>'
		+ html_escape(app.title)
		+ '</title><link rel="stylesheet" href="/static/css/main.css"></head><body><div class="container"><h1>'
		+ html_escape(app.title)
		+ '</h1><p>Heroprompt server is running.</p></div><script src="/static/js/main.js"></script></body></html>'
}

