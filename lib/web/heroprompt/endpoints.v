module heroprompt

import veb
import os
import json
import time
import freeflowuniverse.herolib.develop.heroprompt as hp

// Types for directory listing
struct DirItem {
	name string
	typ  string @[json: 'type']
}

struct DirResp {
	path string
mut:
	items []DirItem
}

// HTML routes
@['/heroprompt'; get]
pub fn (app &App) page_index(mut ctx Context) veb.Result {
	return ctx.html(render_index(app))
}

// API routes (thin wrappers over develop.heroprompt)
@['/api/heroprompt/workspaces'; get]
pub fn (app &App) api_list(mut ctx Context) veb.Result {
	mut names := []string{}
	ws := hp.list(fromdb: true) or { []&hp.Workspace{} }
	for w in ws {
		names << w.name
	}
	ctx.set_content_type('application/json')
	return ctx.text(json.encode(names))
}

@['/api/heroprompt/workspaces'; post]
pub fn (app &App) api_create(mut ctx Context) veb.Result {
	name := ctx.form['name'] or { 'default' }
	base_path_in := ctx.form['base_path'] or { '' }
	if base_path_in.len == 0 {
		return ctx.text('{"error":"base_path required"}')
	}
	mut base_path := base_path_in
	// Expand tilde to user home
	if base_path.starts_with('~') {
		home := os.home_dir()
		base_path = os.join_path(home, base_path.all_after('~'))
	}
	_ := hp.get(name: name, create: true, path: base_path) or {
		return ctx.text('{"error":"create failed"}')
	}
	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'name':      name
		'base_path': base_path
	}))
}

@['/api/heroprompt/directory'; get]
pub fn (app &App) api_directory(mut ctx Context) veb.Result {
	wsname := ctx.query['name'] or { 'default' }
	path_q := ctx.query['path'] or { '' }
	mut wsp := hp.get(name: wsname, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	// Use workspace list method; empty path means base_path
	items_w := if path_q.len > 0 { wsp.list() or {
			return ctx.text('{"error":"cannot list directory"}')} } else { wsp.list() or {
			return ctx.text('{"error":"cannot list directory"}')} }
	ctx.set_content_type('application/json')
	mut resp := DirResp{
		path: if path_q.len > 0 { path_q } else { wsp.base_path }
	}
	for it in items_w {
		resp.items << DirItem{
			name: it.name
			typ:  it.typ
		}
	}
	return ctx.text(json.encode(resp))
}

// -------- File content endpoint --------
struct FileResp {
	language string
	content  string
}

@['/api/heroprompt/file'; get]
pub fn (app &App) api_file(mut ctx Context) veb.Result {
	wsname := ctx.query['name'] or { 'default' }
	path_q := ctx.query['path'] or { '' }
	if path_q.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	mut base := ''
	if wsp := hp.get(name: wsname, create: false) {
		base = wsp.base_path
	}
	mut file_path := if !os.is_abs_path(path_q) && base.len > 0 {
		os.join_path(base, path_q)
	} else {
		path_q
	}
	if !os.is_file(file_path) {
		return ctx.text('{"error":"not a file"}')
	}
	// limit read to 1MB to avoid huge responses
	max_size := i64(1_000_000)
	sz := os.file_size(file_path)
	if sz > max_size {
		return ctx.text('{"error":"file too large"}')
	}
	content := os.read_file(file_path) or { return ctx.text('{"error":"failed to read"}') }
	lang := detect_lang(file_path)
	ctx.set_content_type('application/json')
	return ctx.text(json.encode(FileResp{ language: lang, content: content }))
}

fn detect_lang(path string) string {
	ext := os.file_ext(path).trim_left('.')
	return match ext.to_lower() {
		'v' { 'v' }
		'js' { 'javascript' }
		'ts' { 'typescript' }
		'py' { 'python' }
		'rs' { 'rust' }
		'go' { 'go' }
		'java' { 'java' }
		'c', 'h' { 'c' }
		'cpp', 'hpp', 'cc', 'hh' { 'cpp' }
		'sh', 'bash' { 'bash' }
		'json' { 'json' }
		'yaml', 'yml' { 'yaml' }
		'html', 'htm' { 'html' }
		'css' { 'css' }
		'md' { 'markdown' }
		else { 'text' }
	}
}

// -------- Filename search endpoint --------
struct SearchItem {
	path string
	typ  string @[json: 'type']
}

@['/api/heroprompt/search'; get]
pub fn (app &App) api_search(mut ctx Context) veb.Result {
	wsname := ctx.query['name'] or { 'default' }
	q := ctx.query['q'] or { '' }
	if q.len == 0 {
		return ctx.text('{"error":"q required"}')
	}
	mut base := ''
	if wsp := hp.get(name: wsname, create: false) {
		base = wsp.base_path
	}
	if base.len == 0 {
		return ctx.text('{"error":"workspace base_path not set"}')
	}
	max := (ctx.query['max'] or { '200' }).int()
	mut results := []SearchItem{}
	walk_search(base, q, max, mut results)
	ctx.set_content_type('application/json')
	return ctx.text(json.encode(results))
}

// Workspace details
@['/api/heroprompt/workspaces/:name'; get]
pub fn (app &App) api_workspace_get(mut ctx Context, name string) veb.Result {
	wsp := hp.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'name':      wsp.name
		'base_path': wsp.base_path
	}))
}

