module vfs_db

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.core.pathlib

// Factory method for creating a new DatabaseVFS instance
@[params]
pub struct VFSParams {
pub:
	data_dir         string // Directory to store DatabaseVFS data
	incremental_mode bool   // Whether to enable incremental mode
}

// Factory method for creating a new DatabaseVFS instance
pub fn new(mut database Database, params VFSParams) !&DatabaseVFS {
	pathlib.get_dir(path: params.data_dir, create: true) or {
		return error('Failed to create data directory: ${err}')
	}

	mut fs := &DatabaseVFS{
		root_id:    1
		block_size: 1024 * 4
		data_dir:   params.data_dir
		db_data:    database
	}

	return fs
}
