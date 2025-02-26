module vfsdedupe

import freeflowuniverse.herolib.vfs.vfscore
import freeflowuniverse.herolib.data.dedupestor
import freeflowuniverse.herolib.data.ourdb
import os
import time

// Metadata for files and directories
struct Metadata {
pub mut:
	id          u32
	name        string
	file_type   vfscore.FileType
	size        u64
	created_at  i64
	modified_at i64
	accessed_at i64
	parent_id   u32
	hash        string // For files, stores the dedupstore hash. For symlinks, stores target path
}

// Serialization methods for Metadata
pub fn (m Metadata) str() string {
	return '${m.id}|${m.name}|${int(m.file_type)}|${m.size}|${m.created_at}|${m.modified_at}|${m.accessed_at}|${m.parent_id}|${m.hash}'
}

pub fn Metadata.from_str(s string) !Metadata {
	parts := s.split('|')
	if parts.len != 9 {
		return error('Invalid metadata string format')
	}
	return Metadata{
		id: parts[0].u32()
		name: parts[1]
		file_type: unsafe { vfscore.FileType(parts[2].int()) }
		size: parts[3].u64()
		created_at: parts[4].i64()
		modified_at: parts[5].i64()
		accessed_at: parts[6].i64()
		parent_id: parts[7].u32()
		hash: parts[8]
	}
}

// DedupeVFS represents a VFS that uses DedupeStore as the underlying storage
pub struct DedupeVFS {
mut:
	dedup &dedupestor.DedupeStore // For storing file contents
	meta  &ourdb.OurDB           // For storing metadata
}

// new creates a new DedupeVFS instance
pub fn new(data_dir string) !&DedupeVFS {
	dedup := dedupestor.new(
		path: os.join_path(data_dir, 'dedup')
	)!

	meta := ourdb.new(
		path: os.join_path(data_dir, 'meta')
		incremental_mode: true
	)!

	mut vfs := DedupeVFS{
		dedup: dedup
		meta: &meta
	}

	// Create root if it doesn't exist
	if !vfs.exists('/') {
		vfs.create_root()!
	}

	return &vfs
}

fn (mut self DedupeVFS) create_root() ! {
	root_meta := Metadata{
		id: 1
		name: '/'
		file_type: .directory
		created_at: time.now().unix()
		modified_at: time.now().unix()
		accessed_at: time.now().unix()
		parent_id: 0 // Root has no parent
	}
	self.meta.set(id: 1, data: root_meta.str().bytes())!
}

// Implementation of VFSImplementation interface
pub fn (mut self DedupeVFS) root_get() !vfscore.FSEntry {
	root_meta := self.get_metadata(1)!
	return convert_to_vfscore_entry(root_meta)
}

pub fn (mut self DedupeVFS) file_create(path string) !vfscore.FSEntry {
	parent_path := os.dir(path)
	file_name := os.base(path)

	mut parent_meta := self.get_metadata_by_path(parent_path)!
	if parent_meta.file_type != .directory {
		return error('Parent is not a directory: ${parent_path}')
	}

	// Create new file metadata
	id := self.meta.get_next_id() or { return error('Failed to get next id') }
	file_meta := Metadata{
		id: id
		name: file_name
		file_type: .file
		created_at: time.now().unix()
		modified_at: time.now().unix()
		accessed_at: time.now().unix()
		parent_id: parent_meta.id
	}

	self.meta.set(id: id, data: file_meta.str().bytes())!
	return convert_to_vfscore_entry(file_meta)
}

pub fn (mut self DedupeVFS) file_read(path string) ![]u8 {
	mut meta := self.get_metadata_by_path(path)!
	if meta.file_type != .file {
		return error('Not a file: ${path}')
	}
	if meta.hash == '' {
		return []u8{} // Empty file
	}
	return self.dedup.get(meta.hash)!
}

pub fn (mut self DedupeVFS) file_write(path string, data []u8) ! {
	mut meta := self.get_metadata_by_path(path)!
	if meta.file_type != .file {
		return error('Not a file: ${path}')
	}

	// Store data in dedupstore - this will handle deduplication
	hash := self.dedup.store(data)!

	// Update metadata
	meta.hash = hash
	meta.size = u64(data.len)
	meta.modified_at = time.now().unix()
	self.meta.set(id: meta.id, data: meta.str().bytes())!
}

pub fn (mut self DedupeVFS) file_delete(path string) ! {
	self.delete(path)!
}

