module postgres

import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.ui as gui
import freeflowuniverse.herolib.ui.console
import db.pg

pub struct PostgresClient[T] {
	base.BaseConfig[T]
pub mut:
	db pg.DB
}

pub fn get(instance string) !PostgresClient[Config] {
	mut self := PostgresClient[Config]{}
	self.init('postgres', instance, .get)!
	config := self.config()!

	mut db := pg.connect(
		host:     config.host
		user:     config.user
		port:     config.port
		password: config.password
		dbname:   config.dbname
	)!

	self.db = db
	return self
}
