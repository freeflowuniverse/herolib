module zinit_installer

import freeflowuniverse.herolib.data.encoderhero

pub const version = '0.0.0'
const singleton = true
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct Zinit {
pub mut:
	name string = 'default'
}

// your checking & initialization code if needed
fn obj_init(mycfg_ Zinit) !Zinit {
	mut mycfg := mycfg_
	return mycfg
}

// called before start if done
fn configure() ! {
	// mut installer := get()!
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj Zinit) !string {
	return encoderhero.encode[Zinit](obj)!
}

pub fn heroscript_loads(heroscript string) !Zinit {
	mut obj := encoderhero.decode[Zinit](heroscript)!
	return obj
}
