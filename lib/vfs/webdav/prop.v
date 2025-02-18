module webdav

import freeflowuniverse.herolib.core.pathlib
import encoding.xml
import os
import time
import vweb

fn (mut app App) generate_response_element(path string, depth int) xml.XMLNode {
	mut path_ := path
	if !path_.starts_with('/') {
		path_ = '/${path_}'
	}

	if os.is_dir(path) && path_ != '/' {
		path_ = '${path_}/'
	}

	href := xml.XMLNode{
		name:     'D:href'
		children: [path_]
	}

	propstat := app.generate_propstat_element(path, depth)

	return xml.XMLNode{
		name:     'D:response'
		children: [href, propstat]
	}
}

fn (mut app App) generate_propstat_element(path string, depth int) xml.XMLNode {
	mut status := xml.XMLNode{
		name:     'D:status'
		children: ['HTTP/1.1 200 OK']
	}

	prop := app.generate_prop_element(path, depth) or {
		// TODO: status should be according to returned error
		return xml.XMLNode{
			name:     'D:propstat'
			children: [
				xml.XMLNode{
					name:     'D:status'
					children: ['HTTP/1.1 500 Internal Server Error']
				},
			]
		}
	}

	return xml.XMLNode{
		name:     'D:propstat'
		children: [prop, status]
	}
}

fn (mut app App) generate_prop_element(path string, depth int) !xml.XMLNode {
	if !os.exists(path) {
		return error('not found')
	}

	stat := os.stat(path)!

	display_name := xml.XMLNode{
		name:     'D:displayname'
		children: ['${os.file_name(path)}']
	}

	content_length := if os.is_dir(path) { 0 } else { stat.size }
	get_content_length := xml.XMLNode{
		name:     'D:getcontentlength'
		children: ['${content_length}']
	}

	ctime := format_iso8601(time.unix(stat.ctime))
	creation_date := xml.XMLNode{
		name:     'D:creationdate'
		children: ['${ctime}']
	}

	mtime := format_iso8601(time.unix(stat.mtime))
	get_last_mod := xml.XMLNode{
		name:     'D:getlastmodified'
		children: ['${mtime}']
	}

	content_type := match os.is_dir(path) {
		true {
			'httpd/unix-directory'
		}
		false {
			app.get_file_content_type(path)
		}
	}

	get_content_type := xml.XMLNode{
		name:     'D:getcontenttype'
		children: ['${content_type}']
	}

	mut get_resource_type_children := []xml.XMLNodeContents{}

	if os.is_dir(path) {
		get_resource_type_children << xml.XMLNode{
			name: 'D:collection xmlns:D="DAV:"'
		}
	}

	get_resource_type := xml.XMLNode{
		name:     'D:resourcetype'
		children: get_resource_type_children
	}

	mut nodes := []xml.XMLNodeContents{}
	nodes << display_name
	nodes << get_last_mod
	nodes << get_content_type
	nodes << get_resource_type
	if !os.is_dir(path) {
		nodes << get_content_length
	}
	nodes << creation_date

	mut res := xml.XMLNode{
		name:     'D:prop'
		children: nodes.clone()
	}

	return res
}

fn (mut app App) get_file_content_type(path string) string {
	ext := os.file_ext(path)
	content_type := if v := vweb.mime_types[ext] {
		v
	} else {
		'text/plain; charset=utf-8'
	}

	return content_type
}

fn format_iso8601(t time.Time) string {
	return '${t.year:04d}-${t.month:02d}-${t.day:02d}T${t.hour:02d}:${t.minute:02d}:${t.second:02d}Z'
}

fn (mut app App) get_responses(path string, depth int) ![]xml.XMLNodeContents {
	mut responses := []xml.XMLNodeContents{}

	responses << app.generate_response_element(path, depth)
	if depth == 0 {
		return responses
	}

	if os.is_dir(path) {
		mut dir := pathlib.get_dir(path: path) or {
			app.set_status(500, 'failed to get directory ${path}: ${err}')
			return error('failed to get directory ${path}: ${err}')
		}

		entries := dir.list(recursive: false) or {
			app.set_status(500, 'failed to list directory ${path}: ${err}')
			return error('failed to list directory ${path}: ${err}')
		}

		for entry in entries.paths {
			responses << app.generate_response_element(entry.path, depth)
		}
	}

	return responses
}
