module ui

import veb
import freeflowuniverse.herolib.develop.heroprompt
import os
import json

// Directory browsing and file read endpoints for Heroprompt.js compatibility
struct DirItem {
	name string
	typ  string @[json: 'type']
}

struct DirResp {
	path string
mut:
	items []DirItem
}

@['/api/heroprompt/directory'; get]
pub fn (app &App) api_heroprompt_directory(mut ctx Context) veb.Result {
	// Optional workspace name, defaults to 'default'
	wsname := ctx.query['name'] or { 'default' }
	path_q := ctx.query['path'] or { '' }
	if path_q.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	// Try to resolve against workspace base_path if available, but do not require it
	mut base := ''
	if wsp := heroprompt.get(name: wsname, create: false) {
		base = wsp.base_path
	}
	// Resolve path: if absolute, use as-is; else join with base
	mut dir_path := path_q
	if !os.is_abs_path(dir_path) && base.len > 0 {
		dir_path = os.join_path(base, dir_path)
	}
	// List entries
	entries := os.ls(dir_path) or { return ctx.text('{"error":"cannot list directory"}') }
	mut items := []map[string]string{}
	for e in entries {
		full := os.join_path(dir_path, e)
		if os.is_dir(full) {
			items << {
				'name': e
				'type': 'directory'
			}
		} else if os.is_file(full) {
			items << {
				'name': e
				'type': 'file'
			}
		}
	}
	ctx.set_content_type('application/json')
	// Encode strongly typed JSON response
	mut resp := DirResp{
		path: dir_path
	}
	for it in items {
		resp.items << DirItem{
			name: it['name'] or { '' }
			typ:  it['type'] or { '' }
		}
	}
	return ctx.text(json.encode(resp))
}

@['/api/heroprompt/file'; get]
pub fn (app &App) api_heroprompt_file(mut ctx Context) veb.Result {
	wsname := ctx.query['name'] or { 'default' }
	path_q := ctx.query['path'] or { '' }
	if path_q.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	// Try to resolve against workspace base_path if available, but do not require it
	mut base := ''
	if wsp := heroprompt.get(name: wsname, create: false) {
		base = wsp.base_path
	}
	mut file_path := path_q
	if !os.is_abs_path(file_path) && base.len > 0 {
		file_path = os.join_path(base, file_path)
	}
	content := os.read_file(file_path) or { return ctx.text('{"error":"failed to read"}') }
	lang := detect_lang(file_path)
	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'language': lang
		'content':  content
	}))
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

// Heroprompt API: list workspaces
@['/api/heroprompt/workspaces'; get]
pub fn (app &App) api_heroprompt_list(mut ctx Context) veb.Result {
	mut names := []string{}
	ws := heroprompt.list(fromdb: true) or { []&heroprompt.Workspace{} }
	for w in ws {
		names << w.name
	}
	ctx.set_content_type('application/json')
	return ctx.text(json.encode(names))
}

// Heroprompt API: create/get workspace
@['/api/heroprompt/workspaces'; post]
pub fn (app &App) api_heroprompt_create(mut ctx Context) veb.Result {
	name := ctx.form['name'] or { '' }
	base_path := ctx.form['base_path'] or { '' }

	if base_path.len == 0 {
		return ctx.text('{"error":"base_path required"}')
	}

	mut wsp := heroprompt.get(name: name, create: true, path: base_path) or {
		return ctx.text('{"error":"create failed"}')
	}

	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'name':      name
		'base_path': base_path
	}))
}

// Heroprompt API: add directory to workspace
@['/api/heroprompt/workspaces/:name/dirs'; post]
pub fn (app &App) api_heroprompt_add_dir(mut ctx Context, name string) veb.Result {
	path := ctx.form['path'] or { '' }
	if path.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	mut wsp := heroprompt.get(name: name, create: true) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.add_dir(path: path) or { return ctx.text('{"error":"' + err.msg() + '"}') }
	ctx.set_content_type('application/json')
	return ctx.text('{"ok":true}')
}

// Heroprompt API: add file to workspace
@['/api/heroprompt/workspaces/:name/files'; post]
pub fn (app &App) api_heroprompt_add_file(mut ctx Context, name string) veb.Result {
	path := ctx.form['path'] or { '' }
	if path.len == 0 {
		return ctx.text('{"error":"path required"}')
	}
	mut wsp := heroprompt.get(name: name, create: true) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.add_file(path: path) or { return ctx.text('{"error":"' + err.msg() + '"}') }
	ctx.set_content_type('application/json')
	return ctx.text('{"ok":true}')
}

// Heroprompt API: generate prompt
@['/api/heroprompt/workspaces/:name/prompt'; post]
pub fn (app &App) api_heroprompt_prompt(mut ctx Context, name string) veb.Result {
	text := ctx.form['text'] or { '' }
	mut wsp := heroprompt.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	prompt := wsp.prompt(text: text)
	ctx.set_content_type('text/plain')
	return ctx.text(prompt)
}

// Heroprompt API: get workspace details
@['/api/heroprompt/workspaces/:name'; get]
pub fn (app &App) api_heroprompt_get(mut ctx Context, name string) veb.Result {
	wsp := heroprompt.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	mut children := []map[string]string{}
	for ch in wsp.children {
		children << {
			'name': ch.name
			'path': ch.path.path
			'type': if ch.path.cat == .dir { 'directory' } else { 'file' }
		}
	}
	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'name':      wsp.name
		'base_path': wsp.base_path
		'children':  json.encode(children)
	}))
}

// Heroprompt API: delete workspace
@['/api/heroprompt/workspaces/:name'; delete]
pub fn (app &App) api_heroprompt_delete(mut ctx Context, name string) veb.Result {
	wsp := heroprompt.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.delete_workspace() or { return ctx.text('{"error":"delete failed"}') }
	ctx.set_content_type('application/json')
	return ctx.text('{"ok":true}')
}

// Heroprompt API: remove directory
@['/api/heroprompt/workspaces/:name/dirs/remove'; post]
pub fn (app &App) api_heroprompt_remove_dir(mut ctx Context, name string) veb.Result {
	path := ctx.form['path'] or { '' }
	mut wsp := heroprompt.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.remove_dir(path: path, name: '') or { return ctx.text('{"error":"' + err.msg() + '"}') }
	return ctx.text('{"ok":true}')
}

// Heroprompt API: remove file
@['/api/heroprompt/workspaces/:name/files/remove'; post]
pub fn (app &App) api_heroprompt_remove_file(mut ctx Context, name string) veb.Result {
	path := ctx.form['path'] or { '' }
	mut wsp := heroprompt.get(name: name, create: false) or {
		return ctx.text('{"error":"workspace not found"}')
	}
	wsp.remove_file(path: path, name: '') or { return ctx.text('{"error":"' + err.msg() + '"}') }
	return ctx.text('{"ok":true}')
}
