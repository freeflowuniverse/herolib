module vfs_db

import arrays
import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.encoder
import time
import log

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
// loads without data
fn (mut fs DatabaseVFS) load_entry(vfs_id u32) !FSEntry {
	if metadata := fs.db_metadata.get(fs.get_database_id(vfs_id)!) {	
		match decode_entry_type(metadata)! {
			.directory {
				mut dir := decode_directory(metadata) or {
					return error('Failed to decode directory: ${err}')
				}
				return dir
			}
			.file {
				return decode_file_metadata(metadata) or { return error('Failed to decode file: ${err}') }
			}
			.symlink {
				mut symlink := decode_symlink(metadata) or {
					return error('Failed to decode symlink: ${err}')
				}
				return symlink
			}
		}
	} else {
		return error('Entry ${vfs_id} not found ${err}')
	}
}

// fn (mut fs DatabaseVFS) file_read(file File) ![]u8 {
// 	metadata := fs.db_metadata.get(fs.get_database_id(file.metadata.id)!) or {
// 		return error('Failed to get file metadata ${err}')
// 	}
// 	_, chunk_ids := decode_file_metadata(metadata) or { return error('Failed to decode file: ${err}') }
// 	mut file_data := []u8{}
// 	// log.debug('[DatabaseVFS] Got database chunk ids ${chunk_ids}')
// 	for id in chunk_ids {
// 		// there were chunk ids stored with file so file has data
// 		if chunk_bytes := fs.db_data.get(id) {
// 			file_data << chunk_bytes
// 		} else {
// 			return error('Failed to fetch file data: ${err}')
// 		}
// 	}
// 	return file_data
// }