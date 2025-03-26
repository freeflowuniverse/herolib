module jsonschema

import x.json2 as json

// Items represents either a single schema reference or an array of schema references.
// This type is used for the 'items' field in JSON Schema which can be either a schema
// or an array of schemas.
pub type Items = SchemaRef | []SchemaRef

// SchemaRef represents either a direct Schema object or a Reference to a schema.
// This allows for both inline schema definitions and references to external schemas.
pub type SchemaRef = Reference | Schema

// Reference represents a JSON Schema reference using the $ref keyword.
// References point to definitions in the same document or external documents.
pub struct Reference {
pub:
	// The reference path, e.g., "#/definitions/Person" or "http://example.com/schema.json#"
	ref string @[json: '\$ref'; omitempty]
}

// Number is a type alias for numeric values in JSON Schema.
pub type Number = int

// Schema represents a JSON Schema document according to the JSON Schema specification.
// This implementation is based on JSON Schema draft-07.
// See: https://json-schema.org/draft-07/json-schema-release-notes.html
pub struct Schema {
pub mut:
	// The $schema keyword identifies which version of JSON Schema the schema was written for
	schema string @[json: 'schema'; omitempty]

	// The $id keyword defines a URI for the schema
	id string @[json: 'id'; omitempty]

	// Human-readable title for the schema
	title string @[omitempty]

	// Human-readable description of the schema
	description string @[omitempty]

	// The data type for the schema (string, number, object, array, boolean, null)
	typ string @[json: 'type'; omitempty]

	// Object properties when type is "object"
	properties map[string]SchemaRef @[omitempty]

	// Controls additional properties not defined in the properties map
	additional_properties ?SchemaRef @[json: 'additionalProperties'; omitempty]

	// List of required property names
	required []string @[omitempty]

	// Schema for array items when type is "array"
	items ?Items @[omitempty]

	// Definitions of reusable schemas
	defs map[string]SchemaRef @[omitempty]

	// List of schemas, where data must validate against exactly one schema
	one_of []SchemaRef @[json: 'oneOf'; omitempty]

	// Semantic format of the data (e.g., "date-time", "email", "uri")
	format string @[omitempty]

	// === Validation for numbers ===
	// The value must be a multiple of this number
	multiple_of int @[json: 'multipleOf'; omitempty]

	// The maximum allowed value
	maximum int @[omitempty]

	// The exclusive maximum allowed value (value must be less than, not equal to)
	exclusive_maximum int @[json: 'exclusiveMaximum'; omitempty]

	// The minimum allowed value
	minimum int @[omitempty]

	// The exclusive minimum allowed value (value must be greater than, not equal to)
	exclusive_minimum int @[json: 'exclusiveMinimum'; omitempty]

	// Enumerated list of allowed values
	enum_ []string @[json: 'enum'; omitempty]

	// Example value that would validate against this schema (not used for validation)
	example json.Any @[json: '-']
}
