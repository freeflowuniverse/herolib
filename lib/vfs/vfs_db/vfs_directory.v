module vfs_db

import freeflowuniverse.herolib.vfs { Metadata }
import time

// mkdir creates a new directory with default permissions
pub fn (mut fs DatabaseVFS) directory_mkdir(mut dir Directory, name_ string) !&Directory {
	name := name_.trim('/')
	// Check if directory already exists
	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			if entry.metadata.name == name {
				return error('Directory ${name} already exists')
			}
		}
	}

	path := if dir.metadata.path == '/' {
		'/${name}'
	} else {
		"/${dir.metadata.path.trim('/')}/${name}"
	}

	new_dir := fs.new_directory(
		name: name, 
		path: path
		parent_id: dir.metadata.id
	)!
	dir.children << new_dir.metadata.id
	fs.save_entry(dir)!
	return new_dir
}

pub struct NewDirectory {
pub:
	name      string @[required] // name of file or directory
	path      string @[required] // name of file or directory
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
			path:      dir.path
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

// copy_directory creates a new directory with the same metadata as the source
pub fn (mut fs DatabaseVFS) copy_directory(dir Directory) !&Directory {
	// Ensure we get a new ID that's different from the original
	mut new_id := fs.get_next_id()
	
	// Make sure the new ID is different from the original
	if new_id == dir.metadata.id {
		new_id = fs.get_next_id() // Get another ID if they happen to be the same
	}
	
	new_dir := Directory{
		metadata: Metadata{
			...dir.metadata
			id: new_id
			created_at: time.now().unix()
			modified_at: time.now().unix()
			accessed_at: time.now().unix()
		}
		children: []u32{}
		parent_id: dir.parent_id
	}
	fs.save_entry(new_dir)!
	return &new_dir
}

// touch creates a new empty file with default permissions
pub fn (mut fs DatabaseVFS) directory_touch(dir_ Directory, name_ string) !&File {
	name := name_.trim('/')
	mut dir := dir_

	// First, make sure we're working with the latest version of the directory
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}

	// Check if file already exists
	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			if entry.metadata.name == name {
				return error('File ${name} already exists')
			}
		}
	}

	path := if dir.metadata.path == '/' {
		'/${name}'
	} else {
		"/${dir.metadata.path.trim('/')}/${name}"
	}
	
	// Create new file with correct parent_id
	mut new_file := fs.new_file(
		parent_id: dir.metadata.id
		name: name
		path: path
	)!
	
	// Ensure parent_id is set correctly
	if new_file.parent_id != dir.metadata.id {
		new_file.parent_id = dir.metadata.id
		fs.save_entry(new_file)!
	}

	// Update children list
	dir.children << new_file.metadata.id
	fs.save_entry(dir)!
	
	// Reload the directory to ensure we have the latest version
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}
	
	return new_file
}

