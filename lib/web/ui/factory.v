module ui

import veb
import os


// Public Context type for veb
pub struct Context {
	veb.Context
}

// Simple tree menu structure
pub struct MenuItem {
pub:
	title    string
	href     string
	children []MenuItem
}

// Factory args
@[params]
pub struct WebArgs {
pub mut:
	name  string = 'default'
	host  string = 'localhost'
	port  int    = 8080
	title string = 'Admin'
	menu  []MenuItem
	open  bool
}

// The App holds server state and config
pub struct App {
	veb.StaticHandler
pub mut:
	title string = "default"
	menu  []MenuItem
	port  int = 7711
}


// Start the webserver (blocking)
pub fn start(args WebArgs) !{
	mut app := App{
		title: args.title,
		menu: args.menu,
		port: args.port
	}
	veb.run[App, Context](mut app, app.port)!
}

// Routes

// Redirect root to /admin
@['/'; get]
pub fn (app &App) root(mut ctx Context) veb.Result {
	return ctx.redirect('/admin')
}

// Admin home page
@['/admin'; get]
pub fn (app &App) admin_index(mut ctx Context) veb.Result {
	return ctx.html(app.render_admin('/', 'Welcome'))
}

// HeroScript editor page
@['/admin/heroscript'; get]
pub fn (app &App) admin_heroscript(mut ctx Context) veb.Result {
	return ctx.html(app.render_heroscript())
}

// Chat page
@['/admin/chat'; get]
pub fn (app &App) admin_chat(mut ctx Context) veb.Result {
	return ctx.html(app.render_chat())
}

// Static CSS files
@['/static/css/colors.css'; get]
pub fn (app &App) serve_colors_css(mut ctx Context) veb.Result {
	css_path := os.join_path(os.dir(@FILE), 'templates', 'css', 'colors.css')
	css_content := os.read_file(css_path) or { return ctx.text('/* CSS file not found */') }
	ctx.set_content_type('text/css')
	return ctx.text(css_content)
}

@['/static/css/main.css'; get]
pub fn (app &App) serve_main_css(mut ctx Context) veb.Result {
	css_path := os.join_path(os.dir(@FILE), 'templates', 'css', 'main.css')
	css_content := os.read_file(css_path) or { return ctx.text('/* CSS file not found */') }
	ctx.set_content_type('text/css')
	return ctx.text(css_content)
}

// Static JS files
@['/static/js/theme.js'; get]
pub fn (app &App) serve_theme_js(mut ctx Context) veb.Result {
	js_path := os.join_path(os.dir(@FILE), 'templates', 'js', 'theme.js')
	js_content := os.read_file(js_path) or { return ctx.text('/* JS file not found */') }
	ctx.set_content_type('application/javascript')
	return ctx.text(js_content)
}

@['/static/js/heroscript.js'; get]
pub fn (app &App) serve_heroscript_js(mut ctx Context) veb.Result {
	js_path := os.join_path(os.dir(@FILE), 'templates', 'js', 'heroscript.js')
	js_content := os.read_file(js_path) or { return ctx.text('/* JS file not found */') }
	ctx.set_content_type('application/javascript')
	return ctx.text(js_content)
}

@['/static/js/chat.js'; get]
pub fn (app &App) serve_chat_js(mut ctx Context) veb.Result {
	js_path := os.join_path(os.dir(@FILE), 'templates', 'js', 'chat.js')
	js_content := os.read_file(js_path) or { return ctx.text('/* JS file not found */') }
	ctx.set_content_type('application/javascript')
	return ctx.text(js_content)
}

@['/static/css/heroscript.css'; get]
pub fn (app &App) serve_heroscript_css(mut ctx Context) veb.Result {
	css_path := os.join_path(os.dir(@FILE), 'templates', 'css', 'heroscript.css')
	css_content := os.read_file(css_path) or { return ctx.text('/* CSS file not found */') }
	ctx.set_content_type('text/css')
	return ctx.text(css_content)
}

@['/static/css/chat.css'; get]
pub fn (app &App) serve_chat_css(mut ctx Context) veb.Result {
	css_path := os.join_path(os.dir(@FILE), 'templates', 'css', 'chat.css')
	css_content := os.read_file(css_path) or { return ctx.text('/* CSS file not found */') }
	ctx.set_content_type('text/css')
	return ctx.text(css_content)
}

