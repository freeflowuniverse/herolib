// File: lib/clients/gitea_client/gitea_client_model.v
module gitea_client

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.encoderhero
import freeflowuniverse.herolib.core.httpconnection
import os

pub const version = '0.0.0'

@[heap]
pub struct GiteaClient {
pub mut:
	name   string = 'default'
	user   string
	url    string = 'https://git.ourworld.tf'
	secret string
}

fn (mut self GiteaClient) httpclient() !&httpconnection.HTTPConnection {
	mut http_conn := httpconnection.new(
		name: 'giteaclient_${self.name}'
		url: self.url
	)!

	// Add authentication header if API key is provided
	if self.secret.len > 0 {
		http_conn.default_header.add(.authorization, 'token ${self.secret}')
	}
	return http_conn
}

// your checking & initialization code if needed
fn obj_init(mycfg_ GiteaClient) !GiteaClient {
	mut mycfg := mycfg_
	if mycfg.url == '' {
		return error('url needs to be filled in for ${mycfg.name}')
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
