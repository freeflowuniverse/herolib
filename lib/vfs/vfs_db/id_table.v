module vfs_db

import freeflowuniverse.herolib.vfs
import freeflowuniverse.herolib.data.ourdb
import time

// get_database_id get's the corresponding db id for a file's metadata id.
// since multiple vfs can use single db, or db's can have their own id logic
// databases set independent id's to data
pub fn (fs DatabaseVFS) get_database_id(vfs_id u32) !u32 {
	return fs.id_table[vfs_id] or { error('VFS ID ${vfs_id} not found.') }
}

// get_database_id get's the corresponding db id for a file's metadata id.
// since multiple vfs can use single db, or db's can have their own id logic
// databases set independent id's to data
pub fn (mut fs DatabaseVFS) set_database_id(vfs_id u32, db_id u32) ! {
	fs.id_table[vfs_id] = db_id
}
