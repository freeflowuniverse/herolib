module vfs_db

import freeflowuniverse.herolib.vfs
import os
import time

// Implementation of VFSImplementation interface
pub fn (mut fs DatabaseVFS) root_get_as_dir() !&Directory {
	// Try to load root directory from DB if it exists
	if fs.root_id in fs.id_table {
		if data := fs.db_metadata.get(fs.get_database_id(fs.root_id)!) {
			mut loaded_root := decode_directory(data) or {
				return error('Failed to decode root directory: ${err}')
			}
			return &loaded_root
		}
	}

	// Create and save new root directory
	mut myroot := Directory{
		metadata:  vfs.Metadata{
			id:          fs.get_next_id()
			file_type:   .directory
			name:        ''
			created_at:  time.now().unix()
			modified_at: time.now().unix()
			accessed_at: time.now().unix()
			mode:        0o755  // default directory permissions
			owner:       'user' // TODO: get from system
			group:       'user' // TODO: get from system
		}
		parent_id: 0
	}
	fs.root_id = fs.save_entry(myroot)!
	return &myroot
}

fn (mut self DatabaseVFS) get_entry(path string) !FSEntry {
	if path == '/' || path == '' || path == '.' {
		return FSEntry(self.root_get_as_dir()!)
	}

	mut current := *self.root_get_as_dir()!
	parts := path.trim_left('/').split('/')

	for i := 0; i < parts.len; i++ {
		mut found := false
		children := self.directory_children(mut current, false)!
		for child in children {
			if child.metadata.name == parts[i] {
				match child {
					Directory {
						current = child
						found = true
						break
					}
					else {
						if i == parts.len - 1 {
							return child
						} else {
							return error('Not a directory: ${parts[i]}')
						}
					}
				}
			}
		}

		if !found {
			return error('Path not found: ${path}')
		}
	}

	return FSEntry(current)
}

fn (mut self DatabaseVFS) get_directory(path string) !&Directory {
	mut entry := self.get_entry(path)!
	if mut entry is Directory {
		return &entry
	}
	return error('Not a directory: ${path}')
}
