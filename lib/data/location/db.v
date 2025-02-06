module location

import db.pg
import os
import encoding.csv
import freeflowuniverse.herolib.osal
import freeflowuniverse.herolib.core.pathlib

// LocationDB handles all database operations for locations
pub struct LocationDB {
mut:
	db pg.DB
	tmp_dir pathlib.Path
	db_dir pathlib.Path
}

// new_location_db creates a new LocationDB instance
pub fn new_location_db(reset bool) !LocationDB {
	mut db_dir := pathlib.get_dir(path:'${os.home_dir()}/hero/var/db/location.db',create: true)!
	
	// PostgreSQL connection parameters with defaults
	mut host := os.getenv('POSTGRES_HOST')
	if host == '' {
		host = 'localhost'
	}
	port := os.getenv('POSTGRES_PORT')
	port_num := if port == '' { 5432 } else { port.int() }
	mut user := os.getenv('POSTGRES_USER')
	if user == '' {
		user = 'postgres'
	}
	mut password := os.getenv('POSTGRES_PASSWORD')
	if password == '' {
		password = '1234'
	}
	mut dbname := os.getenv('POSTGRES_DB')
	if dbname == '' {
		dbname = 'locations'
	}
	
	// First try to connect to create the database if it doesn't exist
	mut init_db := pg.connect(
		host: host
		port: port_num
		user: user
		password: password
		dbname: 'postgres'
	) or { return error('Failed to connect to PostgreSQL: ${err}') }

	init_db.exec("CREATE DATABASE ${dbname}") or {}
	init_db.close()
	
	// Now connect to our database
	db := pg.connect(
		host: host
		port: port_num
		user: user
		password: password
		dbname: dbname
	) or { return error('Failed to connect to PostgreSQL: ${err}') }
	
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
		sql l.db {
			drop table AlternateName
			drop table City
			drop table Country
		}!
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
	l.db.close()
}
