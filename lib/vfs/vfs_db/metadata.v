module vfs_db

import time
import freeflowuniverse.herolib.vfs

// Metadata represents the common metadata for both files and directories
pub struct NewMetadata {
pub mut:
	name      string       @[required] // name of file or directory
	path      string       @[required] // name of file or directory
	file_type vfs.FileType @[required]
	size      u64          @[required]
	mode      u32    = 0o644 // file permissions
	owner     string = 'user'
	group     string = 'user'
}

pub fn (mut fs DatabaseVFS) new_metadata(metadata NewMetadata) vfs.Metadata {
	return vfs.new_metadata(
		id:        fs.get_next_id()
		name:      metadata.name
		path:      metadata.path
		file_type: metadata.file_type
		size:      metadata.size
		mode:      metadata.mode
		owner:     metadata.owner
		group:     metadata.group
	)
}
