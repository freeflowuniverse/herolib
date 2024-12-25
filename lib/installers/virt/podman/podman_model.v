module podman

import freeflowuniverse.herolib.data.paramsparser
import os

pub const version = '5.2.3'
const singleton = true
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED
pub struct PodmanInstaller {
pub mut:
	name string = 'default'
}

fn obj_init(obj_ PodmanInstaller) !PodmanInstaller {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}

// called before start if done
fn configure() ! {
	// mut installer := get()!
}
