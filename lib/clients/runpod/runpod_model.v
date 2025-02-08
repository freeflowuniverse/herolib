module runpod

import freeflowuniverse.herolib.data.paramsparser
import os

pub const version = '1.14.3'
const singleton = false
const default = true

// heroscript_default returns the default heroscript configuration for RunPod
pub fn heroscript_default() !string {
	return "
    !!runpod.configure
        name:'default'
        api_key:'${os.getenv('RUNPOD_API_KEY')}'
        base_url:'https://api.runpod.io/'
    "
}

// RunPod represents a RunPod client instance
@[heap]
pub struct RunPod {
pub mut:
	name     string = 'default'
	api_key  string
	base_url string = 'https://api.runpod.io/'
}

fn cfg_play(p paramsparser.Params) ! {
	// THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE WITH struct above
	mut mycfg := RunPod{
		name:     p.get_default('name', 'default')!
		api_key:  p.get_default('api_key', os.getenv('RUNPOD_API_KEY'))!
		base_url: p.get_default('base_url', 'https://api.runpod.io/')!
	}
	set(mycfg)!
}

fn obj_init(obj_ RunPod) !RunPod {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}
