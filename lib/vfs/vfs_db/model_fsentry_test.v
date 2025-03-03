module vfs_db

import freeflowuniverse.herolib.vfs

fn test_fsentry_directory() {
	// Create a directory entry
	dir := Directory{
		metadata: vfs.Metadata{
			id: 1
			name: 'test_dir'
			file_type: .directory
			size: 0
			mode: 0o755
			owner: 'user'
			group: 'user'
			created: 0
			modified: 0
		}
		children: []
		parent_id: 0
	}
	
	// Convert to FSEntry
	entry := FSEntry(dir)
	
	// Test methods
	assert entry.get_metadata().id == 1
	assert entry.get_metadata().name == 'test_dir'
	assert entry.get_metadata().file_type == .directory
	assert entry.get_path() == 'test_dir'
	assert entry.is_dir() == true
	assert entry.is_file() == false
	assert entry.is_symlink() == false
}

fn test_fsentry_file() {
	// Create a file entry
	file := File{
		metadata: vfs.Metadata{
			id: 2
			name: 'test_file.txt'
			file_type: .file
			size: 13
			mode: 0o644
			owner: 'user'
			group: 'user'
			created: 0
			modified: 0
		}
		data: 'Hello, World!'
		parent_id: 0
	}
	
	// Convert to FSEntry
	entry := FSEntry(file)
	
	// Test methods
	assert entry.get_metadata().id == 2
	assert entry.get_metadata().name == 'test_file.txt'
	assert entry.get_metadata().file_type == .file
	assert entry.get_path() == 'test_file.txt'
	assert entry.is_dir() == false
	assert entry.is_file() == true
	assert entry.is_symlink() == false
}

fn test_fsentry_symlink() {
	// Create a symlink entry
	symlink := Symlink{
		metadata: vfs.Metadata{
			id: 3
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
		parent_id: 0
	}
	
	// Convert to FSEntry
	entry := FSEntry(symlink)
	
	// Test methods
	assert entry.get_metadata().id == 3
	assert entry.get_metadata().name == 'test_link'
	assert entry.get_metadata().file_type == .symlink
	assert entry.get_path() == 'test_link'
	assert entry.is_dir() == false
	assert entry.is_file() == false
	assert entry.is_symlink() == true
}

fn test_fsentry_match() {
	// Create entries of different types
	dir := Directory{
		metadata: vfs.Metadata{
			id: 1
			name: 'test_dir'
			file_type: .directory
			size: 0
			mode: 0o755
			owner: 'user'
			group: 'user'
			created: 0
			modified: 0
		}
		children: []
		parent_id: 0
	}
	
	file := File{
		metadata: vfs.Metadata{
			id: 2
			name: 'test_file.txt'
			file_type: .file
			size: 13
			mode: 0o644
			owner: 'user'
			group: 'user'
			created: 0
			modified: 0
		}
		data: 'Hello, World!'
		parent_id: 0
	}
	
	symlink := Symlink{
		metadata: vfs.Metadata{
			id: 3
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
		parent_id: 0
	}
	
	// Test match with directory
	dir_entry := FSEntry(dir)
	match dir_entry {
		Directory {
			assert it.metadata.id == 1
			assert it.metadata.name == 'test_dir'
		}
		File, Symlink {
			assert false, 'Expected Directory type'
		}
	}
	
	// Test match with file
	file_entry := FSEntry(file)
	match file_entry {
		File {
			assert it.metadata.id == 2
			assert it.metadata.name == 'test_file.txt'
			assert it.data == 'Hello, World!'
		}
		Directory, Symlink {
			assert false, 'Expected File type'
		}
	}
	
	// Test match with symlink
	symlink_entry := FSEntry(symlink)
	match symlink_entry {
		Symlink {
			assert it.metadata.id == 3
			assert it.metadata.name == 'test_link'
			assert it.target == '/path/to/target'
		}
		Directory, File {
			assert false, 'Expected Symlink type'
		}
	}
}
