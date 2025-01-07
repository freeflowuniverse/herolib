module generator

import json
import freeflowuniverse.herolib.core.code { VFile, File, Function, Module, Struct }
import freeflowuniverse.herolib.schemas.openapi { Components, OpenAPI }
// import freeflowuniverse.herolib.schemas.openapi.codegen { generate_client_file, generate_client_test_file }

pub fn generate_openapi_file(specification OpenAPI) !File {
	openapi_json := specification.encode_json()
	return File{
		name: 'openapi'
		extension: 'json'
		content: openapi_json
	}
}