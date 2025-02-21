module webdav

import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.vfs.vfscore
import encoding.xml
import os
import time
import veb

fn generate_response_element(entry vfscore.FSEntry) !xml.XMLNode {
	path := if entry.is_dir() && entry.get_path() != '/' {
		'${entry.get_path()}/'
	} else { entry.get_path() }

	return xml.XMLNode{
		name:     'D:response'
		children: [
			xml.XMLNode{
				name:     'D:href'
				children: [path]
			}, 
			generate_propstat_element(entry)!
		]
	}
}

const xml_ok_status = xml.XMLNode{
	name:     'D:status'
	children: ['HTTP/1.1 200 OK']
}

const xml_500_status = xml.XMLNode{
	name:     'D:status'
	children: ['HTTP/1.1 500 Internal Server Error']
}

fn generate_propstat_element(entry vfscore.FSEntry) !xml.XMLNode {
	prop := generate_prop_element(entry) or {
		// TODO: status should be according to returned error
		return xml.XMLNode{
			name:     'D:propstat'
			children: [xml_500_status]
		}
	}

	return xml.XMLNode{
		name:     'D:propstat'
		children: [prop, xml_ok_status]
	}
}

fn generate_prop_element(entry vfscore.FSEntry) !xml.XMLNode {
	metadata := entry.get_metadata()

	display_name := xml.XMLNode{
		name:     'D:displayname'
		children: ['${metadata.name}']
	}

	content_length := if entry.is_dir() { 0 } else { metadata.size }
	get_content_length := xml.XMLNode{
		name:     'D:getcontentlength'
		children: ['${content_length}']
	}

	creation_date := xml.XMLNode{
		name:     'D:creationdate'
		children: ['${format_iso8601(metadata.created_time())}']
	}

	get_last_mod := xml.XMLNode{
		name:     'D:getlastmodified'
		children: ['${format_iso8601(metadata.modified_time())}']
	}

	content_type := match entry.is_dir() {
		true {
			'httpd/unix-directory'
		}
		false {
			get_file_content_type(entry.get_path())
		}
	}

	get_content_type := xml.XMLNode{
		name:     'D:getcontenttype'
		children: ['${content_type}']
	}

	mut get_resource_type_children := []xml.XMLNodeContents{}

	if entry.is_dir() {
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
	if !entry.is_dir() {
		nodes << get_content_length
	}
	nodes << creation_date

	mut res := xml.XMLNode{
		name:     'D:prop'
		children: nodes.clone()
	}

	return res
}

fn get_file_content_type(path string) string {
	ext := path.all_after_last('.')
	content_type := if v := veb.mime_types[ext] {
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
	
	entry := app.vfs.get(path)!
	responses << generate_response_element(entry)!
	if depth == 0 {
		return responses
	}

	entries := app.vfs.dir_list(path) or {return responses}
	for e in entries {
		responses << generate_response_element(e)!
	}
	return responses
}