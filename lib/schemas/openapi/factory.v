module openapi

import freeflowuniverse.herolib.schemas.jsonschema {Schema, SchemaRef, Reference}
import freeflowuniverse.herolib.core.texttools
import os

@[params]
pub struct Params {
pub:
	path string // path to openrpc.json file
	text string // content of openrpc specification text
	process bool // whether to process spec
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

	specification := json_decode(text)!
	return if params.process {
		process(specification)!
	} else {specification}
}

pub fn process(spec OpenAPI) !OpenAPI {
	mut processed := OpenAPI{...spec
		paths: spec.paths.clone()
	}

	for key, schema in spec.components.schemas {
		if schema is Schema {
			mut processed_schema := Schema{
				...schema,
				id: if schema.id != '' { schema.id } 
					else if schema.title != '' { schema.title }
					else { key }
				title: if schema.title != '' { schema.title } 
					else if schema.id != '' { schema.id }
					else { key }
			}
			processed.components.schemas[key] = processed_schema
		}
	}

	for path, item in spec.paths {
		mut processed_item := PathItem{...item}

		processed_item.get = processed.process_operation(item.get, 'get', path)!
		processed_item.post = processed.process_operation(item.post, 'post', path)!
		processed_item.put = processed.process_operation(item.put, 'put', path)!
		processed_item.delete = processed.process_operation(item.delete, 'delete', path)!
		processed_item.patch = processed.process_operation(item.patch, 'patch', path)!
		processed_item.options = processed.process_operation(item.options, 'options', path)!
		processed_item.head = processed.process_operation(item.head, 'head', path)!
		processed_item.trace = processed.process_operation(item.trace, 'trace', path)!

		processed.paths[path] = processed_item
	}

	return processed
}

fn (spec OpenAPI) process_operation(op Operation, method string, path string) !Operation {
	mut processed := Operation{...op
		responses: op.responses.clone()	
	}

	if op.is_empty() {
		return op
	}
	if processed.operation_id == '' {
		processed.operation_id = generate_operation_id(method, path)
	}

	if op.request_body is RequestBody {
		if content := op.request_body.content['application/json'] {
			if content.schema is Reference {
				mut req_body_ := RequestBody{...op.request_body
					content: op.request_body.content.clone()
				}
				req_body_.content['application/json'].schema = SchemaRef(spec.dereference_schema(content.schema)!)
				processed.request_body = RequestBodyRef(req_body_)
			}
		}
	}

	if response_spec := processed.responses['200']{
		mut processed_rs := ResponseSpec{...response_spec
			content: response_spec.content.clone()
		}
		if media_type := processed_rs.content['application/json'] {
			if media_type.schema is Reference {
				processed_rs.content['application/json'].schema = SchemaRef(spec.dereference_schema(media_type.schema)!)
			}
		}
		processed.responses['200'] = processed_rs
	}

	return processed
}

// Helper function to generate a unique operationId
fn generate_operation_id(method string, path string) string {
    // Convert HTTP method and path into a camelCase string
    method_part := method.to_lower()
    path_part := texttools.snake_case(path.all_before('{')
        .replace('/', '_') // Replace slashes with underscores
        .replace('{', '')  // Remove braces around path parameters
        .replace('}', '')  // Remove braces around path parameters
	)

    return '${method_part}_${path_part}'
}