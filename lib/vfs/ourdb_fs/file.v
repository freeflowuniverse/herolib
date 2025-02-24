module ourdb_fs

import time

// File represents a file in the virtual filesystem
pub struct File {
pub mut:
	metadata  Metadata // Metadata from models_common.v
	data      string   // File content stored in DB
	parent_id u32      // ID of parent directory
	myvfs     &OurDBFS @[str: skip]
}

pub fn (mut f File) save() ! {
	f.myvfs.save_entry(f)!
}

// write updates the file's content
pub fn (mut f File) write(content string) ! {
	f.data = content
	f.metadata.size = u64(content.len)
	f.metadata.modified_at = time.now().unix()

	// Save updated file to DB
	f.save()!
}

// Move the file to a new location
pub fn (mut f File) move(mut new_parent Directory) !File {
	f.parent_id = new_parent.metadata.id
	f.save()!
	return f
}

// Copy the file to a new location
pub fn (mut f File) copy(mut new_parent Directory) !File {
	mut new_file := File{
		metadata:  f.metadata
		data:      f.data
		parent_id: new_parent.metadata.id
		myvfs:     f.myvfs
	}
	new_file.save()!
	return new_file
}

// Rename the file
pub fn (mut f File) rename(name string) !File {
	f.metadata.name = name
	f.save()!
	return f
}

// read returns the file's content
pub fn (mut f File) read() !string {
	return f.data
}