pub fn (mut self DedupeVFS) dir_create(path string) !vfscore.FSEntry {
	parent_path := os.dir(path)
	dir_name := os.base(path)

	mut parent_meta := self.get_metadata_by_path(parent_path)!
	if parent_meta.file_type != .directory {
		return error('Parent is not a directory: ${parent_path}')
	}

	// Create new directory metadata
	id := self.meta.get_next_id() or { return error('Failed to get next id') }
	dir_meta := Metadata{
		id: id
		name: dir_name
		file_type: .directory
		created_at: time.now().unix()
		modified_at: time.now().unix()
		accessed_at: time.now().unix()
		parent_id: parent_meta.id
	}

	self.meta.set(id: id, data: dir_meta.str().bytes())!
	return convert_to_vfscore_entry(dir_meta)
}

pub fn (mut self DedupeVFS) dir_list(path string) ![]vfscore.FSEntry {
	mut dir_meta := self.get_metadata_by_path(path)!
	if dir_meta.file_type != .directory {
		return error('Not a directory: ${path}')
	}

	mut entries := []vfscore.FSEntry{}
	
	// Iterate through all IDs up to the current max
	max_id := self.meta.get_next_id() or { return error('Failed to get next id') }
	for id in 1 .. max_id {
		meta_bytes := self.meta.get(id) or { continue }
		meta := Metadata.from_str(meta_bytes.bytestr()) or { continue }
		if meta.parent_id == dir_meta.id {
			entries << convert_to_vfscore_entry(meta)
		}
	}

	return entries
}

pub fn (mut self DedupeVFS) dir_delete(path string) ! {
	self.delete(path)!
}

pub fn (mut self DedupeVFS) exists(path string) bool {
	self.get_metadata_by_path(path) or { return false }
	return true
}

pub fn (mut self DedupeVFS) get(path string) !vfscore.FSEntry {
	meta := self.get_metadata_by_path(path)!
	return convert_to_vfscore_entry(meta)
}

pub fn (mut self DedupeVFS) rename(old_path string, new_path string) !vfscore.FSEntry {
	mut meta := self.get_metadata_by_path(old_path)!
	new_parent_path := os.dir(new_path)
	new_name := os.base(new_path)

	mut new_parent_meta := self.get_metadata_by_path(new_parent_path)!
	if new_parent_meta.file_type != .directory {
		return error('New parent is not a directory: ${new_parent_path}')
	}

	meta.name = new_name
	meta.parent_id = new_parent_meta.id
	meta.modified_at = time.now().unix()

	self.meta.set(id: meta.id, data: meta.str().bytes())!
	return convert_to_vfscore_entry(meta)
}

pub fn (mut self DedupeVFS) copy(src_path string, dst_path string) !vfscore.FSEntry {
	mut src_meta := self.get_metadata_by_path(src_path)!
	dst_parent_path := os.dir(dst_path)
	dst_name := os.base(dst_path)

	mut dst_parent_meta := self.get_metadata_by_path(dst_parent_path)!
	if dst_parent_meta.file_type != .directory {
		return error('Destination parent is not a directory: ${dst_parent_path}')
	}

	// Create new metadata with same properties but new ID
	id := self.meta.get_next_id() or { return error('Failed to get next id') }
	new_meta := Metadata{
		id: id
		name: dst_name
		file_type: src_meta.file_type
		size: src_meta.size
		created_at: time.now().unix()
		modified_at: time.now().unix()
		accessed_at: time.now().unix()
		parent_id: dst_parent_meta.id
		hash: src_meta.hash // Reuse same hash since dedupstore deduplicates content
	}

	self.meta.set(id: id, data: new_meta.str().bytes())!
	return convert_to_vfscore_entry(new_meta)
}

pub fn (mut self DedupeVFS) move(src_path string, dst_path string) !vfscore.FSEntry {
	return self.rename(src_path, dst_path)!
}

pub fn (mut self DedupeVFS) delete(path string) ! {
	if path == '/' {
		return error('Cannot delete root directory')
	}

	mut meta := self.get_metadata_by_path(path)!
	
	if meta.file_type == .directory {
		// Check if directory is empty
		children := self.dir_list(path)!
		if children.len > 0 {
			return error('Directory not empty: ${path}')
		}
	}

	self.meta.delete(meta.id)!
}

