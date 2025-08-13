module heroprompt

import os
import freeflowuniverse.herolib.core.pathlib

@[params]
pub struct AddFileParams {
pub mut:
	name string
}

pub fn (mut dir HeropromptDir) select_file(args AddFileParams) !&HeropromptFile {
	mut full_path := dir.path.path + '/' + args.name
	if dir.path.path.ends_with('/') {
		full_path = dir.path.path + args.name
	}

	if !os.exists(full_path) {
		return error('File ${full_path} does not exists')
	}

	if !os.is_file(full_path) {
		return error('Provided path ${full_path} is not a file')
	}

	file_content := os.read_file(full_path)!

	file := &HeropromptFile{
		path:    pathlib.Path{
			path:  full_path
			cat:   .file
			exist: .yes
		}
		name:    args.name
		content: file_content
	}

	dir.files << file
	return file
}