// Catch-all content under /admin/*
@['/admin/:path...'; get]
pub fn (app &App) admin_section(mut ctx Context, path string) veb.Result {
	// Render current path in the main content
	return ctx.html(app.render_admin(path, 'Content'))
}

// View rendering using external template

fn (app &App) render_admin(path string, heading string) string {
	// Get the template file path relative to the module
	template_path := os.join_path(os.dir(@FILE), 'templates', 'admin_layout.html')

	// Read the template file
	template_content := os.read_file(template_path) or {
		// Fallback to inline template if file not found
		return app.render_admin_fallback(path, heading)
	}

	// Generate menu HTML
	menu_content := menu_html(app.menu, 0, 'm')

	// Simple template variable replacement
	mut result := template_content
	result = result.replace('{{.title}}', app.title)
	result = result.replace('{{.heading}}', heading)
	result = result.replace('{{.path}}', path)
	result = result.replace('{{.menu_html}}', menu_content)
	result = result.replace('{{.css_colors_url}}', '/static/css/colors.css')
	result = result.replace('{{.css_main_url}}', '/static/css/main.css')
	result = result.replace('{{.js_theme_url}}', '/static/js/theme.js')

	return result
}

// HeroScript editor rendering using external template
fn (app &App) render_heroscript() string {
	// Get the template file path relative to the module
	template_path := os.join_path(os.dir(@FILE), 'templates', 'heroscript_editor.html')

	// Read the template file
	template_content := os.read_file(template_path) or {
		// Fallback to basic template if file not found
		return app.render_heroscript_fallback()
	}

	// Generate menu HTML
	menu_content := menu_html(app.menu, 0, 'm')

	// Simple template variable replacement
	mut result := template_content
	result = result.replace('{{.title}}', app.title)
	result = result.replace('{{.menu_html}}', menu_content)
	result = result.replace('{{.css_colors_url}}', '/static/css/colors.css')
	result = result.replace('{{.css_main_url}}', '/static/css/main.css')
	result = result.replace('{{.css_heroscript_url}}', '/static/css/heroscript.css')
	result = result.replace('{{.js_theme_url}}', '/static/js/theme.js')
	result = result.replace('{{.js_heroscript_url}}', '/static/js/heroscript.js')

	return result
}

// Chat rendering using external template
fn (app &App) render_chat() string {
	// Get the template file path relative to the module
	template_path := os.join_path(os.dir(@FILE), 'templates', 'chat.html')

	// Read the template file
	template_content := os.read_file(template_path) or {
		// Fallback to basic template if file not found
		return app.render_chat_fallback()
	}

	// Generate menu HTML
	menu_content := menu_html(app.menu, 0, 'm')

	// Simple template variable replacement
	mut result := template_content
	result = result.replace('{{.title}}', app.title)
	result = result.replace('{{.menu_html}}', menu_content)
	result = result.replace('{{.css_colors_url}}', '/static/css/colors.css')
	result = result.replace('{{.css_main_url}}', '/static/css/main.css')
	result = result.replace('{{.css_chat_url}}', '/static/css/chat.css')
	result = result.replace('{{.js_theme_url}}', '/static/js/theme.js')
	result = result.replace('{{.js_chat_url}}', '/static/js/chat.js')

	return result
}

// Fallback HeroScript rendering method
fn (app &App) render_heroscript_fallback() string {
	return '
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>${app.title} - HeroScript Editor</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container mt-5">
		<h1>HeroScript Editor</h1>
		<p>HeroScript editor template not found. Please check the template files.</p>
		<a href="/admin" class="btn btn-primary">Back to Admin</a>
	</div>
</body>
</html>
'
}

// Fallback Chat rendering method
fn (app &App) render_chat_fallback() string {
	return '
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>${app.title} - Chat</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container mt-5">
		<h1>Chat Assistant</h1>
		<p>Chat template not found. Please check the template files.</p>
		<a href="/admin" class="btn btn-primary">Back to Admin</a>
	</div>
</body>
</html>
'
}

