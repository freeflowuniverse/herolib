module vfs_db

import os
import freeflowuniverse.herolib.data.ourdb
import rand

fn setup_vfs() !&DatabaseVFS {
	test_data_dir := os.join_path(os.temp_dir(), 'vfsourdb_id_table_test_${rand.string(3)}')
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

fn test_set_get_database_id() ! {
	mut vfs := setup_vfs()!
	
	// Test setting and getting database IDs
	vfs_id := u32(1)
	db_id := u32(42)
	
	// Set the database ID
	vfs.set_database_id(vfs_id, db_id)!
	
	// Get the database ID and verify it matches
	retrieved_id := vfs.get_database_id(vfs_id)!
	assert retrieved_id == db_id
}

fn test_get_nonexistent_id() ! {
	mut vfs := setup_vfs()!
	
	// Try to get a database ID that doesn't exist
	if _ := vfs.get_database_id(999) {
		assert false, 'Expected error when getting non-existent ID'
	} else {
		assert err.msg() == 'VFS ID 999 not found.'
	}
}

fn test_multiple_ids() ! {
	mut vfs := setup_vfs()!
	
	// Set multiple IDs
	vfs.set_database_id(1, 101)!
	vfs.set_database_id(2, 102)!
	vfs.set_database_id(3, 103)!
	
	// Verify all IDs can be retrieved correctly
	assert vfs.get_database_id(1)! == 101
	assert vfs.get_database_id(2)! == 102
	assert vfs.get_database_id(3)! == 103
}

fn test_update_id() ! {
	mut vfs := setup_vfs()!
	
	// Set an ID
	vfs.set_database_id(1, 100)!
	assert vfs.get_database_id(1)! == 100
	
	// Update the ID
	vfs.set_database_id(1, 200)!
	assert vfs.get_database_id(1)! == 200
}
