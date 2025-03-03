module vfs_db

import os
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.vfs
import rand

fn setup_vfs() !(&DatabaseVFS, string) {
	test_data_dir := os.join_path(os.temp_dir(), 'vfsourdb_print_test_${rand.string(3)}')
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
	return vfs, test_data_dir
}

fn teardown_vfs(data_dir string) {
	os.rmdir_all(data_dir) or {}
}

fn test_directory_print_empty() ! {
	mut vfs, data_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir)
	}
	
	// Create an empty directory
	mut dir := vfs.new_directory(
		name: 'test_dir'
	)!
	
	// Test printing the empty directory
	output := vfs.directory_print(dir)
	
	// Verify the output
	assert output == 'test_dir/\n'
}

fn test_directory_print_with_contents() ! {
	mut vfs, data_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir)
	}
	
	// Create a directory with various contents
	mut dir := vfs.new_directory(
		name: 'test_dir'
	)!
	
	// Add a subdirectory
	mut subdir := vfs.directory_mkdir(mut dir, 'subdir')!
	
	// Add a file
	mut file := vfs.directory_touch(dir, 'test_file.txt')!
	
	// Add a symlink
	mut symlink := Symlink{
		metadata: vfs.Metadata{
			id: vfs.get_next_id()
			name: 'test_link'
			file_type: .symlink
			size: 0
			mode: 0o777
			owner: 'user'
			group: 'user'
			created: 0
			modified: 0
		}
		target: '/path/to/target'
		parent_id: dir.metadata.id
	}
	vfs.directory_add_symlink(mut dir, mut symlink)!
	
	// Test printing the directory
	output := vfs.directory_print(dir)
	
	// Verify the output contains all entries
	assert output.contains('test_dir/')
	assert output.contains('📁 subdir/')
	assert output.contains('📄 test_file.txt')
	assert output.contains('🔗 test_link -> /path/to/target')
}

fn test_directory_printall_simple() ! {
	mut vfs, data_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir)
	}
	
	// Create a simple directory structure
	mut dir := vfs.new_directory(
		name: 'root_dir'
	)!
	
	// Add a file
	mut file := vfs.directory_touch(dir, 'test_file.txt')!
	
	// Test printing the directory recursively
	output := vfs.directory_printall(dir, '')!
	
	// Verify the output
	assert output.contains('📁 root_dir/')
	assert output.contains('📄 test_file.txt')
}

fn test_directory_printall_nested() ! {
	mut vfs, data_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir)
	}
	
	// Create a nested directory structure
	mut root := vfs.new_directory(
		name: 'root'
	)!
	
	// Add a subdirectory
	mut subdir1 := vfs.directory_mkdir(mut root, 'subdir1')!
	
	// Add a file to the root
	mut root_file := vfs.directory_touch(root, 'root_file.txt')!
	
	// Add a file to the subdirectory
	mut subdir_file := vfs.directory_touch(subdir1, 'subdir_file.txt')!
	
	// Add a nested subdirectory
	mut subdir2 := vfs.directory_mkdir(mut subdir1, 'subdir2')!
	
	// Add a file to the nested subdirectory
	mut nested_file := vfs.directory_touch(subdir2, 'nested_file.txt')!
	
	// Add a symlink to the nested subdirectory
	mut symlink := Symlink{
		metadata: vfs.Metadata{
			id: vfs.get_next_id()
			name: 'test_link'
			file_type: .symlink
			size: 0
			mode: 0o777
			owner: 'user'
			group: 'user'
			created: 0
			modified: 0
		}
		target: '/path/to/target'
		parent_id: subdir2.metadata.id
	}
	vfs.directory_add_symlink(mut subdir2, mut symlink)!
	
	// Test printing the directory recursively
	output := vfs.directory_printall(root, '')!
	
	// Verify the output contains all entries with proper indentation
	assert output.contains('📁 root/')
	assert output.contains('  📄 root_file.txt')
	assert output.contains('  📁 subdir1/')
	assert output.contains('    📄 subdir_file.txt')
	assert output.contains('    📁 subdir2/')
	assert output.contains('      📄 nested_file.txt')
	assert output.contains('      🔗 test_link -> /path/to/target')
}

fn test_directory_printall_empty() ! {
	mut vfs, data_dir := setup_vfs()!
	defer {
		teardown_vfs(data_dir)
	}
	
	// Create an empty directory
	mut dir := vfs.new_directory(
		name: 'empty_dir'
	)!
	
	// Test printing the empty directory recursively
	output := vfs.directory_printall(dir, '')!
	
	// Verify the output
	assert output == '📁 empty_dir/\n'
}
