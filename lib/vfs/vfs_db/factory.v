module vfs_db

import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.core.pathlib

// Factory method for creating a new DatabaseVFS instance
@[params]
pub struct VFSParams {
pub:
	data_dir         string // Directory to store DatabaseVFS data
	metadata_dir     string // Directory to store metadata (defaults to data_dir if not specified)
	incremental_mode bool   // Whether to enable incremental mode
}

// Factory method for creating a new DatabaseVFS instance
pub fn new(mut database Database, params VFSParams) !&DatabaseVFS {
	pathlib.get_dir(path: params.data_dir, create: true) or {
		return error('Failed to create data directory: ${err}')
	}
	
	// Use the same database for both data and metadata if only one is provided
	mut fs := &DatabaseVFS{
		root_id:      1
		block_size:   1024 * 4
		data_dir:     params.data_dir
		metadata_dir: if params.metadata_dir.len > 0 { params.metadata_dir } else{ params.data_dir}
		db_data:      database
		db_metadata:  database
	}

	return fs
}

// Factory method for creating a new DatabaseVFS instance with separate databases for data and metadata
pub fn new_with_separate_dbs(mut data_db Database, mut metadata_db Database, params VFSParams) !&DatabaseVFS {
	pathlib.get_dir(path: params.data_dir, create: true) or {
		return error('Failed to create data directory: ${err}')
	}
	
	if params.metadata_dir.len > 0 {
		pathlib.get_dir(path: params.metadata_dir, create: true) or {
			return error('Failed to create metadata directory: ${err}')
		}
	}
	
	mut fs := &DatabaseVFS{
		root_id:      1
		block_size:   1024 * 4
		data_dir:     params.data_dir
		metadata_dir: if params.metadata_dir.len > 0 { params.metadata_dir } else { params.data_dir}
		db_data:      data_db
		db_metadata:  metadata_db
	}

	return fs
}
