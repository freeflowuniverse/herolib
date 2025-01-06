module postgresql

import freeflowuniverse.herolib.data.paramsparser

pub const version = '1.14.3'
const singleton = true
const default = true

pub fn heroscript_default() !string {
	heroscript := "
    !!postgresql.configure 
        name:'postgresql'
        user: 'postgres'
        password: 'postgres'
        host: 'localhost'
        port: 5432
        volume_path:'/var/lib/postgresql/data'
        "
	return heroscript
}

pub struct Postgresql {
pub mut:
	name         string = 'default'
	user         string = 'postgres'
	password     string = 'postgres'
	host         string = 'localhost'
	volume_path  string = '/var/lib/postgresql/data'
	port         int    = 5432
	container_id string
}

fn cfg_play(p paramsparser.Params) !Postgresql {
	mut mycfg := Postgresql{
		name:        p.get_default('name', 'default')!
		user:        p.get_default('user', 'postgres')!
		password:    p.get_default('password', 'postgres')!
		host:        p.get_default('host', 'localhost')!
		port:        p.get_int_default('port', 5432)!
		volume_path: p.get_default('path', '/var/lib/postgresql/data')!
	}
	return mycfg
}

fn obj_init(obj_ Postgresql) !Postgresql {
	mut obj := obj_
	return obj
}

fn configure() ! {}
