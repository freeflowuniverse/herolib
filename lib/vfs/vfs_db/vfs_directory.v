module vfs_db

import freeflowuniverse.herolib.vfs

// // write creates a new file or writes to an existing file
// pub fn (mut fs DatabaseVFS) directory_write(dir_ Directory, name string, content string) !&File {
// 	mut dir := dir_
// 	mut file := &File{}
// 	mut is_new := true

// 	// Check if file exists
// 	for child_id in dir.children {
// 		mut entry := fs.load_entry(child_id)!
// 		if entry.metadata.name == name {
// 			if mut entry is File {
// 				mut d := entry
// 				file = &d
// 				is_new = false
// 				break
// 			} else {
// 				return error('${name} exists but is not a file')
// 			}
// 		}
// 	}

// 	if is_new {
// 		// Create new file
// 		current_time := time.now().unix()
// 		file = &File{
// 			metadata:  vfs.Metadata{
// 				id:          fs.get_next_id()
// 				name:        name
// 				file_type:   .file
// 				size:        u64(content.len)
// 				created_at:  current_time
// 				modified_at: current_time
// 				accessed_at: current_time
// 				mode:        0o644
// 				owner:       'user'
// 				group:       'user'
// 			}
// 			data:      content
// 			parent_id: dir.metadata.id
// 		}

// 		// Save new file to DB
// 		fs.save_entry(file)!

// 		// Update children list
// 		dir.children << file.metadata.id
// 		fs.save_entry(dir)!
// 	} else {
// 		// Update existing file
// 		file.write(content)
// 		fs.save_entry(file)!
// 	}

// 	return file
// }

// // read reads content from a file
// pub fn (mut dir Directory) directory_read(name string) !string {
// 	// Find file
// 	for child_id in dir.children {
// 		if mut entry := dir.myvfs.load_entry(child_id) {
// 			if entry.metadata.name == name {
// 				if mut entry is File {
// 					return entry.read()
// 				} else {
// 					return error('${name} is not a file')
// 				}
// 			}
// 		}
// 	}
// 	return error('File ${name} not found')
// }

// mkdir creates a new directory with default permissions
pub fn (mut fs DatabaseVFS) directory_mkdir(mut dir Directory, name string) !&Directory {
	// Check if directory already exists
	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			if entry.metadata.name == name {
				return error('Directory ${name} already exists')
			}
		}
	}

	new_dir := fs.new_directory(name: name, parent_id: dir.metadata.id)!
	dir.children << new_dir.metadata.id
	fs.save_entry(dir)!
	return new_dir
}

pub struct NewDirectory {
pub:
	name      string @[required] // name of file or directory
	mode      u32    = 0o755 // file permissions
	owner     string = 'user'
	group     string = 'user'
	parent_id u32
	children  []u32
}

// mkdir creates a new directory with default permissions
pub fn (mut fs DatabaseVFS) new_directory(dir NewDirectory) !&Directory {
	d := Directory{
		parent_id: dir.parent_id
		metadata:  fs.new_metadata(NewMetadata{
			name:      dir.name
			mode:      dir.mode
			owner:     dir.owner
			group:     dir.group
			size:      u64(0)
			file_type: .directory
		})
		children:  dir.children
	}
	// Save new directory to DB
	fs.save_entry(d)!
	return &d
}

// mkdir creates a new directory with default permissions
pub fn (mut fs DatabaseVFS) copy_directory(dir Directory) !&Directory {
	return fs.new_directory(
		name:  dir.metadata.name
		mode:  dir.metadata.mode
		owner: dir.metadata.owner
		group: dir.metadata.group
	)
}

// touch creates a new empty file with default permissions
pub fn (mut fs DatabaseVFS) directory_touch(dir_ Directory, name string) !&File {
	mut dir := dir_

	// Check if file already exists
	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			if entry.metadata.name == name {
				return error('File ${name} already exists')
			}
		}
	}

	new_file := fs.new_file(
		parent_id: dir.metadata.id
		name:      name
	)!

	// Update children list
	dir.children << new_file.metadata.id
	fs.save_entry(dir)!
	return new_file
}

