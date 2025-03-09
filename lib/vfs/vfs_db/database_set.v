module vfs_db

import arrays
import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.data.encoder
import time
import log

// save_entry saves an entry to the database
pub fn (mut fs DatabaseVFS) save_entry(entry FSEntry) !u32 {
	match entry {
		Directory {
			encoded := entry.encode()
			db_id := fs.db_metadata.set(id: entry.metadata.id, data: encoded) or {
				return error('Failed to save directory on id:${entry.metadata.id}: ${err}')
			}
			for child_id in entry.children {
				_ := fs.db_metadata.get(fs.get_database_id(child_id)!) or {
					return error('Failed to get entry for directory child ${child_id} missing.\n${err}')
				}
			}
			log.debug('[DatabaseVFS] Saving dir entry with children ${entry.children}')
			fs.set_database_id(entry.metadata.id, db_id)!
			return entry.metadata.id
		}
		File {
			metadata_bytes := entry.encode()
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

// save_entry saves an entry to the database
pub fn (mut fs DatabaseVFS) save_file(file_ File, data []u8) !u32 {
	// Preserve the existing ID if it's set, otherwise get a new one
	mut file_id := file_.metadata.id
	if file_id == 0 {
		file_id = fs.get_next_id()
	}

	file := File {...file_
		metadata: vfs.Metadata {...file_.metadata
			id: file_id
		}
	}
	// Create a file with the updated metadata and chunk IDs
	mut updated_file := file
	
	if data.len > 0 {
		// file has data so that will be stored in data_db
		// split data_encoded into chunks of 64 kb
		chunks := arrays.chunk(data, 64 * 1024)
		mut chunk_ids := []u32{}
		
		for i, chunk in chunks {
			// Generate a unique ID for each chunk based on the file ID
			chunk_id := file_id * 1000 + u32(i) + 1
			chunk_ids << fs.db_data.set(id: chunk_id, data: chunk) or {
				return error('Failed to save file data on id:${file.metadata.id}: ${err}')
			}
		}
		
		// Update the file with chunk IDs and size
		updated_file = File{
			metadata: vfs.Metadata{
				...file.metadata
				size: u64(data.len)
			}
			chunk_ids: chunk_ids
			parent_id: file.parent_id
		}
	}
	
	// Encode the file with all its metadata
	metadata_bytes := updated_file.encode()
	// Save the metadata_bytes to metadata_db
	metadata_db_id := fs.db_metadata.set(id: file.metadata.id, data: metadata_bytes) or {
		return error('Failed to save file metadata on id:${file.metadata.id}: ${err}')
	}
	
	fs.set_database_id(file.metadata.id, metadata_db_id)!
	return file.metadata.id
}
