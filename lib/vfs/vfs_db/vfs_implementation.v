module vfs_db

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.core.texttools
import log
import os
import time

// Implementation of VFSImplementation interface
pub fn (mut fs DatabaseVFS) root_get() !vfs.FSEntry {
	return fs.root_get_as_dir()!
}

pub fn (mut self DatabaseVFS) file_create(path_ string) !vfs.FSEntry {
	path := '/${path_.trim_left('/').trim_right('/')}'
	log.info('[DatabaseVFS] Creating file ${path}')
	// Get parent directory
	parent_path := os.dir(path)
	file_name := os.base(path)

	mut parent_dir := self.get_directory(parent_path)!
	return self.directory_touch(parent_dir, file_name)!
}

pub fn (mut self DatabaseVFS) file_read(path_ string) ![]u8 {
	path := '/${path_.trim_left('/').trim_right('/')}'
	log.info('[DatabaseVFS] Reading file ${path}')
	mut entry := self.get_entry(path)!
	if mut entry is File {
		return entry.read().bytes()
	}
	return error('Not a file: ${path}')
}

pub fn (mut self DatabaseVFS) file_write(path_ string, data []u8) ! {
	log.info('[DatabaseVFS] Writing file ${path_}')
	path := '/${path_.trim_left('/').trim_right('/')}'
	if mut entry := self.get_entry(path) {
		if mut entry is File {
			log.info('[DatabaseVFS] Writing to file ${path}')
			entry.write(data.bytestr())
			self.save_entry(entry)!
		} else {
			panic('handle error')
		}
	} else {	
		self.file_create(path)!
		self.file_write(path, data)!
	}
}

pub fn (mut self DatabaseVFS) file_delete(path string) ! {
	log.info('[DatabaseVFS] Deleting file ${path}')
	parent_path := os.dir(path)
	file_name := os.base(path)

	mut parent_dir := self.get_directory(parent_path)!
	self.directory_rm(mut parent_dir, file_name)!
}

pub fn (mut self DatabaseVFS) dir_create(path_ string) !vfs.FSEntry {
	path := '/${path_.trim_left('/').trim_right('/')}'
	log.info('[DatabaseVFS] Creating Directory ${path}')
	parent_path := os.dir(path)
	file_name := os.base(path)
	mut parent_dir := self.get_directory(parent_path)!
	return self.directory_mkdir(mut parent_dir, file_name)!
}

pub fn (mut self DatabaseVFS) dir_list(path string) ![]vfs.FSEntry {
	log.info('[DatabaseVFS] Listing Directory ${path}')
	mut dir := self.get_directory(path)!
	mut entries := []vfs.FSEntry{}
	for child in self.directory_children(mut dir, false)! {
		if child is File {
			entries << vfs.FSEntry(child)
		} else if child is Directory {
			entries << vfs.FSEntry(child)
		} else if child is Symlink {
			entries << vfs.FSEntry(child)
		}
	}
	return entries
}

pub fn (mut self DatabaseVFS) dir_delete(path string) ! {
	log.info('[DatabaseVFS] Deleting Directory ${path}')
	parent_path := os.dir(path)
	dir_name := os.base(path)

	mut parent_dir := self.get_directory(parent_path)!
	self.directory_rm(mut parent_dir, dir_name)!
}

pub fn (mut self DatabaseVFS) link_create(target_path string, link_path string) !vfs.FSEntry {
	log.info('[DatabaseVFS] Creating link ${target_path}')
	parent_path := os.dir(link_path)
	link_name := os.base(link_path)

	mut parent_dir := self.get_directory(parent_path)!

	mut symlink := Symlink{
		metadata:  vfs.Metadata{
			id:          self.get_next_id()
			name:        link_name
			path:        link_path
			file_type:   .symlink
			created_at:  time.now().unix()
			modified_at: time.now().unix()
			accessed_at: time.now().unix()
			mode:        0o777
			owner:       'user'
			group:       'user'
		}
		target:    target_path
		parent_id: parent_dir.metadata.id
	}

	self.directory_add_symlink(mut parent_dir, mut symlink)!
	return symlink
}

