module vfs_db

import os
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.vfs
import rand

fn setup_vfs() !&DatabaseVFS {
	test_data_dir := os.join_path(os.temp_dir(), 'vfsourdb_metadata_test_${rand.string(3)}')
	os.mkdir_all(test_data_dir)!
	
	// Create separate databases for data and metadata
	mut db_data := ourdb.new(
		path: os.join_path(test_data_dir, 'data')
		incremental_mode: false
	)!
	
	mut db_metadata := ourdb.new(
		path: os.join_path(test_data_dir, 'metadata')
		incremental_mode: false
	)!

	// Create VFS with separate databases for data and metadata
	mut vfs := new(mut db_data, mut db_metadata)!
	return vfs
}

fn test_new_metadata_file() ! {
	mut vfs := setup_vfs()!
	
	// Test creating file metadata
	metadata := vfs.new_metadata(
		name: 'test_file.txt'
		file_type: .file
		size: 1024
	)
	
	// Verify the metadata
	assert metadata.name == 'test_file.txt'
	assert metadata.file_type == .file
	assert metadata.size == 1024
	assert metadata.mode == 0o644 // Default mode
	assert metadata.owner == 'user' // Default owner
	assert metadata.group == 'user' // Default group
	assert metadata.id == 1 // First ID
}

fn test_new_metadata_directory() ! {
	mut vfs := setup_vfs()!
	
	// Test creating directory metadata
	metadata := vfs.new_metadata(
		name: 'test_dir'
		file_type: .directory
		size: 0
	)
	
	// Verify the metadata
	assert metadata.name == 'test_dir'
	assert metadata.file_type == .directory
	assert metadata.size == 0
	assert metadata.mode == 0o644 // Default mode
	assert metadata.owner == 'user' // Default owner
	assert metadata.group == 'user' // Default group
	assert metadata.id == 1 // First ID
}

fn test_new_metadata_symlink() ! {
	mut vfs := setup_vfs()!
	
	// Test creating symlink metadata
	metadata := vfs.new_metadata(
		name: 'test_link'
		file_type: .symlink
		size: 0
	)
	
	// Verify the metadata
	assert metadata.name == 'test_link'
	assert metadata.file_type == .symlink
	assert metadata.size == 0
	assert metadata.mode == 0o644 // Default mode
	assert metadata.owner == 'user' // Default owner
	assert metadata.group == 'user' // Default group
	assert metadata.id == 1 // First ID
}

fn test_new_metadata_custom_permissions() ! {
	mut vfs := setup_vfs()!
	
	// Test creating metadata with custom permissions
	metadata := vfs.new_metadata(
		name: 'custom_file.txt'
		file_type: .file
		size: 2048
		mode: 0o755
		owner: 'admin'
		group: 'staff'
	)
	
	// Verify the metadata
	assert metadata.name == 'custom_file.txt'
	assert metadata.file_type == .file
	assert metadata.size == 2048
	assert metadata.mode == 0o755
	assert metadata.owner == 'admin'
	assert metadata.group == 'staff'
	assert metadata.id == 1 // First ID
}

fn test_new_metadata_sequential_ids() ! {
	mut vfs := setup_vfs()!
	
	// Create multiple metadata objects and verify IDs are sequential
	metadata1 := vfs.new_metadata(
		name: 'file1.txt'
		file_type: .file
		size: 100
	)
	assert metadata1.id == 1
	
	metadata2 := vfs.new_metadata(
		name: 'file2.txt'
		file_type: .file
		size: 200
	)
	assert metadata2.id == 2
	
	metadata3 := vfs.new_metadata(
		name: 'file3.txt'
		file_type: .file
		size: 300
	)
	assert metadata3.id == 3
}
