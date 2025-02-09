module meilisearchinstaller

import freeflowuniverse.herolib.data.encoderhero

pub const version = '1.11.3'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct MeilisearchServer {
pub mut:
	name       string = 'default'
	path       string = '/tmp/meilisearch'
	masterkey  string @[secret]
	host       string = 'localhost'
	port       int    = 7700
	production bool
}

// your checking & initialization code if needed
fn obj_init(mycfg_ MeilisearchServer) !MeilisearchServer {
	mut mycfg := mycfg_
	if mycfg.masterkey == '' {
		return error('masterkey is empty')
	}

	return mycfg
}

// called before start if done
fn configure() ! {
	// mut installer := get()!
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj MeilisearchServer) !string {
	return encoderhero.encode[MeilisearchServer](obj)!
}

pub fn heroscript_loads(heroscript string) !MeilisearchServer {
	mut obj := encoderhero.decode[MeilisearchServer](heroscript)!
	return obj
}
