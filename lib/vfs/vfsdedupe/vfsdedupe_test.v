module vfsdedupe

import os
import time
import freeflowuniverse.herolib.lib.vfs.vfscore
import freeflowuniverse.herolib.lib.data.dedupestor
import freeflowuniverse.herolib.lib.data.ourdb

fn testsuite_begin() {
	os.rmdir_all('testdata/vfsdedupe') or {}
	os.mkdir_all('testdata/vfsdedupe') or {}
}

fn test_deduplication() {
	mut vfs := new('testdata/vfsdedupe')!

	// Create test files with same content
	content1 := 'Hello, World!'.bytes()
	content2 := 'Hello, World!'.bytes() // Same content
	content3 := 'Different content'.bytes()

	// Create files
	file1 := vfs.file_create('/file1.txt')!
	file2 := vfs.file_create('/file2.txt')!
	file3 := vfs.file_create('/file3.txt')!

	// Write same content to file1 and file2
	vfs.file_write('/file1.txt', content1)!
	vfs.file_write('/file2.txt', content2)!
	vfs.file_write('/file3.txt', content3)!

	// Read back and verify content
	read1 := vfs.file_read('/file1.txt')!
	read2 := vfs.file_read('/file2.txt')!
	read3 := vfs.file_read('/file3.txt')!

	assert read1 == content1
	assert read2 == content2
	assert read3 == content3

	// Verify deduplication by checking internal state
	meta1 := vfs.get_metadata_by_path('/file1.txt')!
	meta2 := vfs.get_metadata_by_path('/file2.txt')!
	meta3 := vfs.get_metadata_by_path('/file3.txt')!

	// Files with same content should have same hash
	assert meta1.hash == meta2.hash
	assert meta1.hash != meta3.hash

	// Test copy operation maintains deduplication
	vfs.copy('/file1.txt', '/file1_copy.txt')!
	meta_copy := vfs.get_metadata_by_path('/file1_copy.txt')!
	assert meta_copy.hash == meta1.hash

	// Test modifying copy creates new hash
	vfs.file_write('/file1_copy.txt', 'Modified content'.bytes())!
	meta_copy_modified := vfs.get_metadata_by_path('/file1_copy.txt')!
	assert meta_copy_modified.hash != meta1.hash
}

fn test_basic_operations() {
	mut vfs := new('testdata/vfsdedupe')!

	// Test directory operations
	dir := vfs.dir_create('/testdir')!
	assert dir.is_dir()
	
	subdir := vfs.dir_create('/testdir/subdir')!
	assert subdir.is_dir()

	// Test file operations with deduplication
	content := 'Test content'.bytes()
	
	file1 := vfs.file_create('/testdir/file1.txt')!
	assert file1.is_file()
	vfs.file_write('/testdir/file1.txt', content)!

	file2 := vfs.file_create('/testdir/file2.txt')!
	assert file2.is_file()
	vfs.file_write('/testdir/file2.txt', content)! // Same content

	// Verify deduplication
	meta1 := vfs.get_metadata_by_path('/testdir/file1.txt')!
	meta2 := vfs.get_metadata_by_path('/testdir/file2.txt')!
	assert meta1.hash == meta2.hash

	// Test listing
	entries := vfs.dir_list('/testdir')!
	assert entries.len == 3 // subdir, file1.txt, file2.txt

	// Test deletion
	vfs.file_delete('/testdir/file1.txt')!
	assert !vfs.exists('/testdir/file1.txt')
	
	// Verify file2 still works after file1 deletion
	read2 := vfs.file_read('/testdir/file2.txt')!
	assert read2 == content

	// Clean up
	vfs.dir_delete('/testdir/subdir')!
	vfs.file_delete('/testdir/file2.txt')!
	vfs.dir_delete('/testdir')!
}

fn testsuite_end() {
	os.rmdir_all('testdata/vfsdedupe') or {}
}
