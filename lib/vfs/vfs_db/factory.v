module vfs_db

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.core.pathlib

// Factory method for creating a new DatabaseVFS instance
@[params]
pub struct VFSParams {
pub:
	data_dir         string // Directory to store DatabaseVFS data
	metadata_dir     string // Directory to store DatabaseVFS metadata
	incremental_mode bool   // Whether to enable incremental mode
}

// new creates a new DatabaseVFS instance
pub fn new(data_dir string, metadata_dir string) !&DatabaseVFS {
	return vfs_new(
		data_dir:         data_dir
		metadata_dir:     metadata_dir
		incremental_mode: false
	)!
}

// Factory method for creating a new DatabaseVFS instance
pub fn vfs_new(params VFSParams) !&DatabaseVFS {
	pathlib.get_dir(path: params.data_dir, create: true) or {
		return error('Failed to create data directory: ${err}')
	}

	mut db_data := ourdb.new(
		path:             '${params.data_dir}/ourdb_fs.db_data'
		incremental_mode: params.incremental_mode
	)!

	mut fs := &DatabaseVFS{
		root_id:    1
		block_size: 1024 * 4
		data_dir:   params.data_dir
		db_data:    &db_data
	}

	return fs
}
