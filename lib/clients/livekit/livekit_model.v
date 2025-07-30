module livekit

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import os

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct LivekitClient {
pub mut:
	name          string = 'default'
	mail_from     string
	mail_password string @[secret]
	mail_port     int
	mail_server   string
	mail_username string
}

// your checking & initialization code if needed
fn obj_init(mycfg_ LivekitClient) !LivekitClient {
	mut mycfg := mycfg_
	if mycfg.password == '' && mycfg.secret == '' {
		return error('password or secret needs to be filled in for ${mycfg.name}')
	}
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj LivekitClient) !string {
	return encoderhero.encode[LivekitClient](obj)!
}

pub fn heroscript_loads(heroscript string) !LivekitClient {
	mut obj := encoderhero.decode[LivekitClient](heroscript)!
	return obj
}
