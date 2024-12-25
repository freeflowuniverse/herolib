module mycelium

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.core.httpconnection
import os

pub const version = '0.0.0'
const singleton = true
const default = true

pub fn heroscript_default() !string {
	heroscript := "
    !!mycelium.configure 
        name:'mycelium'
        "
	return heroscript
}

@[heap]
pub struct Mycelium {
pub mut:
	name       string = 'default'
	server_url string
	conn       ?&httpconnection.HTTPConnection
}

fn cfg_play(p paramsparser.Params) ! {
	mut mycfg := Mycelium{
		name:       p.get_default('name', 'default')!
		server_url: p.get_default('server_url', 'http://localhost:8989/api/v1/messages')!
	}
	set(mycfg)!
}

fn obj_init(obj_ Mycelium) !Mycelium {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}
