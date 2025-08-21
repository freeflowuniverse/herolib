module heroprompt

import veb
import os
import json
import freeflowuniverse.herolib.develop.heroprompt as hp

// Types
struct DirItem {
	name string
	typ  string @[json: 'type']
}

struct DirResp {
	path  string
	items []DirItem
}

// APIs
@['/api/heroprompt/workspaces'; get]
pub fn api_heroprompt_list(mut ctx ui.Context) veb.Result {
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
	items_w := wsp.list() or { return ctx.text('{"error":"cannot list directory"}') }
	ctx.set_content_type('application/json')
	mut items := []DirItem{}
	for it in items_w {
		items << DirItem{
			name: it.name
			typ:  it.typ
		}
	}
	return ctx.text(json.encode(DirResp{
		path:  if path_q.len > 0 { path_q } else { wsp.base_path }
		items: items
	}))
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
	content := os.read_file(file_path) or { return ctx.text('{"error":"failed to read"}') }
	ctx.set_content_type('application/json')
	return ctx.text(json.encode({
		'language': detect_lang(file_path)
		'content':  content
	}))
}

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
