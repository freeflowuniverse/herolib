module codewalker

import freeflowuniverse.herolib.core.pathlib

pub struct FileMap {
pub mut:
	source string
	content map[string]string
}

pub fn (mut fm FileMap) content() {
	for filepath, filecontent in fm.content {
		println('===${filepath}===')
		println(filecontent)
		println('===END===')
	}
}

pub fn (mut fm FileMap) export(path string)! {
	for filepath, filecontent in fm.content {
		dest := "${fm.source}/${filepath}"
		mut filepathtowrite := pathlib.get_file(path:dest,create:true)!
		filepathtowrite.write(filecontent)!
	}
}


pub fn (fm FileMap) get(relpath string) !string {
	return fm.content[relpath] or { return error('File not found: ${relpath}') }
}

pub fn (mut fm FileMap) set(relpath string, content string) {
	fm.content[relpath] = content
}

pub fn (mut fm FileMap) delete(relpath string) {
	fm.content.delete(relpath)
}

pub fn (fm FileMap) find(path string) []string {
	mut result := []string{}
	for filepath, _ in fm.content {
		if filepath.starts_with(path) {
			result << filepath
		}
	}
	return result
}