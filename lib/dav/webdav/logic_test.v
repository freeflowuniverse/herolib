import freeflowuniverse.herolib.dav.webdav
import freeflowuniverse.herolib.vfs.vfs_nested
import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.vfs.vfs_db
import os

fn test_logic() ! {
	println('Testing OurDB VFS Logic to WebDAV Server...')

	// Create test directories
	test_data_dir := os.join_path(os.temp_dir(), 'vfs_db_test_data')
	test_meta_dir := os.join_path(os.temp_dir(), 'vfs_db_test_meta')

	os.mkdir_all(test_data_dir)!
	os.mkdir_all(test_meta_dir)!

	defer {
		os.rmdir_all(test_data_dir) or {}
		os.rmdir_all(test_meta_dir) or {}
	}

	// Create VFS instance; lower level VFS Implementations that use OurDB
	mut vfs1 := vfs_db.new(test_data_dir, test_meta_dir)!

	mut high_level_vfs := vfsnested.new()

	// Nest OurDB VFS instances at different paths
	high_level_vfs.add_vfs('/', vfs1) or { panic(err) }

	// Test directory listing
	entries := high_level_vfs.dir_list('/')!
	assert entries.len == 1 // Data directory

	// // Check if dir is existing
	// assert high_level_vfs.exists('/') == true

	// // Check if dir is not existing
	// assert high_level_vfs.exists('/data') == true
}
