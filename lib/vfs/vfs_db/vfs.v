module vfs_db

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.data.ourdb
import time

// DatabaseVFS represents the virtual filesystem
@[heap]
pub struct DatabaseVFS {
pub mut:
	root_id          u32    // ID of root directory
	block_size       u32    // Size of data blocks in bytes
	data_dir         string // Directory to store DatabaseVFS data
	metadata_dir     string // Directory where we store the metadata
	db_data          &Database @[str: skip] // Database instance for storage
	last_inserted_id u32
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
pub fn (mut fs DatabaseVFS) load_entry(id u32) !FSEntry {
	if data := fs.db_data.get(id) {
		// First byte is version, second byte indicates the type
		// TODO: check we dont overflow filetype (u8 in boundaries of filetype)
		entry_type := unsafe { vfs.FileType(data[1]) }

		match entry_type {
			.directory {
				mut dir := decode_directory(data) or {
					return error('Failed to decode directory: ${err}')
				}
				return dir
			}
			.file {
				mut file := decode_file(data) or { return error('Failed to decode file: ${err}') }
				return file
			}
			.symlink {
				mut symlink := decode_symlink(data) or {
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
			return fs.db_data.set(id: entry.metadata.id, data: encoded) or {
				return error('Failed to save directory on id:${entry.metadata.id}: ${err}')
			}
		}
		File {
			encoded := entry.encode()
			return fs.db_data.set(id: entry.metadata.id, data: encoded) or {
				return error('Failed to save file on id:${entry.metadata.id}: ${err}')
			}
		}
		Symlink {
			encoded := entry.encode()
			return fs.db_data.set(id: entry.metadata.id, data: encoded) or {
				return error('Failed to save symlink on id:${entry.metadata.id}: ${err}')
			}
		}
	}
}
