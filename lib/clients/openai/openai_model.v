module openai

import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.core.httpconnection
import os

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

// @[heap]
// pub struct OpenAIBase {
// pub mut:
// 	name    string = 'default'
// 	api_key string
// 	url     string
// 	model_default string
// }

@[heap]
pub struct OpenAI {
pub mut:
	name          string = 'default'
	api_key       string
	url           string
	model_default string
	conn          ?&httpconnection.HTTPConnection @[skip; str: skip]
}

// your checking & initialization code if needed
fn obj_init(mycfg_ OpenAI) !OpenAI {
	mut mycfg := mycfg_
	if mycfg.api_key == '' {
		mut k := os.getenv('AIKEY')
		if k != '' {
			mycfg.api_key = k
			k = os.getenv('AIURL')
			if k != '' {
				mycfg.url = k
			} else {
				return error('found AIKEY in env, but not AIURL')
			}
			k = os.getenv('AIMODEL')
			if k != '' {
				mycfg.model_default = k
			}
			return mycfg
		}
		mycfg.url = 'https://api.openai.com/v1/models'
		k = os.getenv('OPENAI_API_KEY')
		if k != '' {
			mycfg.api_key = k
			return mycfg
		}
		k = os.getenv('OPENROUTER_API_KEY')
		if k != '' {
			mycfg.api_key = k
			mycfg.url = 'https://openrouter.ai/api/v1'
			return mycfg
		}
	}
	return mycfg
}

pub fn (mut client OpenAI) connection() !&httpconnection.HTTPConnection {
	mut c := client.conn or {
		mut c2 := httpconnection.new(
			name:  'openaiconnection_${client.name}'
			url:   client.url
			cache: false
			retry: 20
		)!
		c2
	}

	c.default_header.set(.authorization, 'Bearer ${client.api_key}')
	client.conn = c
	return c
}

/////////////NORMALLY NO NEED TO TOUCH

pub fn heroscript_dumps(obj OpenAI) !string {
	return encoderhero.encode[OpenAI](obj)!
}

pub fn heroscript_loads(heroscript string) !OpenAI {
	mut obj := encoderhero.decode[OpenAI](heroscript)!
	return obj
}
