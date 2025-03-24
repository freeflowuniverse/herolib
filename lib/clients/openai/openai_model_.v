module openai

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.core.httpconnection
import os

pub const version = '1.14.3'
const singleton = false
const default = true

// TODO: THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE TO STRUCT BELOW, IS STRUCTURED AS HEROSCRIPT
pub fn heroscript_default() !string {
	heroscript := "
    !!openai.configure 
        name:'openai'
        api_key: ${os.getenv('OPENAI_API_KEY')}
        "

	return heroscript
}

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

pub struct OpenAI {
pub mut:
	name       string = 'default'
	api_key    string @[secret]
	server_url string
	conn       ?&httpconnection.HTTPConnection
}

// fn cfg_play(p paramsparser.Params) ! {
// 	// THIS IS EXAMPLE CODE AND NEEDS TO BE CHANGED IN LINE WITH struct above
// 	mut mycfg := OpenAI{
// 		name:    p.get_default('name', 'default')!
// 		api_key: p.get('api_key')!
// 	}
// 	set(mycfg)!
// }

fn obj_init(obj_ OpenAI) !OpenAI {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	return obj
}

pub fn (mut client OpenAI) connection() !&httpconnection.HTTPConnection {
	server_url := if client.server_url != '' {
		client.server_url
	} else {
		'https://api.openai.com/v1'
	}
	mut c := client.conn or {
		mut c2 := httpconnection.new(
			name:  'openaiconnection_${client.name}'
			url:   server_url
			cache: false
			retry: 20
		)!
		c2
	}

	c.default_header.set(.authorization, 'Bearer ${client.api_key}')

	client.conn = c
	return c
}
