module pgp

// import freeflowuniverse.herolib.builder
import os

// list all instances
fn (pgp PGPFactory) list() ?[]&PGPInstance {
	mut res := []&PGPInstance{}
}

// destroy all instances
fn (pgp PGPFactory) destroy() {
}
