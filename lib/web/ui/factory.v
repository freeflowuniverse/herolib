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
pub struct FactoryArgs {
pub mut:
	name  string = 'default'
	port  int    = 8080
	title string = 'Admin'
	menu  []MenuItem
}

// The App holds server state and config
pub struct App {
	veb.StaticHandler
pub mut:
	title string
	menu  []MenuItem
	port  int
}

// Global registry (multi-instance support by name)
__global (
	uireg map[string]&App
)

// Create a new app (does not start the server)
pub fn new(args FactoryArgs) !&App {
	name := if args.name.len == 0 { 'default' } else { args.name }
	if app := uireg[name] {
		return app
	}
	mut app := &App{
		title: args.title
		menu:  if args.menu.len > 0 { args.menu } else { default_menu() }
		port:  args.port
	}
	uireg[name] = app
	return app
}

// Get a named app
pub fn get(name string) !&App {
	mut app := uireg[name] or {
		return error('ui: app "${name}" not found, call ui.new(...) first')
	}
	return app
}

// Get default app (creates if not existing)
pub fn default() !&App {
	if uireg.len == 0 {
		return new(port: 8080)!
	}
	return get('default')!
}

// Start the webserver (blocking)
pub fn start(args FactoryArgs) ! {
	mut app := new(args)!
	veb.run[App, Context](mut app, app.port)
}

// Routes

// Redirect root to /admin
@[get; '/']
pub fn (app &App) root(mut ctx Context) veb.Result {
	return ctx.redirect('/admin')
}

// Admin home page
@[get; '/admin']
pub fn (app &App) admin_index(mut ctx Context) veb.Result {
	return ctx.html(app.render_admin('/', 'Welcome'))
}

// Catch-all content under /admin/*
@[get; '/admin/:path...']
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
	
	return result
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
				${menu_html(app.menu, 0, 'm')}
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
			out << '<a class="menu-toggle d-flex align-items-center justify-content-between" data-bs-toggle="collapse" href="#${id}" role="button" aria-expanded="${if depth == 0 { "true" } else { "false" }}" aria-controls="${id}">'
			out << '<span>${it.title}</span><span class="chev">&rsaquo;</span>'
			out << '</a>'
			out << '<div class="collapse ${if depth == 0 { "show" } else { "" }}" id="${id}">'
			out << '<div class="ms-2 mt-1">'
			out << menu_html(it.children, depth + 1, id)
			out << '</div>'
			out << '</div>'
			out << '</div>'
		} else {
			// leaf
			out << '<div class="list-group-item menu-leaf"><a href="${if it.href.len > 0 { it.href } else { "/admin" }}">${it.title}</a></div>'
		}
	}
	return out.join('\n')
}

// Default sample menu
fn default_menu() []MenuItem {
	return [
		MenuItem{
			title: 'Dashboard'
			href: '/admin'
		},
		MenuItem{
			title: 'Users'
			children: [
				MenuItem{ title: 'Overview', href: '/admin/users/overview' },
				MenuItem{ title: 'Create', href: '/admin/users/create' },
				MenuItem{ title: 'Roles', href: '/admin/users/roles' },
			]
		},
		MenuItem{
			title: 'Content'
			children: [
				MenuItem{ title: 'Pages', href: '/admin/content/pages' },
				MenuItem{ title: 'Media', href: '/admin/content/media' },
				MenuItem{
					title: 'Settings'
					children: [
						MenuItem{ title: 'SEO', href: '/admin/content/settings/seo' },
						MenuItem{ title: 'Themes', href: '/admin/content/settings/themes' },
					]
				},
			]
		},
		MenuItem{
			title: 'System'
			children: [
				MenuItem{ title: 'Status', href: '/admin/system/status' },
				MenuItem{ title: 'Logs', href: '/admin/system/logs' },
				MenuItem{ title: 'Backups', href: '/admin/system/backups' },
			]
		},
	]
}