@['/api/heroprompt/workspaces/:name'; delete]
pub fn (app &App) api_workspace_delete(mut ctx Context, name string) veb.Result {
	wsp := hp.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.delete_workspace() or { return ctx.text('{"error":"delete failed"}') }
	return ctx.text('{"ok":true}')
}

@['/api/heroprompt/workspaces/:name'; patch]
pub fn (app &App) api_workspace_patch(mut ctx Context, name string) veb.Result {
	wsp := hp.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	new_name := ctx.form['name'] or { '' }
	mut base_path := ctx.form['base_path'] or { '' }
	if base_path.len > 0 && base_path.starts_with('~') {
		home := os.home_dir()
		base_path = os.join_path(home, base_path.all_after('~'))
	}
	updated := wsp.update_workspace(name: new_name, base_path: base_path) or {
		return ctx.text('{"error":"update failed"}')
	}
	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'name':      updated.name
		'base_path': updated.base_path
	}))
}

// -------- Path validation endpoint --------
struct PathValidationResp {
	is_abs   bool
	exists   bool
	is_dir   bool
	expanded string
}

@['/api/heroprompt/validate_path'; get]
pub fn (app &App) api_validate_path(mut ctx Context) veb.Result {
	p_in := ctx.query['path'] or { '' }
	mut p := p_in
	if p.starts_with('~') {
		home := os.home_dir()
		p = os.join_path(home, p.all_after('~'))
	}
	is_abs := if p != '' { os.is_abs_path(p) } else { false }
	exists := if p != '' { os.exists(p) } else { false }
	isdir := if exists { os.is_dir(p) } else { false }
	ctx.set_content_type('application/json')
	resp := PathValidationResp{
		is_abs:   is_abs
		exists:   exists
		is_dir:   isdir
		expanded: p
	}
	return ctx.text(json.encode(resp))
}

fn walk_search(root string, q string, max int, mut out []SearchItem) {
	if out.len >= max {
		return
	}
	entries := os.ls(root) or { return }
	for e in entries {
		if e in ['.git', 'node_modules', 'build', 'dist', '.v'] {
			continue
		}
		p := os.join_path(root, e)
		if os.is_dir(p) {
			if out.len >= max {
				return
			}
			if e.to_lower().contains(q.to_lower()) {
				out << SearchItem{
					path: p
					typ:  'directory'
				}
			}
			walk_search(p, q, max, mut out)
		} else if os.is_file(p) {
			if e.to_lower().contains(q.to_lower()) {
				out << SearchItem{
					path: p
					typ:  'file'
				}
			}
		}
		if out.len >= max {
			return
		}
	}
}

// -------- Selection and prompt endpoints --------
@['/api/heroprompt/workspaces/:name/files'; post]
pub fn (app &App) api_add_file(mut ctx Context, name string) veb.Result {
	path := ctx.form['path'] or { '' }
	if path.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	mut wsp := hp.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.add_file(path: path) or { return ctx.text('{"error":"' + err.msg() + '"}') }
	return ctx.text('{"ok":true}')
}

@['/api/heroprompt/workspaces/:name/dirs'; post]
pub fn (app &App) api_add_dir(mut ctx Context, name string) veb.Result {
	path := ctx.form['path'] or { '' }
	if path.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	mut wsp := hp.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.add_dir(path: path) or { return ctx.text('{"error":"' + err.msg() + '"}') }
	return ctx.text('{"ok":true}')
}

@['/api/heroprompt/workspaces/:name/prompt'; post]
pub fn (app &App) api_generate_prompt(mut ctx Context, name string) veb.Result {
	text := ctx.form['text'] or { '' }
	mut wsp := hp.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	prompt := wsp.prompt(text: text)
	ctx.set_content_type('text/plain')
	return ctx.text(prompt)
}
