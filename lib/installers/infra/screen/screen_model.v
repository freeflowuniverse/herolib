module screen

import freeflowuniverse.herolib.data.encoderhero

const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct Screen {
pub mut:
	name string = 'default'
}

// your checking & initialization code if needed
fn obj_init(obj_ Screen) !Screen {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}

// called before start if done
fn configure() ! {
	// mut installer := get()!
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj Screen) !string {
	return encoderhero.encode[Screen](obj)!
}

pub fn heroscript_loads(heroscript string) !Screen {
	mut obj := encoderhero.decode[Screen](heroscript)!
	return obj
}
