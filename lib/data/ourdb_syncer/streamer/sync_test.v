module ourdb

import encoding.binary

fn test_db_sync() ! {
	// Create two database instances
	mut db1 := new(
		record_nr_max:    16777216 - 1 // max size of records
		record_size_max:  1024
		path:             '/tmp/sync_test_db'
		incremental_mode: false
		reset:            true
	)!
	mut db2 := new(
		record_nr_max:    16777216 - 1 // max size of records
		record_size_max:  1024
		path:             '/tmp/sync_test_db2'
		incremental_mode: false
		reset:            true
	)!

	defer {
		db1.destroy() or { panic('failed to destroy db: ${err}') }
		db2.destroy() or { panic('failed to destroy db: ${err}') }
	}

	// Initial state - both DBs are synced
	db1.set(OurDBSetArgs{ id: 1, data: 'initial data'.bytes() })!
	db2.set(OurDBSetArgs{ id: 1, data: 'initial data'.bytes() })!

	assert db1.get(1)! == 'initial data'.bytes()
	assert db2.get(1)! == 'initial data'.bytes()

	db1.get_last_index()!

	// Make updates to db1
	db1.set(OurDBSetArgs{ id: 2, data: 'second update'.bytes() })!
	db1.set(OurDBSetArgs{ id: 3, data: 'third update'.bytes() })!

	// Verify db1 has the updates
	assert db1.get(2)! == 'second update'.bytes()
	assert db1.get(3)! == 'third update'.bytes()

	// Verify db2 is behind
	assert db1.get_last_index()! == 3
	assert db2.get_last_index()! == 1

	// Sync db2 with updates from db1
	last_synced_index := db2.get_last_index()!
	updates := db1.push_updates(last_synced_index)!
	db2.sync_updates(updates)!

	// Verify db2 is now synced
	assert db2.get_last_index()! == 3
	assert db2.get(2)! == 'second update'.bytes()
	assert db2.get(3)! == 'third update'.bytes()
}

fn test_db_sync_empty_updates() ! {
	mut db1 := new(
		record_nr_max:    16777216 - 1 // max size of records
		record_size_max:  1024
		path:             '/tmp/sync_test_db1_empty'
		incremental_mode: false
	)!
	mut db2 := new(
		record_nr_max:    16777216 - 1 // max size of records
		record_size_max:  1024
		path:             '/tmp/sync_test_db2_empty'
		incremental_mode: false
	)!

	defer {
		db1.destroy() or { panic('failed to destroy db: ${err}') }
		db2.destroy() or { panic('failed to destroy db: ${err}') }
	}

	// Both DBs are at the same index
	db1.set(OurDBSetArgs{ id: 1, data: 'test'.bytes() })!
	db2.set(OurDBSetArgs{ id: 1, data: 'test'.bytes() })!

	last_index := db2.get_last_index()!
	updates := db1.push_updates(last_index)!

	// Should get just the count header (4 bytes with count=0) since DBs are synced
	assert updates.len == 4
	assert binary.little_endian_u32(updates[0..4]) == 0

	db2.sync_updates(updates)!
	assert db2.get_last_index()! == 1
}

fn test_db_sync_invalid_data() ! {
	mut db := new(
		record_nr_max:   16777216 - 1 // max size of records
		record_size_max: 1024
		path:            '/tmp/sync_test_db_invalid'
	)!

	defer {
		db.destroy() or { panic('failed to destroy db: ${err}') }
	}

	// Test with empty data
	if _ := db.sync_updates([]u8{}) {
		assert false, 'should fail with empty data'
	}

	// Test with invalid data length
	invalid_data := []u8{len: 2, init: 0}
	if _ := db.sync_updates(invalid_data) {
		assert false, 'should fail with invalid data length'
	}
}

fn test_get_last_index_incremental() ! {
	mut db := new(
		record_nr_max:    16777216 - 1
		record_size_max:  1024
		path:             '/tmp/sync_test_db_inc'
		incremental_mode: true
		reset:            true
	)!

	defer {
		db.destroy() or { panic('failed to destroy db: ${err}') }
	}

	// Empty database should return 0
	assert db.get_last_index()! == 0

	// Add some records
	db.set(OurDBSetArgs{ data: 'first'.bytes() })! // Auto-assigns ID 0
	assert db.get_last_index()! == 0

	db.set(OurDBSetArgs{ data: 'second'.bytes() })! // Auto-assigns ID 1
	assert db.get_last_index()! == 1

	// Delete a record - should still track highest ID
	db.delete(0)!
	assert db.get_last_index()! == 1
}

fn test_get_last_index_non_incremental() ! {
	mut db := new(
		record_nr_max:    16777216 - 1
		record_size_max:  1024
		path:             '/tmp/sync_test_db_noninc'
		incremental_mode: false
		reset:            true
	)!

	defer {
		db.destroy() or { panic('failed to destroy db: ${err}') }
	}

	// Empty database should return 0
	assert db.get_last_index()! == 0

	// Add records with explicit IDs
	db.set(OurDBSetArgs{ id: 5, data: 'first'.bytes() })!
	assert db.get_last_index()! == 5

	db.set(OurDBSetArgs{ id: 3, data: 'second'.bytes() })!
	assert db.get_last_index()! == 5 // Still 5 since it's highest

	db.set(OurDBSetArgs{ id: 10, data: 'third'.bytes() })!
	assert db.get_last_index()! == 10

	// Delete highest ID - should find next highest
	db.delete(10)!
	assert db.get_last_index()! == 5
}

fn test_sync_edge_cases() ! {
	mut db1 := new(
		record_nr_max:    16777216 - 1
		record_size_max:  1024
		path:             '/tmp/sync_test_db_edge1'
		incremental_mode: false
		reset:            true
	)!
	mut db2 := new(
		record_nr_max:    16777216 - 1
		record_size_max:  1024
		path:             '/tmp/sync_test_db_edge2'
		incremental_mode: false
		reset:            true
	)!

	defer {
		db1.destroy() or { panic('failed to destroy db: ${err}') }
		db2.destroy() or { panic('failed to destroy db: ${err}') }
	}

	// Test syncing when source has gaps in IDs
	db1.set(OurDBSetArgs{ id: 1, data: 'one'.bytes() })!
	db1.set(OurDBSetArgs{ id: 5, data: 'five'.bytes() })!
	db1.set(OurDBSetArgs{ id: 10, data: 'ten'.bytes() })!

	// Sync from empty state
	updates := db1.push_updates(0)!
	db2.sync_updates(updates)!

	// Verify all records synced
	assert db2.get(1)! == 'one'.bytes()
	assert db2.get(5)! == 'five'.bytes()
	assert db2.get(10)! == 'ten'.bytes()
	assert db2.get_last_index()! == 10

	// Delete middle record and sync again
	db1.delete(5)!
	last_index := db2.get_last_index()!
	updates2 := db1.push_updates(last_index)!

	db2.sync_updates(updates2)!

	// Verify deletion was synced
	if _ := db2.get(5) {
		assert false, 'deleted record should not exist'
	}
	assert db2.get_last_index()! == 10 // Still tracks highest ID
}
