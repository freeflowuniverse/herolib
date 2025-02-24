module ourdb_fs

import time

// FSEntry represents any type of filesystem entry
pub type FSEntry = Directory | File | Symlink

// Directory represents a directory in the virtual filesystem
pub struct Directory {
pub mut:
	metadata  Metadata // Metadata from models_common.v
	children  []u32    // List of child entry IDs (instead of actual entries)
	parent_id u32      // ID of parent directory (0 for root)
	myvfs     &OurDBFS @[str: skip]
}

pub fn (mut self Directory) save() ! {
	self.myvfs.save_entry(self)!
}

// write creates a new file or writes to an existing file
pub fn (mut dir Directory) write(name string, content string) !&File {
	mut file := &File{
		myvfs: dir.myvfs
	}
	mut is_new := true

	// Check if file exists
	for child_id in dir.children {
		mut entry := dir.myvfs.load_entry(child_id)!
		if entry.metadata.name == name {
			if mut entry is File {
				mut d := entry
				file = &d
				is_new = false
				break
			} else {
				return error('${name} exists but is not a file')
			}
		}
	}

	if is_new {
		// Create new file
		current_time := time.now().unix()
		file = &File{
			metadata:  Metadata{
				id:          dir.myvfs.get_next_id()
				name:        name
				file_type:   .file
				size:        u64(content.len)
				created_at:  current_time
				modified_at: current_time
				accessed_at: current_time
				mode:        0o644
				owner:       'user'
				group:       'user'
			}
			data:      content
			parent_id: dir.metadata.id
			myvfs:     dir.myvfs
		}

		// Save new file to DB
		dir.myvfs.save_entry(file)!

		// Update children list
		dir.children << file.metadata.id
		dir.myvfs.save_entry(dir)!
	} else {
		// Update existing file
		file.write(content)!
	}

	return file
}

// read reads content from a file
pub fn (mut dir Directory) read(name string) !string {
	// Find file
	for child_id in dir.children {
		if mut entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == name {
				if mut entry is File {
					return entry.read()
				} else {
					return error('${name} is not a file')
				}
			}
		}
	}
	return error('File ${name} not found')
}

// str returns a formatted string of directory contents (non-recursive)
// pub fn (mut dir Directory) str() string {
// mut result := '${dir.metadata.name}/\n'

// for child_id in dir.children {
// 	if entry := dir.myvfs.load_entry(child_id) {
// 		if entry is Directory {
// 			result += '  📁 ${entry.metadata.name}/\n'
// 		} else if entry is File {
// 			result += '  📄 ${entry.metadata.name}\n'
// 		} else if entry is Symlink {
// 			result += '  🔗 ${entry.metadata.name} -> ${entry.target}\n'
// 		}
// 	}
// }
// return result
// }

// printall prints the directory structure recursively
pub fn (mut dir Directory) printall(indent string) !string {
	mut result := '${indent}📁 ${dir.metadata.name}/\n'

	for child_id in dir.children {
		mut entry := dir.myvfs.load_entry(child_id)!
		if mut entry is Directory {
			result += entry.printall(indent + '  ')!
		} else if entry is File {
			result += '${indent}  📄 ${entry.metadata.name}\n'
		} else if mut entry is Symlink {
			result += '${indent}  🔗 ${entry.metadata.name} -> ${entry.target}\n'
		}
	}
	return result
}

// mkdir creates a new directory with default permissions
pub fn (mut dir Directory) mkdir(name string) !&Directory {
	// Check if directory already exists
	for child_id in dir.children {
		if entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == name {
				return error('Directory ${name} already exists')
			}
		}
	}

	current_time := time.now().unix()
	mut new_dir := Directory{
		metadata:  Metadata{
			id:          dir.myvfs.get_next_id()
			name:        name
			file_type:   .directory
			created_at:  current_time
			modified_at: current_time
			accessed_at: current_time
			mode:        0o755  // default directory permissions
			owner:       'user' // TODO: get from system
			group:       'user' // TODO: get from system
		}
		children:  []u32{}
		parent_id: dir.metadata.id
		myvfs:     dir.myvfs
	}

	// Save new directory to DB
	dir.myvfs.save_entry(new_dir)!

	// Update children list
	dir.children << new_dir.metadata.id
	dir.myvfs.save_entry(dir)!

	return &new_dir
}

// touch creates a new empty file with default permissions
pub fn (mut dir Directory) touch(name string) !&File {
	// Check if file already exists
	for child_id in dir.children {
		if entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == name {
				return error('File ${name} already exists')
			}
		}
	}

	current_time := time.now().unix()
	mut new_file := File{
		metadata:  Metadata{
			id:          dir.myvfs.get_next_id()
			name:        name
			file_type:   .file
			size:        0
			created_at:  current_time
			modified_at: current_time
			accessed_at: current_time
			mode:        0o644  // default file permissions
			owner:       'user' // TODO: get from system
			group:       'user' // TODO: get from system
		}
		data:      '' // Initialize with empty content
		parent_id: dir.metadata.id
		myvfs:     dir.myvfs
	}

	// Save new file to DB
	dir.myvfs.save_entry(new_file)!

	// Update children list
	dir.children << new_file.metadata.id
	dir.myvfs.save_entry(dir)!

	return &new_file
}

