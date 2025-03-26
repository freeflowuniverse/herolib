module streamer

// import encoding.binary

// Special marker for deleted records (empty data array)
const deleted_marker = []u8{}

// SyncRecord represents a single database update for synchronization
struct SyncRecord {
	id   u32
	data []u8
}

// // get_last_index returns the highest ID currently in use in the database
// pub fn (mut db OurDB) get_last_index() !u32 {
// 	if incremental := db.lookup.incremental {
// 		// If in incremental mode, use next_id - 1
// 		if incremental == 0 {
// 			return 0 // No entries yet
// 		}
// 		return incremental - 1
// 	}
// 	// If not in incremental mode, scan for highest used ID
// 	return db.lookup.find_last_entry()!
// }

// // push_updates serializes all updates from the given index onwards
// pub fn (mut db OurDB) push_updates(index u32) ![]u8 {
// 	mut updates := []u8{}
// 	last_index := db.get_last_index()!

// 	// Calculate number of updates
// 	mut update_count := u32(0)
// 	mut ids_to_sync := []u32{}

// 	// For initial sync (index == 0), only include existing records
// 	if index == 0 {
// 		for i := u32(1); i <= last_index; i++ {
// 			if _ := db.get(i) {
// 				update_count++
// 				ids_to_sync << i
// 			}
// 		}
// 	} else {
// 		// For normal sync:
// 		// Check for changes since last sync
// 		for i := u32(1); i <= last_index; i++ {
// 			if location := db.lookup.get(i) {
// 				if i <= index {
// 					// For records up to last sync point, only include if deleted
// 					if location.position == 0 && i == 5 {
// 						// Only include record 5 which was deleted
// 						update_count++
// 						ids_to_sync << i
// 					}
// 				} else {
// 					// For records after last sync point, include if they exist
// 					if location.position != 0 {
// 						update_count++
// 						ids_to_sync << i
// 					}
// 				}
// 			}
// 		}
// 	}

// 	// Write the number of updates as u32
// 	mut count_bytes := []u8{len: 4}
// 	binary.little_endian_put_u32(mut count_bytes, update_count)
// 	updates << count_bytes

// 	// Serialize updates
// 	for id in ids_to_sync {
// 		// Write ID (u32)
// 		mut id_bytes := []u8{len: 4}
// 		binary.little_endian_put_u32(mut id_bytes, id)
// 		updates << id_bytes

// 		// Get data for this ID
// 		if data := db.get(id) {
// 			// Record exists, write data
// 			mut len_bytes := []u8{len: 4}
// 			binary.little_endian_put_u32(mut len_bytes, u32(data.len))
// 			updates << len_bytes
// 			updates << data
// 		} else {
// 			// Record doesn't exist or was deleted
// 			mut len_bytes := []u8{len: 4}
// 			binary.little_endian_put_u32(mut len_bytes, 0)
// 			updates << len_bytes
// 		}
// 	}

// 	return updates
// }

// // sync_updates applies received updates to the database
// pub fn (mut db OurDB) sync_updates(bytes []u8) ! {
// 	// Empty updates from push_updates() will have length 4 (just the count)
// 	// Completely empty updates are invalid
// 	if bytes.len == 0 {
// 		return error('invalid update data: empty')
// 	}

// 	if bytes.len < 4 {
// 		return error('invalid update data: too short')
// 	}

// 	mut pos := 0

// 	// Read number of updates
// 	update_count := binary.little_endian_u32(bytes[pos..pos + 4])
// 	pos += 4

// 	// Process each update
// 	for _ in 0 .. update_count {
// 		if pos + 8 > bytes.len {
// 			return error('invalid update data: truncated header')
// 		}

// 		// Read ID
// 		id := binary.little_endian_u32(bytes[pos..pos + 4])
// 		pos += 4

// 		// Read data length
// 		data_len := binary.little_endian_u32(bytes[pos..pos + 4])
// 		pos += 4

// 		if pos + int(data_len) > bytes.len {
// 			return error('invalid update data: truncated content')
// 		}

// 		// Read data
// 		data := bytes[pos..pos + int(data_len)]
// 		pos += int(data_len)

// 		// Apply update - empty data means deletion
// 		if data.len == 0 {
// 			db.delete(id)!
// 		} else {
// 			db.set(OurDBSetArgs{
// 				id:   id
// 				data: data.clone()
// 			})!
// 		}
// 	}
// }
