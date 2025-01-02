module openapi

import os

@[params]
pub struct Params {
pub:
	path string // path to openrpc.json file
	text string // content of openrpc specification text
}

pub fn new(params Params) !OpenAPI {
	if params.path == '' && params.text == '' {
		return error('Either provide path or text')
	}

	if params.text != '' && params.path != '' {
		return error('Either provide path or text')
	}

	text := if params.path != '' {
		os.read_file(params.path)!	
	} else { params.text }

	return json_decode(text)!	
}