pub fn (mut self DatabaseVFS) link_read(path string) !string {
	log.info('[DatabaseVFS] Reading link ${path}')
	mut entry := self.get_entry(path)!
	if mut entry is Symlink {
		return entry.get_target()!
	}
	return error('Not a symlink: ${path}')
}

pub fn (mut self DatabaseVFS) link_delete(path string) ! {
	log.info('[DatabaseVFS] Deleting link ${path}')
	parent_path := os.dir(path)
	file_name := os.base(path)

	mut parent_dir := self.get_directory(parent_path)!
	self.directory_rm(mut parent_dir, file_name)!
}

pub fn (mut self DatabaseVFS) exists(path_ string) bool {
	path := if !path_.starts_with('/') {
		'/${path_}'
	} else {
		path_
	}
	if path == '/' {
		return true
	}
	// self.print() or {panic(err)}
	log.info('[DatabaseVFS] Checking path exists ${path}')
	self.get_entry(path) or { return false }
	return true
}

pub fn (mut fs DatabaseVFS) get(path string) !vfs.FSEntry {
	log.info('[DatabaseVFS] Getting filesystem entry ${path}')
	return fs.get_entry(path)!
}

pub fn (mut self DatabaseVFS) rename(old_path string, new_path string) !vfs.FSEntry {
	log.info('[DatabaseVFS] Renaming ${old_path} to ${new_path}')
	src_parent_path := os.dir(old_path)
	src_name := os.base(old_path)
	dst_name := os.base(new_path)

	mut src_parent_dir := self.get_directory(src_parent_path)!
	return self.directory_rename(src_parent_dir, src_name, dst_name)!
}

pub fn (mut self DatabaseVFS) copy(src_path string, dst_path string) !vfs.FSEntry {
	log.info('[DatabaseVFS] Copying ${src_path} to ${dst_path}')
	src_parent_path := os.dir(src_path)
	dst_parent_path := os.dir(dst_path)

	if !self.exists(src_parent_path) {
		return error('${src_parent_path} does not exist')
	}

	if !self.exists(dst_parent_path) {
		return error('${dst_parent_path} does not exist')
	}

	src_name := os.base(src_path)
	dst_name := os.base(dst_path)

	mut src_parent_dir := self.get_directory(src_parent_path)!
	mut dst_parent_dir := self.get_directory(dst_parent_path)!

	if src_parent_dir == dst_parent_dir && src_name == dst_name {
		return error('Moving to the same path not supported')
	}

	return self.directory_copy(mut src_parent_dir,
		src_entry_name: src_name
		dst_entry_name: dst_name
		dst_parent_dir: dst_parent_dir
	)!
}

pub fn (mut self DatabaseVFS) move(src_path string, dst_path string) !vfs.FSEntry {
	log.info('[DatabaseVFS] Moving ${src_path} to ${dst_path}')
	
	src_parent_path := os.dir(src_path)
	dst_parent_path := os.dir(dst_path)

	if !self.exists(src_parent_path) {
		return error('${src_parent_path} does not exist')
	}

	if !self.exists(dst_parent_path) {
		return error('${dst_parent_path} does not exist')
	}

	src_name := os.base(src_path)
	dst_name := os.base(dst_path)

	mut src_parent_dir := self.get_directory(src_parent_path)!
	mut dst_parent_dir := self.get_directory(dst_parent_path)!

	if src_parent_dir == dst_parent_dir && src_name == dst_name {
		return error('Moving to the same path not supported')
	}

	return self.directory_move(src_parent_dir,
		src_entry_name: src_name
		dst_entry_name: dst_name
		dst_parent_dir: dst_parent_dir
	)!
}

pub fn (mut self DatabaseVFS) delete(path string) ! {
	// TODO: implement
}

pub fn (mut self DatabaseVFS) destroy() ! {
	// Nothing to do as the core VFS handles cleanup
}
