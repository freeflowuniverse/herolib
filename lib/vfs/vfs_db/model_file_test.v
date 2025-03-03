module vfs_db

import freeflowuniverse.herolib.vfs
import os
import freeflowuniverse.herolib.data.ourdb
import rand

fn setup_vfs() !&DatabaseVFS {
	test_data_dir := os.join_path(os.temp_dir(), 'vfsourdb_model_file_test_${rand.string(3)}')
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

fn test_file_get_metadata() {
	// Create a file with metadata
	metadata := vfs.Metadata{
		id: 1
		name: 'test_file.txt'
		file_type: .file
		size: 13
		mode: 0o644
		owner: 'user'
		group: 'user'
		created: 0
		modified: 0
	}
	
	file := File{
		metadata: metadata
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Test get_metadata
	retrieved_metadata := file.get_metadata()
	assert retrieved_metadata.id == 1
	assert retrieved_metadata.name == 'test_file.txt'
	assert retrieved_metadata.file_type == .file
	assert retrieved_metadata.size == 13
	assert retrieved_metadata.mode == 0o644
	assert retrieved_metadata.owner == 'user'
	assert retrieved_metadata.group == 'user'
}

fn test_file_get_path() {
	// Create a file with metadata
	metadata := vfs.Metadata{
		id: 1
		name: 'test_file.txt'
		file_type: .file
		size: 13
		mode: 0o644
		owner: 'user'
		group: 'user'
		created: 0
		modified: 0
	}
	
	file := File{
		metadata: metadata
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Test get_path
	path := file.get_path()
	assert path == 'test_file.txt'
}

fn test_file_is_file() {
	// Create a file with metadata
	metadata := vfs.Metadata{
		id: 1
		name: 'test_file.txt'
		file_type: .file
		size: 13
		mode: 0o644
		owner: 'user'
		group: 'user'
		created: 0
		modified: 0
	}
	
	file := File{
		metadata: metadata
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Test is_file
	assert file.is_file() == true
	assert file.is_dir() == false
	assert file.is_symlink() == false
}

fn test_file_write_read() {
	// Create a file with metadata
	metadata := vfs.Metadata{
		id: 1
		name: 'test_file.txt'
		file_type: .file
		size: 13
		mode: 0o644
		owner: 'user'
		group: 'user'
		created: 0
		modified: 0
	}
	
	mut file := File{
		metadata: metadata
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Test read
	content := file.read()
	assert content == 'Hello, World!'
	
	// Test write
	file.write('New content')
	assert file.data == 'New content'
	assert file.metadata.size == 11 // 'New content'.len
	
	// Test read after write
	new_content := file.read()
	assert new_content == 'New content'
}

fn test_file_rename() {
	// Create a file with metadata
	metadata := vfs.Metadata{
		id: 1
		name: 'test_file.txt'
		file_type: .file
		size: 13
		mode: 0o644
		owner: 'user'
		group: 'user'
		created: 0
		modified: 0
	}
	
	mut file := File{
		metadata: metadata
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Test rename
	file.rename('renamed_file.txt')
	assert file.metadata.name == 'renamed_file.txt'
}

fn test_new_file() ! {
	mut vfs := setup_vfs()!
	
	// Test creating a new file
	mut file := vfs.new_file(
		name: 'test_file.txt'
		data: 'Hello, World!'
	)!
	
	// Verify the file
	assert file.metadata.name == 'test_file.txt'
	assert file.metadata.file_type == .file
	assert file.metadata.size == 13
	assert file.metadata.mode == 0o644
	assert file.metadata.owner == 'user'
	assert file.metadata.group == 'user'
	assert file.data == 'Hello, World!'
}

fn test_copy_file() ! {
	mut vfs := setup_vfs()!
	
	// Create a file to copy
	original_file := File{
		metadata: vfs.Metadata{
			id: 1
			name: 'original.txt'
			file_type: .file
			size: 13
			mode: 0o755
			owner: 'admin'
			group: 'staff'
			created: 0
			modified: 0
		}
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Test copying the file
	copied_file := vfs.copy_file(original_file)!
	
	// Verify the copied file
	assert copied_file.metadata.name == 'original.txt'
	assert copied_file.metadata.file_type == .file
	assert copied_file.metadata.size == 13
	assert copied_file.metadata.mode == 0o755
	assert copied_file.metadata.owner == 'admin'
	assert copied_file.metadata.group == 'staff'
	assert copied_file.data == 'Hello, World!'
	assert copied_file.metadata.id != original_file.metadata.id // Should have a new ID
}
