module ourdb

fn test_db_sync() ! {
	// Create two database instances
	mut db1 := new_test_db('sync_test_db1')!
	mut db2 := new_test_db('sync_test_db2')!

	defer {
		db1.destroy()!
		db2.destroy()!
	}

	// Initial state - both DBs are synced
	db1.set(OurDBSetArgs{id: 1, data: 'initial data'.bytes()})!
	db2.set(OurDBSetArgs{id: 1, data: 'initial data'.bytes()})!

	assert db1.get(1)! == 'initial data'.bytes()
	assert db2.get(1)! == 'initial data'.bytes()

	// Make updates to db1
	db1.set(OurDBSetArgs{id: 2, data: 'second update'.bytes()})!
	db1.set(OurDBSetArgs{id: 3, data: 'third update'.bytes()})!

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
	mut db1 := new_test_db('sync_test_db1_empty')!
	mut db2 := new_test_db('sync_test_db2_empty')!

	defer {
		db1.destroy()!
		db2.destroy()!
	}

	// Both DBs are at the same index
	db1.set(OurDBSetArgs{id: 1, data: 'test'.bytes()})!
	db2.set(OurDBSetArgs{id: 1, data: 'test'.bytes()})!

	last_index := db2.get_last_index()!
	updates := db1.push_updates(last_index)!

	// Should get empty updates since DBs are synced
	assert updates.len == 0

	db2.sync_updates(updates)!
	assert db2.get_last_index()! == 1
}

fn test_db_sync_invalid_data() ! {
	mut db := new_test_db('sync_test_db_invalid')!

	defer {
		db.destroy()!
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
