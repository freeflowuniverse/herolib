module openai

import freeflowuniverse.herolib.data.paramsparser
import os
import freeflowuniverse.herolib.core.httpconnection

pub const version = '0.0.0'
const singleton = false
const default = true

// THIS THE THE SOURCE OF THE INFORMATION OF THIS FILE, HERE WE HAVE THE CONFIG OBJECT CONFIGURED AND MODELLED

@[heap]
pub struct OpenAI {
pub mut:
	name          string = 'default'
	mail_from     string
	mail_password string @[secret]
	mail_port     int
	mail_server   string
	mail_username string
}

fn obj_init(obj_ OpenAI) !OpenAI {
	// never call get here, only thing we can do here is work on object itself
	mut obj := obj_
	panic('implement')
	return obj
}

pub fn (mut client OpenAI) connection() !&httpconnection.HTTPConnection {
	mut c := client.conn or {
		mut c2 := httpconnection.new(
			name:  'openrouterclient_${client.name}'
			url:   'https://openrouter.ai/api/v1/chat/completions'
			cache: false
			retry: 0
		)!
		c2
	}

	// see https://modules.vlang.io/net.http.html#CommonHeader
	// -H "Authorization: Bearer $OPENROUTER_API_KEY" \
	c.default_header.set(.authorization, 'Bearer ${client.openaikey}')
	c.default_header.add_custom('HTTP-Referer', client.your_site_url)!
	c.default_header.add_custom('X-Title', client.your_site_name)!
	client.conn = c
	return c
}
