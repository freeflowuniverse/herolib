module heroprompt

import os
import freeflowuniverse.herolib.core.pathlib

// Parameters for adding a file to a directory
@[params]
pub struct AddFileParams {
pub mut:
	name string // Name of the file to select
}

// select_file adds a specific file to the directory's selected files list
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

// select_all_files_and_dirs recursively selects all files and subdirectories
// from the given path and adds them to the current directory structure
pub fn (mut dir HeropromptDir) select_all_files_and_dirs(path string) {
	// First, get all immediate children (files and directories) of the current path
	entries := os.ls(path) or { return }

	for entry in entries {
		full_path := os.join_path(path, entry)

		if os.is_dir(full_path) {
			// Create subdirectory
			mut sub_dir := &HeropromptDir{
				path: pathlib.Path{
					path:  full_path
					cat:   .dir
					exist: .yes
				}
				name: entry
			}

			// Recursively populate the subdirectory
			sub_dir.select_all_files_and_dirs(full_path)

			// Add subdirectory to current directory
			dir.dirs << sub_dir
		} else if os.is_file(full_path) {
			// Read file content when selecting all
			file_content := os.read_file(full_path) or { '' }

			file := &HeropromptFile{
				path:    pathlib.Path{
					path:  full_path
					cat:   .file
					exist: .yes
				}
				name:    entry
				content: file_content
			}
			dir.files << file
		}
	}
}