// rm removes a file or directory by name
pub fn (mut dir Directory) rm(name string) ! {
	mut found := false
	mut found_id := u32(0)
	mut found_idx := 0

	for i, child_id in dir.children {
		if entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == name {
				found = true
				found_id = child_id
				found_idx = i
				if entry is Directory {
					if entry.children.len > 0 {
						return error('Directory not empty')
					}
				}
				break
			}
		}
	}

	if !found {
		return error('${name} not found')
	}

	// Delete entry from DB
	dir.myvfs.delete_entry(found_id)!

	// Update children list
	dir.children.delete(found_idx)
	dir.myvfs.save_entry(dir)!
}

pub struct MoveDirArgs {
pub mut:
	src_entry_name string     @[required] // source entry name
	dst_entry_name string     @[required] // destination entry name
	dst_parent_dir &Directory @[required] // destination directory
}

pub fn (dir_ Directory) move(args_ MoveDirArgs) !&Directory {
	mut dir := dir_
	mut args := args_
	mut found := false

	for child_id in dir.children {
		if mut entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == args.src_entry_name {
				if entry is File {
					return error('${args.src_entry_name} is a file')
				}

				if entry is Symlink {
					return error('${args.src_entry_name} is a symlink')
				}

				found = true
				mut entry_ := entry as Directory
				entry_.metadata.name = args.dst_entry_name
				entry_.metadata.modified_at = time.now().unix()
				entry_.parent_id = args.dst_parent_dir.metadata.id

				// Remove from old parent's children
				dir.children = dir.children.filter(it != child_id)
				dir.save()!

				// Recursively update all child paths in moved directory
				move_children_recursive(mut entry_)!

				// Ensure no duplicate entries in dst_parent_dir
				if entry_.metadata.id !in args.dst_parent_dir.children {
					args.dst_parent_dir.children << entry_.metadata.id
				}

				args.dst_parent_dir.myvfs.save_entry(entry_)!
				args.dst_parent_dir.save()!

				return &entry_
			}
		}
	}

	if !found {
		return error('${args.src_entry_name} not found')
	}

	return error('Unexpected move failure')
}

// Recursive function to update parent_id for all children
fn move_children_recursive(mut dir Directory) ! {
	for child in dir.children {
		if mut child_entry := dir.myvfs.load_entry(child) {
			child_entry.parent_id = dir.metadata.id

			if child_entry is Directory {
				// Recursively move subdirectories
				mut child_entry_ := child_entry as Directory
				move_children_recursive(mut child_entry_)!
			}

			dir.myvfs.save_entry(child_entry)!
		}
	}
}

pub fn (mut dir Directory) copy(src_name string, dst_name string) !Directory {
	mut found := false
	mut new_entry := FSEntry(dir)
	current_time := time.now().unix()

	for child_id in dir.children {
		if mut entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == src_name {
				found = true
				new_entry = entry
				// Create a new copy
				if entry is Directory {
					mut entry_ := entry as Directory
					mut new_dir := Directory{
						metadata:  entry_.metadata
						children:  entry_.children
						parent_id: entry_.parent_id
						myvfs:     entry_.myvfs
					}

					new_dir.metadata.id = entry_.myvfs.get_next_id()
					new_dir.metadata.name = dst_name
					new_dir.metadata.created_at = current_time
					new_dir.metadata.modified_at = current_time
					new_dir.metadata.accessed_at = current_time

					dir.children << new_dir.metadata.id
					dir.metadata.modified_at = current_time
					dir.metadata.id = dir.myvfs.save_entry(dir)!

					dir.myvfs.save_entry(new_dir)!
					return new_dir
				}
			}
		}
	}

	if !found {
		return error('${src_name} not found')
	}

	return &new_entry as Directory
}

pub fn (dir Directory) rename(src_name string, dst_name string) !&Directory {
	mut found := false
	mut dir_ := dir

	for child_id in dir.children {
		if mut entry := dir_.myvfs.load_entry(child_id) {
			if entry.metadata.name == src_name {
				found = true
				entry.metadata.name = dst_name
				entry.metadata.modified_at = time.now().unix()
				dir_.myvfs.save_entry(entry)!
				get_dir := entry as Directory
				return &get_dir
			}
		}
	}

	if !found {
		return error('${src_name} not found')
	}

	return &dir_
}

// get_children returns all immediate children as FSEntry objects
pub fn (mut dir Directory) children(recursive bool) ![]FSEntry {
	mut entries := []FSEntry{}
	for child_id in dir.children {
		entry := dir.myvfs.load_entry(child_id)!
		entries << entry
		if recursive {
			if entry is Directory {
				mut d := entry
				entries << d.children(true)!
			}
		}
	}

	return entries
}

pub fn (mut dir Directory) delete() ! {
	// Delete all children first
	for child_id in dir.children {
		dir.myvfs.delete_entry(child_id) or {}
	}

	// Clear children list
	dir.children.clear()

	// Save the updated directory
	dir.myvfs.save_entry(dir) or { return error('Failed to save directory: ${err}') }
}

// add_symlink adds an existing symlink to this directory
pub fn (mut dir Directory) add_symlink(mut symlink Symlink) ! {
	// Check if name already exists
	for child_id in dir.children {
		if entry := dir.myvfs.load_entry(child_id) {
			if entry.metadata.name == symlink.metadata.name {
				return error('Entry with name ${symlink.metadata.name} already exists')
			}
		}
	}

	// Save symlink to DB
	dir.myvfs.save_entry(symlink)!

	// Add to children
	dir.children << symlink.metadata.id
	dir.myvfs.save_entry(dir)!
}
