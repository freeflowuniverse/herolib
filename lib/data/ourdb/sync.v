module ourdb

import encoding.binary

// SyncRecord represents a single database update for synchronization
struct SyncRecord {
	id   u32
	data []u8
}

// get_last_index returns the highest ID currently in use in the database
pub fn (mut db OurDB) get_last_index() !u32 {
	return db.lookup.get_next_id()! - 1
}

// push_updates serializes all updates from the given index onwards
pub fn (mut db OurDB) push_updates(index u32) ![]u8 {
	mut updates := []u8{}
	last_index := db.get_last_index()!

	// No updates if requested index is at or beyond our last index
	if index >= last_index {
		return updates
	}

	// Write the number of updates as u32
	update_count := last_index - index
	mut count_bytes := []u8{len: 4}
	binary.little_endian_put_u32(mut count_bytes, update_count)
	updates << count_bytes

	// Collect and serialize all updates after the given index
	for i := index + 1; i <= last_index; i++ {
		// Get data for this ID
		data := db.get(i) or { continue }

		// Write ID (u32)
		mut id_bytes := []u8{len: 4}
		binary.little_endian_put_u32(mut id_bytes, i)
		updates << id_bytes

		// Write data length (u32)
		mut len_bytes := []u8{len: 4}
		binary.little_endian_put_u32(mut len_bytes, u32(data.len))
		updates << len_bytes

		// Write data
		updates << data
	}

	return updates
}

// sync_updates applies received updates to the database
pub fn (mut db OurDB) sync_updates(bytes []u8) ! {
	if bytes.len < 4 {
		return error('invalid update data: too short')
	}

	mut pos := 0

	// Read number of updates
	update_count := binary.little_endian_u32(bytes[pos..pos + 4])
	pos += 4

	// Process each update
	for _ in 0 .. update_count {
		if pos + 8 > bytes.len {
			return error('invalid update data: truncated header')
		}

		// Read ID
		id := binary.little_endian_u32(bytes[pos..pos + 4])
		pos += 4

		// Read data length
		data_len := binary.little_endian_u32(bytes[pos..pos + 4])
		pos += 4

		if pos + int(data_len) > bytes.len {
			return error('invalid update data: truncated content')
		}

		// Read data
		data := bytes[pos..pos + int(data_len)]
		pos += int(data_len)

		// Apply update
		db.set(OurDBSetArgs{
			id: id
			data: data.clone()
		})!
	}
}
