module jina

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.core.httpconnection
import freeflowuniverse.herolib.osal
import os

pub const version = '0.0.0'
const singleton = false
const default = true
const api_base_url = 'https://api.jina.ai'
const env_key = 'JINAKEY'

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct Jina {
pub mut:
	name          string = 'default'
	secret        string
	base_url      string = api_base_url
	http          httpconnection.HTTPConnection @[str: skip]
}

// your checking & initialization code if needed
fn obj_init(mycfg_ Jina) !Jina {
	mut mycfg := mycfg_
	
	// Get API key from environment variable if not set
	if mycfg.secret == '' {
		if osal.env_exists(env_key) {
			mycfg.secret = osal.env_get(env_key) or {
				return error('Failed to get API key from environment variable ${env_key}: ${err}')
			}
		} else {
			return error('Jina API key not provided and ${env_key} environment variable not set')
		}
	}
	
	// Initialize HTTP connection
	mycfg.http = httpconnection.HTTPConnection{
		base_url: mycfg.base_url
		default_header: http.new_header(
			key: .authorization
			value: 'Bearer ${mycfg.secret}'
		)
	}
	
	return mycfg
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj Jina) !string {
	return encoderhero.encode[Jina](obj)!
}

pub fn heroscript_loads(heroscript string) !Jina {
	mut obj := encoderhero.decode[Jina](heroscript)!
	return obj
}
