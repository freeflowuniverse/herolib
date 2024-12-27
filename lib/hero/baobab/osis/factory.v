module osis

import os
import db.sqlite
import db.pg
import freeflowuniverse.herolib.data.dbfs
import freeflowuniverse.herolib.data.encoderhero

pub fn new(config OSISConfig) !OSIS {
	return OSIS{
		indexer: new_indexer()!
		storer: new_storer()!
	}
}
