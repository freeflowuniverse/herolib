module ourdb_fs

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.core.pathlib

// Factory method for creating a new OurDBFS instance
@[params]
pub struct VFSParams {
pub:
	data_dir         string // Directory to store OurDBFS data
	metadata_dir     string // Directory to store OurDBFS metadata
	incremental_mode bool   // Whether to enable incremental mode
}

// Factory method for creating a new OurDBFS instance
pub fn new(params VFSParams) !&OurDBFS {
	pathlib.get_dir(path: params.data_dir, create: true) or {
		return error('Failed to create data directory: ${err}')
	}
	pathlib.get_dir(path: params.metadata_dir, create: true) or {
		return error('Failed to create metadata directory: ${err}')
	}

	mut db_meta := ourdb.new(
		path:             '${params.metadata_dir}/ourdb_fs.db_meta'
		incremental_mode: params.incremental_mode
	)!
	mut db_data := ourdb.new(
		path:             '${params.data_dir}/vfs_metadata.db_meta'
		incremental_mode: params.incremental_mode
	)!

	mut fs := &OurDBFS{
		root_id:      1
		block_size:   1024 * 4
		data_dir:     params.data_dir
		metadata_dir: params.metadata_dir
		db_meta:      &db_meta
		db_data:      &db_data
	}

	return fs
}
