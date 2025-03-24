module vfs

import time

// VFSImplementation defines the interface that all vfscore implementations must follow
pub interface VFSImplementation {
mut:
	// Basic operations
	root_get() !FSEntry

	// File operations
	file_create(path string) !FSEntry
	file_read(path string) ![]u8
	file_write(path string, data []u8) !
	file_concatenate(path string, data []u8) !
	file_delete(path string) !

	// Directory operations
	dir_create(path string) !FSEntry
	dir_list(path string) ![]FSEntry
	dir_delete(path string) !

	// Symlink operations
	link_create(target_path string, link_path string) !FSEntry
	link_read(path string) !string
	link_delete(path string) !

	// Common operations
	exists(path string) bool
	get(path string) !FSEntry
	rename(old_path string, new_path string) !FSEntry
	copy(src_path string, dst_path string) !FSEntry
	move(src_path string, dst_path string) !FSEntry
	delete(path string) !

	// FSEntry Operations
	get_path(entry &FSEntry) !string
	
	print() !

	// Cleanup operation
	destroy() !
}

// FSEntry represents a filesystem entry (file, directory, or symlink)
pub interface FSEntry {
	get_metadata() Metadata
	// get_path() string
	is_dir() bool
	is_file() bool
	is_symlink() bool
}
