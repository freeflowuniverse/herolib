module vfs

import time

// Metadata represents the common metadata for both files and directories
pub struct Metadata {
pub mut:
	id          u32    @[required] // unique identifier used as key in DB
	name        string @[required] // name of file or directory
	file_type   FileType
	size        u64
	created_at  i64 // unix epoch timestamp
	modified_at i64 // unix epoch timestamp
	accessed_at i64 // unix epoch timestamp
	mode        u32 // file permissions
	owner       string
	group       string
}

// FileType represents the type of a filesystem entry
pub enum FileType {
	file
	directory
	symlink
}

// mkdir creates a new directory with default permissions
pub fn new_metadata(metadata Metadata) Metadata {
	current_time := time.now().unix()
	return Metadata{
		...metadata
		created_at:  current_time
		modified_at: current_time
		accessed_at: current_time
	}
}

// Get time.Time objects from epochs
pub fn (m Metadata) created_time() time.Time {
	return time.unix(m.created_at)
}

pub fn (m Metadata) modified_time() time.Time {
	return time.unix(m.modified_at)
}

pub fn (m Metadata) accessed_time() time.Time {
	return time.unix(m.accessed_at)
}

pub fn (mut m Metadata) modified() {
	m.modified_at = time.now().unix()
}

pub fn (mut m Metadata) accessed() {
	m.accessed_at = time.now().unix()
}
