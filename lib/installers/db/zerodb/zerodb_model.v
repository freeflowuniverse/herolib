module zerodb

import freeflowuniverse.herolib.data.paramsparser
import os

pub const version = '0.0.0'
const singleton = true
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
@[heap]
pub struct ZeroDB {
pub mut:
	name string = 'default'
}

fn obj_init(obj_ ZeroDB) !ZeroDB {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	panic('implement')
	return obj
}

// called before start if done
fn configure() ! {
	// mut installer := get()!
}
