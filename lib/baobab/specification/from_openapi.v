module specification

import freeflowuniverse.herolib.core.code { Struct, Function }
import freeflowuniverse.herolib.schemas.jsonschema { Schema, SchemaRef }
import freeflowuniverse.herolib.schemas.openapi { Operation, Parameter, OpenAPI, Components, Info, PathItem, ServerSpec }
import freeflowuniverse.herolib.schemas.openrpc { ExamplePairing, Example, ExampleRef, ContentDescriptor, ErrorSpec }

// Helper function: Convert OpenAPI parameter to ContentDescriptor
fn openapi_param_to_content_descriptor(param Parameter) ContentDescriptor {
	return ContentDescriptor{
		name: param.name,
		summary: param.description,
		description: param.description,
		required: param.required,
		schema: param.schema
	}
}

// Helper function: Convert OpenAPI parameter to ContentDescriptor
fn openapi_param_to_example(param Parameter) ?Example {
	if param.schema is Schema {
		if param.schema.example.str() != '' {
			return Example{
				name: 'Example ${param.name}',
				description: 'Example ${param.description}',
				value: param.schema.example
			}
		}
	}
	return none
}

// Helper function: Convert OpenAPI operation to ActorMethod
fn openapi_operation_to_actor_method(info openapi.OperationInfo) ActorMethod {
	mut parameters := []ContentDescriptor{}
	mut example_parameters:= []Example{}
	
	for param in info.operation.parameters {
		parameters << openapi_param_to_content_descriptor(param)
		example_parameters << openapi_param_to_example(param) or {
			continue
		}
	}

	response_200 := info.operation.responses['200'].content['application/json']

	mut result := ContentDescriptor{
		name: "result",
		description: "The response of the operation.",
		required: true,
		schema: response_200.schema
	}

	example_result := if response_200.example.str() != '' {
		Example{
			name: 'Example response',
			value: response_200.example
		}
	} else {Example{}}

	pairing := if example_result != Example{} || example_parameters.len > 0 {
		ExamplePairing{
			params: example_parameters.map(ExampleRef(it))
			result: ExampleRef(example_result)
		} 
	} else {ExamplePairing{}}

	mut errors := []ErrorSpec{}
	for status, response in info.operation.responses {
		if status.int() >= 400 {
			error_schema := if response.content.len > 0 {
				response.content.values()[0].schema
			} else {Schema{}}
			errors << ErrorSpec{
				code: status.int(),
				message: response.description,
				data: error_schema, // Extend if error schema is defined
			}
		}
	}

	return ActorMethod{
		name: info.operation.operation_id,
		description: info.operation.description,
		summary: info.operation.summary,
		parameters: parameters,
		example: pairing
		result: result,
		errors: errors,
	}
}

// Helper function: Convert OpenAPI schema to Struct
fn openapi_schema_to_struct(name string, schema SchemaRef) Struct {
	// Assuming schema properties can be mapped to Struct fields
	return Struct{
		name: name,
	}
}

// Converts OpenAPI to ActorSpecification
pub fn from_openapi(spec_raw OpenAPI) !ActorSpecification {
	spec := openapi.process(spec_raw)!
	mut objects := []BaseObject{}

	// get all operations for path as list of tuple [](path_string, http.Method, openapi.Operation)
	
	// Extract methods from OpenAPI paths
	// for path, item in spec.paths {
	// 	if item.get.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.get, item.get.operation_id, path)
	// 	}
	// 	if item.post.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.post, item.post.operation_id, path)
	// 	}
	// 	if item.put.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.put, item.put.operation_id, path)
	// 	}
	// 	if item.delete.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.delete, item.delete.operation_id, path)
	// 	}
	// 	if item.patch.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.patch, item.patch.operation_id, path)
	// 	}
	// 	if item.head.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.head, item.head.operation_id, path)
	// 	}
	// 	if item.options.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.options, item.options.operation_id, path)
	// 	}
	// 	if item.trace.operation_id != '' {
	// 		methods << openapi_operation_to_actor_method(item.trace, item.trace.operation_id, path)
	// 	}
	// }

	// Extract objects from OpenAPI components.schemas
	for name, schema in spec.components.schemas {
		objects << BaseObject{schema: schema as Schema}
	}

	return ActorSpecification{
		openapi: spec_raw
		name: spec.info.title,
		description: spec.info.description,
		structure: Struct{}, // Assuming no top-level structure for this use case
		interfaces: [.openapi], // Default to OpenAPI for input
		methods: spec.get_operations().map(openapi_operation_to_actor_method(it)),
		objects: objects,
	}
}