// Fallback rendering method (inline template)
fn (app &App) render_admin_fallback(path string, heading string) string {
	return '
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>${app.title}</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<style>
		body { padding-top: 44px; }
		.header {
			height: 44px;
			line-height: 44px;
			font-size: 14px;
		}
		.sidebar {
			position: fixed;
			top: 44px;
			bottom: 0;
			left: 0;
			width: 260px;
			overflow-y: auto;
			background: #f8f9fa;
			border-right: 1px solid #e0e0e0;
		}
		.main {
			margin-left: 260px;
			padding: 16px;
		}
		.list-group-item {
			border: 0;
			padding: .35rem .75rem;
			background: transparent;
		}
		.menu-leaf a {
			color: #212529;
			text-decoration: none;
		}
		.menu-toggle {
			text-decoration: none;
			color: #212529;
		}
		.menu-toggle .chev {
			font-size: 10px;
			opacity: .6;
		}
		.menu-section {
			font-weight: 600;
			color: #6c757d;
			padding: .5rem .75rem;
		}
	</style>
</head>
<body>
	<nav class="navbar navbar-dark bg-dark fixed-top header px-2">
		<div class="d-flex w-100 align-items-center justify-content-between">
			<div class="text-white fw-bold">${app.title}</div>
			<div class="text-white-50">Admin</div>
		</div>
	</nav>

	<aside class="sidebar">
		<div class="p-2">
			<div class="menu-section">Navigation</div>
			<div class="list-group list-group-flush">
				${menu_html(app.menu,
		0, 'm')}
			</div>
		</div>
	</aside>

	<main class="main">
		<div class="container-fluid">
			<div class="d-flex align-items-center mb-3">
				<h5 class="mb-0">${heading}</h5>
				<span class="ms-2 text-muted small">/admin/${path}</span>
			</div>
			<div class="card">
				<div class="card-body">
					<p class="text-muted">This is a placeholder admin content area for: <code>/admin/${path}</code>.</p>
					<p class="mb-0">Use the treeview on the left to navigate.</p>
				</div>
			</div>
		</div>
	</main>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>
'
}

// Recursive menu renderer

fn menu_html(items []MenuItem, depth int, prefix string) string {
	mut out := []string{}
	for i, it in items {
		id := '${prefix}_${depth}_${i}'
		if it.children.len > 0 {
			// expandable group
			out << '<div class="list-group-item">'
			out << '<a class="menu-toggle d-flex align-items-center justify-content-between" data-bs-toggle="collapse" href="#${id}" role="button" aria-expanded="${if depth == 0 {
				'true'
			} else {
				'false'
			}}" aria-controls="${id}">'
			out << '<span>${it.title}</span><span class="chev">&rsaquo;</span>'
			out << '</a>'
			out << '<div class="collapse ${if depth == 0 { 'show' } else { '' }}" id="${id}">'
			out << '<div class="ms-2 mt-1">'
			out << menu_html(it.children, depth + 1, id)
			out << '</div>'
			out << '</div>'
			out << '</div>'
		} else {
			// leaf
			out << '<div class="list-group-item menu-leaf"><a href="${if it.href.len > 0 {
				it.href
			} else {
				'/admin'
			}}">${it.title}</a></div>'
		}
	}
	return out.join('\n')
}

// Default sample menu
fn default_menu() []MenuItem {
	return [
		MenuItem{
			title: 'Dashboard'
			href:  '/admin'
		},
		MenuItem{
			title: 'HeroScript'
			href:  '/admin/heroscript'
		},
		MenuItem{
			title: 'Chat'
			href:  '/admin/chat'
		},
		MenuItem{
			title:    'Users'
			children: [
				MenuItem{
					title: 'Overview'
					href:  '/admin/users/overview'
				},
				MenuItem{
					title: 'Create'
					href:  '/admin/users/create'
				},
				MenuItem{
					title: 'Roles'
					href:  '/admin/users/roles'
				},
			]
		},
		MenuItem{
			title:    'Content'
			children: [
				MenuItem{
					title: 'Pages'
					href:  '/admin/content/pages'
				},
				MenuItem{
					title: 'Media'
					href:  '/admin/content/media'
				},
				MenuItem{
					title:    'Settings'
					children: [
						MenuItem{
							title: 'SEO'
							href:  '/admin/content/settings/seo'
						},
						MenuItem{
							title: 'Themes'
							href:  '/admin/content/settings/themes'
						},
					]
				},
			]
		},
		MenuItem{
			title:    'System'
			children: [
				MenuItem{
					title: 'Status'
					href:  '/admin/system/status'
				},
				MenuItem{
					title: 'Logs'
					href:  '/admin/system/logs'
				},
				MenuItem{
					title: 'Backups'
					href:  '/admin/system/backups'
				},
			]
		},
	]
}
