module vfsourdb

import os
import rand

fn setup_vfs() !(&OurDBVFS, string, string) {
	test_data_dir := os.join_path(os.temp_dir(), 'vfsourdb_test_data_${rand.string(3)}')
	test_meta_dir := os.join_path(os.temp_dir(), 'vfsourdb_test_meta_${rand.string(3)}')

	os.mkdir_all(test_data_dir)!
	os.mkdir_all(test_meta_dir)!

	mut vfs := new(test_data_dir, test_meta_dir)!
	return vfs, test_data_dir, test_meta_dir
}

fn teardown_vfs(data_dir string, meta_dir string) {
	os.rmdir_all(data_dir) or {}
	os.rmdir_all(meta_dir) or {}
}

fn test_root_directory() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	mut root := vfs.root_get()!
	assert root.get_metadata().file_type == .directory
	assert root.get_metadata().name == ''
}

fn test_directory_operations() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	// Test creation
	mut test_dir := vfs.dir_create('/test_dir')!
	assert test_dir.get_metadata().name == 'test_dir'
	assert test_dir.get_metadata().file_type == .directory

	// Test listing
	entries := vfs.dir_list('/')!
	assert entries.any(it.get_metadata().name == 'test_dir')
}

fn test_file_operations() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	vfs.dir_create('/test_dir')!

	// Test file creation
	mut test_file := vfs.file_create('/test_dir/test.txt')!
	assert test_file.get_metadata().name == 'test.txt'
	assert test_file.get_metadata().file_type == .file

	// Test writing/reading
	test_content := 'Hello, World!'.bytes()
	vfs.file_write('/test_dir/test.txt', test_content)!
	assert vfs.file_read('/test_dir/test.txt')! == test_content
}

fn test_directory_move() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	vfs.dir_create('/test_dir')!
	vfs.file_create('/test_dir/test.txt')!

	// Perform move
	moved_dir := vfs.move('/test_dir', '/test_dir2')!
	assert moved_dir.get_metadata().name == 'test_dir2'
	assert vfs.exists('/test_dir') == false
	assert vfs.exists('/test_dir2/test.txt') == true
}

fn test_directory_copy() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	vfs.dir_create('/test_dir')!
	vfs.file_create('/test_dir/test.txt')!

	// Perform copy
	copied_dir := vfs.copy('/test_dir', '/test_dir2')!
	assert copied_dir.get_metadata().name == 'test_dir2'
	assert vfs.exists('/test_dir') == true
	assert vfs.exists('/test_dir/test.txt') == true
	assert vfs.exists('/test_dir2/test.txt') == true
}

fn test_nested_directory_move() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	vfs.dir_create('/test_dir2')!
	vfs.dir_create('/test_dir2/folder1')!
	vfs.file_create('/test_dir2/folder1/file1.txt')!
	vfs.dir_create('/test_dir2/folder2')!

	// Move folder1 into folder2
	moved_dir := vfs.move('/test_dir2/folder1', '/test_dir2/folder2/folder1')!
	assert moved_dir.get_metadata().name == 'folder1'
	assert vfs.exists('/test_dir2/folder2/folder1/file1.txt') == true
}

fn test_deletion_operations() ! {
	mut vfs, data_dir, meta_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir, meta_dir)
	}

	vfs.dir_create('/test_dir')!
	vfs.file_create('/test_dir/test.txt')!

	// Test file deletion
	vfs.file_delete('/test_dir/test.txt')!
	assert vfs.exists('/test_dir/test.txt') == false

	// Test directory deletion
	vfs.dir_delete('/test_dir')!
	assert vfs.exists('/test_dir') == false
}

// Add more test functions for other operations like:
// - test_directory_copy()
// - test_symlink_operations()
// - test_directory_rename()
// - test_file_metadata()
