module vfs_db

import freeflowuniverse.herolib.vfs

// FSEntry represents any type of filesystem entry
pub type FSEntry = Directory | File | Symlink

fn (e &FSEntry) get_metadata() vfs.Metadata {
	return e.metadata
}

fn (e &FSEntry) get_path() string {
	return e.metadata.path
}

fn (e &FSEntry) is_dir() bool {
	return e.metadata.file_type == .directory
}

fn (e &FSEntry) is_file() bool {
	return e.metadata.file_type == .file
}

fn (e &FSEntry) is_symlink() bool {
	return e.metadata.file_type == .symlink
}
