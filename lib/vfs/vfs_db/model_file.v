module vfs_db

import freeflowuniverse.herolib.vfs

// File represents a file in the virtual filesystem
pub struct File {
pub mut:
	metadata  vfs.Metadata // vfs.Metadata from models_common.v
	data      string       // File content stored in DB
	parent_id u32          // ID of parent directory
}

// write updates the file's content and returns updated file
pub fn (mut file File) write(content string) {
	file.data = content
	file.metadata.size = u64(content.len)
	file.metadata.modified()
}

// Rename the file
fn (mut f File) rename(name string) {
	f.metadata.name = name
}

// read returns the file's content
pub fn (mut f File) read() string {
	return f.data
}

fn (f &File) get_metadata() vfs.Metadata {
	return f.metadata
}

fn (f &File) get_path() string {
	return '/${f.metadata.name.trim_string_left('/')}'
}

// is_dir returns true if the entry is a directory
pub fn (f &File) is_dir() bool {
	return f.metadata.file_type == .directory
}

// is_file returns true if the entry is a file
pub fn (f &File) is_file() bool {
	return f.metadata.file_type == .file
}

// is_symlink returns true if the entry is a symlink
pub fn (f &File) is_symlink() bool {
	return f.metadata.file_type == .symlink
}

pub struct NewFile {
pub:
	name      string @[required] // name of file or directory
	path      string @[required] // path of file or directory
	data      string
	mode      u32    = 0o644 // file permissions
	owner     string = 'user'
	group     string = 'user'
	parent_id u32
}

// mkdir creates a new directory with default permissions
pub fn (mut fs DatabaseVFS) new_file(file NewFile) !&File {
	f := File{
		data:     file.data
		parent_id: file.parent_id
		metadata: fs.new_metadata(NewMetadata{
			name:      file.name
			path:      file.path
			mode:      file.mode
			owner:     file.owner
			group:     file.group
			size:      u64(file.data.len)
			file_type: .file
		})
	}

	// Save new directory to DB
	fs.save_entry(f)!
	return &f
}

// mkdir creates a new directory with default permissions
pub fn (mut fs DatabaseVFS) copy_file(file File) !&File {
	return fs.new_file(
		data:  file.data
		name:  file.metadata.name
		path:  file.metadata.path
		mode:  file.metadata.mode
		owner: file.metadata.owner
		group: file.metadata.group
		parent_id: file.parent_id
	)
}
