module location

import db.sqlite
import os
import encoding.csv
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.core.pathlib

// LocationDB handles all database operations for locations
pub struct LocationDB {
mut:
	db sqlite.DB
	tmp_dir pathlib.Path
	db_dir pathlib.Path
}

// new_location_db creates a new LocationDB instance
pub fn new_location_db(reset bool) !LocationDB {
	mut db_dir := pathlib.get_dir(path:'${os.home_dir()}/hero/var/db/location.db',create: true)!
	db := sqlite.connect("${db_dir.path}/locations.db")!
	mut loc_db := LocationDB{
		db: db
		tmp_dir: pathlib.get_dir(path: '/tmp/location/',create: true)!
		db_dir: db_dir
	}
	loc_db.init_tables(reset)!
	return loc_db
}

// init_tables drops and recreates all tables
fn (mut l LocationDB) init_tables(reset bool) ! {
	if reset {
		l.db.exec('DROP TABLE IF EXISTS AlternateName')!
		l.db.exec('DROP TABLE IF EXISTS City')!
		l.db.exec('DROP TABLE IF EXISTS Country')!
	}
	
	sql l.db {
		create table Country
		create table City
		create table AlternateName
	}!

	// When resetting, ensure all countries have import_date set to 0
	if reset {
		l.db.exec('UPDATE Country SET import_date = 0')!
	}
}

// close closes the database connection
pub fn (mut l LocationDB) close() ! {
	l.db.close() or { return err }
}
