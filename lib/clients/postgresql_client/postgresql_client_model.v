module postgresql_client

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import os
import db.pg

pub const version = '0.0.0'
const singleton = false
const default = true

pub fn heroscript_default() !string {
	heroscript := "
    !!postgresql_client.configure
        name:'default'
        user: 'root'
        port: 5432
        host: 'localhost'
        password: ''
        dbname: 'postgres'
        "
	return heroscript
}

pub fn heroscript_dumps(obj PostgresClient) !string {
	return encoderhero.encode[PostgresClient](obj)!
}

pub fn heroscript_loads(heroscript string) !PostgresClient {
	mut obj := encoderhero.decode[PostgresClient](heroscript)!
	return obj
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct PostgresClient {
mut:
	db_ ?pg.DB
pub mut:
	name     string = 'default'
	user     string = 'root'
	port     int    = 5432
	host     string = 'localhost'
	password string
	dbname   string = 'postgres'
}

fn cfg_play(p paramsparser.Params) !PostgresClient {
	mut mycfg := PostgresClient{
		name:     p.get_default('name', 'default')!
		user:     p.get_default('user', 'root')!
		port:     p.get_int_default('port', 5432)!
		host:     p.get_default('host', 'localhost')!
		password: p.get_default('password', '')!
		dbname:   p.get_default('dbname', 'postgres')!
	}
	set(mycfg)!
	return mycfg
}

fn obj_init(obj_ PostgresClient) !PostgresClient {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}

pub fn (mut self PostgresClient) db() !pg.DB {
	// console.print_debug(args)
	mut db := self.db_ or {
		mut db_ := pg.connect(
			host:     self.host
			user:     self.user
			port:     self.port
			password: self.password
			dbname:   self.dbname
		)!
		db_
	}

	return db
}