pub fn (mut self DedupeVFS) link_create(target_path string, link_path string) !vfscore.FSEntry {
	parent_path := os.dir(link_path)
	link_name := os.base(link_path)

	mut parent_meta := self.get_metadata_by_path(parent_path)!
	if parent_meta.file_type != .directory {
		return error('Parent is not a directory: ${parent_path}')
	}

	// Create symlink metadata
	id := self.meta.get_next_id() or { return error('Failed to get next id') }
	link_meta := Metadata{
		id: id
		name: link_name
		file_type: .symlink
		created_at: time.now().unix()
		modified_at: time.now().unix()
		accessed_at: time.now().unix()
		parent_id: parent_meta.id
		hash: target_path // Store target path in hash field for symlinks
	}

	self.meta.set(id: id, data: link_meta.str().bytes())!
	return convert_to_vfscore_entry(link_meta)
}

pub fn (mut self DedupeVFS) link_read(path string) !string {
	mut meta := self.get_metadata_by_path(path)!
	if meta.file_type != .symlink {
		return error('Not a symlink: ${path}')
	}
	return meta.hash // For symlinks, hash field stores target path
}

pub fn (mut self DedupeVFS) link_delete(path string) ! {
	self.delete(path)!
}

pub fn (mut self DedupeVFS) destroy() ! {
	// Nothing to do as the underlying stores handle cleanup
}

// Helper methods
fn (mut self DedupeVFS) get_metadata(id u32) !Metadata {
	meta_bytes := self.meta.get(id)!
	return Metadata.from_str(meta_bytes.bytestr()) or { return error('Failed to parse metadata') }
}

fn (mut self DedupeVFS) get_metadata_by_path(path_ string) !Metadata {
	path := if path_ == '' || path_ == '.' { '/' } else { path_ }

	if path == '/' {
		return self.get_metadata(1)! // Root always has ID 1
	}

	mut current := self.get_metadata(1)! // Start at root
	parts := path.trim_left('/').split('/')

	for part in parts {
		mut found := false
		max_id := self.meta.get_next_id() or { return error('Failed to get next id') }
		
		for id in 1 .. max_id {
			meta_bytes := self.meta.get(id) or { continue }
			meta := Metadata.from_str(meta_bytes.bytestr()) or { continue }
			if meta.parent_id == current.id && meta.name == part {
				current = meta
				found = true
				break
			}
		}

		if !found {
			return error('Path not found: ${path}')
		}
	}

	return current
}

// Convert between internal metadata and vfscore types
fn convert_to_vfscore_entry(meta Metadata) vfscore.FSEntry {
	vfs_meta := vfscore.Metadata{
		id: meta.id
		name: meta.name
		file_type: meta.file_type
		size: meta.size
		created_at: meta.created_at
		modified_at: meta.modified_at
		accessed_at: meta.accessed_at
	}

	match meta.file_type {
		.directory {
			return &DirectoryEntry{
				metadata: vfs_meta
				path: meta.name
			}
		}
		.file {
			return &FileEntry{
				metadata: vfs_meta
				path: meta.name
			}
		}
		.symlink {
			return &SymlinkEntry{
				metadata: vfs_meta
				path: meta.name
				target: meta.hash // For symlinks, hash field stores target path
			}
		}
	}
}

// Entry type implementations
struct DirectoryEntry {
	metadata vfscore.Metadata
	path     string
}

fn (e &DirectoryEntry) get_metadata() vfscore.Metadata {
	return e.metadata
}

fn (e &DirectoryEntry) get_path() string {
	return e.path
}

pub fn (self &DirectoryEntry) is_dir() bool {
	return self.metadata.file_type == .directory
}

pub fn (self &DirectoryEntry) is_file() bool {
	return self.metadata.file_type == .file
}

pub fn (self &DirectoryEntry) is_symlink() bool {
	return self.metadata.file_type == .symlink
}

struct FileEntry {
	metadata vfscore.Metadata
	path     string
}

fn (e &FileEntry) get_metadata() vfscore.Metadata {
	return e.metadata
}

fn (e &FileEntry) get_path() string {
	return e.path
}

pub fn (self &FileEntry) is_dir() bool {
	return self.metadata.file_type == .directory
}

pub fn (self &FileEntry) is_file() bool {
	return self.metadata.file_type == .file
}

pub fn (self &FileEntry) is_symlink() bool {
	return self.metadata.file_type == .symlink
}

struct SymlinkEntry {
	metadata vfscore.Metadata
	path     string
	target   string
}

fn (e &SymlinkEntry) get_metadata() vfscore.Metadata {
	return e.metadata
}

fn (e &SymlinkEntry) get_path() string {
	return e.path
}

pub fn (self &SymlinkEntry) is_dir() bool {
	return self.metadata.file_type == .directory
}

pub fn (self &SymlinkEntry) is_file() bool {
	return self.metadata.file_type == .file
}

pub fn (self &SymlinkEntry) is_symlink() bool {
	return self.metadata.file_type == .symlink
}
