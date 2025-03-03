module vfs_db

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.encoder
import time

// DatabaseVFS represents the virtual filesystem
@[heap]
pub struct DatabaseVFS {
pub mut:
	root_id          u32    // ID of root directory
	block_size       u32    // Size of data blocks in bytes
	db_data          &Database @[str: skip] // Database instance for file data storage
	db_metadata      &Database @[str: skip] // Database instance for metadata storage
	last_inserted_id u32
	id_table map[u32]u32
}

pub interface Database {
mut:
	get(id u32) ![]u8
	set(ourdb.OurDBSetArgs) !u32
	delete(id u32) !
}

// Get the next ID, it should be some kind of auto-incrementing ID
pub fn (mut fs DatabaseVFS) get_next_id() u32 {
	fs.last_inserted_id = fs.last_inserted_id + 1
	return fs.last_inserted_id
}

// load_entry loads an entry from the database by ID and sets up parent references
pub fn (mut fs DatabaseVFS) load_entry(vfs_id u32) !FSEntry {
	if metadata := fs.db_metadata.get(fs.get_database_id(vfs_id)!) {
		// First byte is version, second byte indicates the type
		// TODO: check we dont overflow filetype (u8 in boundaries of filetype)
		entry_type := unsafe { vfs.FileType(metadata[1]) }
		match entry_type {
			.directory {
				mut dir := decode_directory(metadata) or {
					return error('Failed to decode directory: ${err}')
				}
				return dir
			}
			.file {
				mut file, data_id := decode_file_metadata(metadata) or { return error('Failed to decode file: ${err}') }
				if id := data_id {
					// there was a data_db index stored with file so file has data
					if file_data := fs.db_data.get(id) {
						file.data = file_data.bytestr()
					} else {
						return error('This should never happen, data is not where its supposed to be')
					}
				}
				return file
			}
			.symlink {
				mut symlink := decode_symlink(metadata) or {
					return error('Failed to decode symlink: ${err}')
				}
				return symlink
			}
		}
	}
	return error('Entry not found')
}

// save_entry saves an entry to the database
pub fn (mut fs DatabaseVFS) save_entry(entry FSEntry) !u32 {
	match entry {
		Directory {
			encoded := entry.encode()
			db_id := fs.db_metadata.set(id: entry.metadata.id, data: encoded) or {
				return error('Failed to save directory on id:${entry.metadata.id}: ${err}')
			}
			fs.set_database_id(entry.metadata.id, db_id)!
			return entry.metadata.id
		}
		File {
			// First encode file data and store in db_data
			data_encoded := entry.data.bytes()
			metadata_bytes := if data_encoded.len == 0 {
				entry.encode(none)
			} else {
				// file has data so that will be stored in data_db
				// its corresponding id stored with file metadata
				data_db_id := fs.db_data.set(id: entry.metadata.id, data: data_encoded) or {
					return error('Failed to save file data on id:${entry.metadata.id}: ${err}')
				}
				// Encode the db_data ID in with the file metadata
				entry.encode(data_db_id)
			}
			
			// Save the metadata_bytes to metadata_db
			metadata_db_id := fs.db_metadata.set(id: entry.metadata.id, data: metadata_bytes) or {
				return error('Failed to save file metadata on id:${entry.metadata.id}: ${err}')
			}
			
			fs.set_database_id(entry.metadata.id, metadata_db_id)!
			return entry.metadata.id
		}
		Symlink {
			encoded := entry.encode()
			db_id := fs.db_metadata.set(id: entry.metadata.id, data: encoded) or {
				return error('Failed to save symlink on id:${entry.metadata.id}: ${err}')
			}
			fs.set_database_id(entry.metadata.id, db_id)!
			return entry.metadata.id
		}
	}
}