// rm removes a file or directory by name
pub fn (mut fs DatabaseVFS) directory_rm(mut dir Directory, name string) ! {
	mut found := false
	mut found_id := u32(0)
	mut found_idx := 0

	for i, child_id in dir.children {
		if entry := fs.load_entry(child_id) {
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
	fs.db_data.delete(found_id) or { return error('Failed to delete entry: ${err}') }

	// Update children list
	dir.children.delete(found_idx)
	fs.save_entry(dir)!
}

pub struct MoveDirArgs {
pub mut:
	src_entry_name string     @[required] // source entry name
	dst_entry_name string     @[required] // destination entry name
	dst_parent_dir &Directory @[required] // destination OurDBFSDirectory
}

pub fn (mut fs DatabaseVFS) directory_move(dir_ Directory, args_ MoveDirArgs) !&Directory {
	mut dir := dir_
	mut args := args_
	mut found := false

	for child_id in dir.children {
		if mut entry := fs.load_entry(child_id) {
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
				entry_.metadata.modified()
				entry_.parent_id = args.dst_parent_dir.metadata.id

				// Remove from old parent's children
				dir.children = dir.children.filter(it != child_id)
				fs.save_entry(dir)!

				// Recursively update all child paths in moved directory
				fs.move_children_recursive(mut entry_)!

				// Ensure no duplicate entries in dst_parent_dir
				if entry_.metadata.id !in args.dst_parent_dir.children {
					args.dst_parent_dir.children << entry_.metadata.id
				}

				fs.save_entry(entry_)!
				fs.save_entry(args.dst_parent_dir)!

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
fn (mut fs DatabaseVFS) move_children_recursive(mut dir Directory) ! {
	for child in dir.children {
		if mut child_entry := fs.load_entry(child) {
			child_entry.parent_id = dir.metadata.id

			if child_entry is Directory {
				// Recursively move subdirectories
				mut child_entry_ := child_entry as Directory
				fs.move_children_recursive(mut child_entry_)!
			}

			fs.save_entry(child_entry)!
		}
	}
}

pub struct CopyDirArgs {
pub mut:
	src_entry_name string     @[required] // source entry name
	dst_entry_name string     @[required] // destination entry name
	dst_parent_dir &Directory @[required] // destination Directory
}

pub fn (mut fs DatabaseVFS) directory_copy(mut dir Directory, args_ CopyDirArgs) !&Directory {
	mut found := false
	mut args := args_

	for child_id in dir.children {
		if mut entry := fs.load_entry(child_id) {
			if entry.metadata.name == args.src_entry_name {
				if entry is File {
					return error('${args.src_entry_name} is a file, not a directory')
				}

				if entry is Symlink {
					return error('${args.src_entry_name} is a symlink, not a directory')
				}

				found = true
				mut src_dir := entry as Directory

				// Create a new directory with copied metadata
				mut new_dir := fs.copy_directory(Directory{
					...src_dir
					metadata:  vfs.Metadata{
						...src_dir.metadata
						name: args.dst_entry_name
					}
					parent_id: args.dst_parent_dir.metadata.id
				})!

				// Recursively copy children
				fs.copy_children_recursive(mut src_dir, mut new_dir)!

				// Save new directory
				fs.save_entry(new_dir)!
				args.dst_parent_dir.children << new_dir.metadata.id
				fs.save_entry(args.dst_parent_dir)!
				return new_dir
			}
		}
	}

	if !found {
		return error('${args.src_entry_name} not found')
	}

	return error('Unexpected copy failure')
}

fn (mut fs DatabaseVFS) copy_children_recursive(mut src_dir Directory, mut dst_dir Directory) ! {
	for child_id in src_dir.children {
		if mut entry := fs.load_entry(child_id) {
			match entry {
				Directory {
					mut entry_ := entry as Directory
					mut new_subdir := fs.copy_directory(Directory{
						...entry_
						children:  []u32{}
						parent_id: dst_dir.metadata.id
					})!

					fs.copy_children_recursive(mut entry_, mut new_subdir)!
					fs.save_entry(new_subdir)!
					dst_dir.children << new_subdir.metadata.id
				}
				File {
					mut entry_ := entry as File
					mut new_file := fs.copy_file(File{
						...entry_
						parent_id: dst_dir.metadata.id
					})!
					dst_dir.children << new_file.metadata.id
				}
				Symlink {
					mut entry_ := entry as Symlink
					mut new_symlink := Symlink{
						metadata:  fs.new_metadata(
							name:      entry_.metadata.name
							file_type: .symlink
							size:      u64(0)
							mode:      entry_.metadata.mode
							owner:     entry_.metadata.owner
							group:     entry_.metadata.group
						)
						target:    entry_.target
						parent_id: dst_dir.metadata.id
					}
					fs.save_entry(new_symlink)!
					dst_dir.children << new_symlink.metadata.id
				}
			}
		}
	}

	fs.save_entry(dst_dir)!
}

pub fn (mut fs DatabaseVFS) directory_rename(dir Directory, src_name string, dst_name string) !&Directory {
	mut found := false
	mut dir_ := dir

	for child_id in dir.children {
		if mut entry := fs.load_entry(child_id) {
			if entry.metadata.name == src_name {
				found = true
				entry.metadata.name = dst_name
				entry.metadata.modified()
				fs.save_entry(entry)!
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
pub fn (mut fs DatabaseVFS) directory_children(mut dir Directory, recursive bool) ![]FSEntry {
	mut entries := []FSEntry{}
	for child_id in dir.children {
		entry := fs.load_entry(child_id)!
		entries << entry
		if recursive {
			if entry is Directory {
				mut d := entry
				entries << fs.directory_children(mut d, true)!
			}
		}
	}

	return entries
}

// pub fn (mut dir Directory) delete() ! {
// 	// Delete all children first
// 	for child_id in dir.children {
// 		dir.myvfs.delete_entry(child_id) or {}
// 	}

// 	// Clear children list
// 	dir.children.clear()

// 	// Save the updated directory
// 	dir.myvfs.save_entry(dir) or { return error('Failed to save directory: ${err}') }
// }

// add_symlink adds an existing symlink to this directory
pub fn (mut fs DatabaseVFS) directory_add_symlink(mut dir Directory, mut symlink Symlink) ! {
	// Check if name already exists
	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			if entry.metadata.name == symlink.metadata.name {
				return error('Entry with name ${symlink.metadata.name} already exists')
			}
		}
	}

	// Save symlink to DB
	fs.save_entry(symlink)!

	// Add to children
	dir.children << symlink.metadata.id
	fs.save_entry(dir)!
}
