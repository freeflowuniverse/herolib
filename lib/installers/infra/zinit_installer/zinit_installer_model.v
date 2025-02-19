module zinit_installer

import freeflowuniverse.herolib.data.encoderhero

pub const version = '0.0.0'
const singleton = true
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct ZinitInstaller {
pub mut:
	name string = 'default'
}

// your checking & initialization code if needed
fn obj_init(mycfg_ ZinitInstaller) !ZinitInstaller {
	mut mycfg := mycfg_
	return mycfg
}

// called before start if done
fn configure() ! {
	// mut installer := get()!
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj ZinitInstaller) !string {
	return encoderhero.encode[ZinitInstaller](obj)!
}

pub fn heroscript_loads(heroscript string) !ZinitInstaller {
	mut obj := encoderhero.decode[ZinitInstaller](heroscript)!
	return obj
}
