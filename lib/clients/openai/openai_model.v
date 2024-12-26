module openai

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.core.httpconnection

pub const version = '1.14.3'
const singleton = false
const default = true

// TODO: THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE TO STRUCT BELOW, IS STRUCTURED AS HEROSCRIPT
pub fn heroscript_default() !string {
	heroscript := "
    !!openai.configure 
        name:'openai'
        key: 'YOUR_API_KEY'
        "

	return heroscript
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

pub struct OpenAI {
pub mut:
	name string = 'default'
	key  string @[secret]

	conn ?&httpconnection.HTTPConnection
}

fn cfg_play(p paramsparser.Params) ! {
	// THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE WITH struct above
	mut mycfg := OpenAI{
		name: p.get_default('name', 'default')!
		key: p.get('key')!
	}
	set(mycfg)!
}

fn obj_init(obj_ OpenAI) !OpenAI {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}

pub fn (mut client OpenAI) connection() !&httpconnection.HTTPConnection {
	mut c := client.conn or {
		mut c2 := httpconnection.new(
			name: 'openaiconnection_${client.name}'
			url: 'https://openrouter.ai/api/v1'
			cache: false
			retry: 0
		)!
		c2
	}

	c.default_header.set(.authorization, 'Bearer ${client.key}')
	c.default_header.set(.content_type, 'application/json')

	client.conn = c
	return c
}