// rm removes a file or directory by name
pub fn (mut fs DatabaseVFS) directory_rm(mut dir Directory, name string) ! {
	mut found := false
	mut found_id := u32(0)
	mut found_idx := 0

	// First, make sure we're working with the latest version of the directory
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}

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

	// get entry from db_metadata
	metadata_bytes := fs.db_metadata.get(fs.get_database_id(found_id)!) or { return error('Failed to delete entry: ${err}') }
	file, data_id := decode_file_metadata(metadata_bytes)!

	if id := data_id {
		// means file has associated data in db_data
		fs.db_data.delete(id)!
	}

	fs.db_metadata.delete(file.metadata.id) or { return error('Failed to delete entry: ${err}') }

	// Update children list - make sure we don't remove the wrong child
	dir.children.delete(found_idx)
	fs.save_entry(dir)!
	
	// Reload the directory to ensure we have the latest version
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}
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
	mut child_id_to_remove := u32(0)

	// First, make sure we're working with the latest version of the directory
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}

	for child_id in dir.children {
		if mut entry := fs.load_entry(child_id) {
			if entry.metadata.name == args.src_entry_name {
				if entry is Symlink {
					return error('${args.src_entry_name} is a symlink')
				}

				found = true
				child_id_to_remove = child_id

				new_path := if args.dst_parent_dir.metadata.path == '/' {
					'/${args.dst_entry_name}'
				} else {
					"/${args.dst_parent_dir.metadata.path.trim('/')}/${args.dst_entry_name}"
				}
				// Handle both files and directories
				if entry is File {
					mut file_entry := entry as File
					file_entry.metadata.name = args.dst_entry_name
					file_entry.metadata.path = new_path
					file_entry.metadata.modified_at = time.now().unix()
					file_entry.parent_id = args.dst_parent_dir.metadata.id

					// Ensure no duplicate entries in dst_parent_dir
					if file_entry.metadata.id !in args.dst_parent_dir.children {
						args.dst_parent_dir.children << file_entry.metadata.id
					}

					// Remove from old parent's children before saving the entry
					dir.children = dir.children.filter(it != child_id_to_remove)
					fs.save_entry(dir)!

					fs.save_entry(file_entry)!
					fs.save_entry(args.dst_parent_dir)!
					
					// Return the destination directory
					return args.dst_parent_dir
				} else {
					// Handle directory
					mut dir_entry := entry as Directory
					dir_entry.metadata.name = args.dst_entry_name
					dir_entry.metadata.path = new_path
					dir_entry.metadata.modified_at = time.now().unix()
					dir_entry.parent_id = args.dst_parent_dir.metadata.id

					// Recursively update all child paths in moved directory
					fs.move_children_recursive(mut dir_entry)!

					// Ensure no duplicate entries in dst_parent_dir
					if dir_entry.metadata.id !in args.dst_parent_dir.children {
						args.dst_parent_dir.children << dir_entry.metadata.id
					}

					// Remove from old parent's children before saving the entry
					dir.children = dir.children.filter(it != child_id_to_remove)
					fs.save_entry(dir)!

					fs.save_entry(dir_entry)!
					fs.save_entry(args.dst_parent_dir)!
					
					return &dir_entry
				}
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
			child_entry.metadata.path = '${dir.metadata.path}/${child_entry.metadata.name}'

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

	// First, make sure we're working with the latest version of the directory
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}

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
				
				// Make sure we have the latest version of the source directory
				if updated_src_dir := fs.load_entry(src_dir.metadata.id) {
					if updated_src_dir is Directory {
						src_dir = updated_src_dir
					}
				}

				// Create a new directory with copied metadata
				mut new_dir := fs.copy_directory(Directory{
					metadata: Metadata{
						...src_dir.metadata
						name: args.dst_entry_name
					}
					parent_id: args.dst_parent_dir.metadata.id
					children: []u32{}
				})!

				// Recursively copy children
				fs.copy_children_recursive(mut src_dir, mut new_dir)!

				// Save new directory
				fs.save_entry(new_dir)!
				args.dst_parent_dir.children << new_dir.metadata.id
				fs.save_entry(args.dst_parent_dir)!
				
				// Make sure to save the source directory too
				fs.save_entry(src_dir)!
				
				// Reload the source directory to ensure we have the latest version
				if updated_src_dir := fs.load_entry(src_dir.metadata.id) {
					if updated_src_dir is Directory {
						src_dir = updated_src_dir
					}
				}
				
				// Reload the parent directory to ensure we have the latest version
				if updated_parent_dir := fs.load_entry(dir.metadata.id) {
					if updated_parent_dir is Directory {
						dir = updated_parent_dir
					}
				}
				
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
						metadata: Metadata{
							...entry_.metadata
							id: fs.get_next_id()
							path: '${dst_dir.metadata.path}/${entry_.metadata.name}'
						}
						children: []u32{}
						parent_id: dst_dir.metadata.id
					})!

					fs.copy_children_recursive(mut entry_, mut new_subdir)!
					fs.save_entry(new_subdir)!
					dst_dir.children << new_subdir.metadata.id
				}
				File {
					mut entry_ := entry as File
					mut new_file := fs.copy_file(File{
						metadata: Metadata{
							...entry_.metadata
							id: fs.get_next_id()
							path: '${dst_dir.metadata.path}/${entry_.metadata.name}'
						}
						data: entry_.data
						parent_id: dst_dir.metadata.id
					})!
					dst_dir.children << new_file.metadata.id
				}
				Symlink {
					mut entry_ := entry as Symlink
					mut new_symlink := Symlink{
						metadata: Metadata{
							...entry_.metadata
							id: fs.get_next_id()
							path: '${dst_dir.metadata.path}/${entry_.metadata.name}'
						}
						target: entry_.target
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

	for child_id in dir.children {
		if mut entry := fs.load_entry(child_id) {
			if entry.metadata.name == src_name {
				if entry is File {
					return error('${src_name} is a file')
				}
				if entry is Symlink {
					return error('${src_name} is a symlink')
				}

				found = true
				mut dir_entry := entry as Directory
				dir_entry.metadata.name = dst_name
				dir_entry.metadata.path = "${dir_entry.metadata.path.all_before_last('/')}/dst_name"
				dir_entry.metadata.modified_at = time.now().unix()
				fs.save_entry(dir_entry)!
				return &dir_entry
			}
		}
	}

	if !found {
		return error('${src_name} not found')
	}

	return error('Unexpected rename failure')
}

// get_children returns all immediate children as FSEntry objects
pub fn (mut fs DatabaseVFS) directory_children(mut dir Directory, recursive bool) ![]FSEntry {
	mut entries := []FSEntry{}
	
	// Make sure we're working with the latest version of the directory
	if updated_dir := fs.load_entry(dir.metadata.id) {
		if updated_dir is Directory {
			dir = updated_dir
		}
	}
	
	for child_id in dir.children {
		if entry := fs.load_entry(child_id) {
			entries << entry
			if recursive && entry is Directory {
				mut d := entry as Directory
				entries << fs.directory_children(mut d, true)!
			}
		}
	}
	return entries.clone()
}

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
