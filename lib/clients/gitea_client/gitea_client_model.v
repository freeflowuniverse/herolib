module gitea_client

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import os

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct GiteaClient {
pub mut:
	name          string = 'default'
	url     string = "https://git.ourworld.tf"
	key     string
}

// your checking & initialization code if needed
fn obj_init(mycfg_ GiteaClient) !GiteaClient {
	mut mycfg := mycfg_
	if mycfg.url == '' {
		return error('url needs to be filled in for ${mycfg.name}')
	}
	if mycfg.key == '' {
		return error('key needs to be filled in for ${mycfg.name}')
	}
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj GiteaClient) !string {
	return encoderhero.encode[GiteaClient](obj)!
}

pub fn heroscript_loads(heroscript string) !GiteaClient {
	mut obj := encoderhero.decode[GiteaClient](heroscript)!
	return obj
}
