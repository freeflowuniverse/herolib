module specification

import freeflowuniverse.herolib.schemas.jsonschema { Schema, SchemaRef }
import freeflowuniverse.herolib.schemas.openapi { Operation, Parameter, OpenAPI, Components, Info, PathItem, ServerSpec }

// Converts ActorSpecification to OpenAPI
pub fn (s ActorSpecification) to_openapi() OpenAPI {
	mut paths := map[string]PathItem{}

	// Map ActorMethods to paths
	for method in s.methods {
		mut op := Operation{
			summary: method.summary,
			description: method.description,
			operation_id: method.name,
		}

		// Convert parameters to OpenAPI format
		for param in method.parameters {
			op.parameters << Parameter{
				name: param.name,
				in_: 'query', // Default to query parameters; adjust based on function context
				description: param.description,
				required: param.required,
				schema: param.schema,
			}
		}

		// Assign operation to corresponding HTTP method
		// TODO: what about other verbs
		paths['/${method.name}'] = PathItem{get: op}
	}

	mut schemas := map[string]SchemaRef{}
	for object in s.objects {
		schemas[object.schema.id] = object.to_schema()
	}

	return OpenAPI{
		openapi: '3.0.0',
		info: Info{
			title: s.name,
			summary: s.description,
			description: s.description,
			version: '1.0.0',
		},
		servers: [
			ServerSpec{
				url: 'http://localhost:8080',
				description: 'Default server',
			},
		],
		paths: paths,
		components: Components{
			schemas: schemas
		},
	}
}

fn (bo BaseObject) to_schema() Schema {
	return Schema{}
}