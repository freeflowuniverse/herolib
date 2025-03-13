module jsonschema

import x.json2 { Any }
import json

// decode parses a JSON string into a Schema object.
// This function is necessary because of limitations in V's JSON decoding for complex types.
// It handles special fields like 'properties', 'additionalProperties', and 'items' that
// require custom decoding logic due to their complex structure.
//
// Parameters:
//   - data: A JSON string representing a JSON Schema
//
// Returns:
//   - A fully populated Schema object or an error if parsing fails
pub fn decode(data string) !Schema {
	schema_map := json2.raw_decode(data)!.as_map()
	mut schema := json.decode(Schema, data)!
	for key, value in schema_map {
		if key == 'properties' {
			schema.properties = decode_schemaref_map(value.as_map())!
		} else if key == 'additionalProperties' {
			schema.additional_properties = decode_schemaref(value.as_map())!
		} else if key == 'items' {
			schema.items = decode_items(value)!
		}
	}
	return schema
}

// decode_items parses the 'items' field from a JSON Schema, which can be either
// a single schema or an array of schemas.
//
// Parameters:
//   - data: The raw JSON data for the 'items' field
//
// Returns:
//   - Either a single SchemaRef or an array of SchemaRef objects
pub fn decode_items(data Any) !Items {
	if data.str().starts_with('{') {
		// If the items field is an object, it's a single schema
		return decode_schemaref(data.as_map())!
	}
	if !data.str().starts_with('[') {
		return error('items field must either be list of schemarefs or a schemaref')
	}

	// If the items field is an array, it's a list of schemas
	mut items := []SchemaRef{}
	for val in data.arr() {
		items << decode_schemaref(val.as_map())!
	}
	return items
}

// decode_schemaref_map parses a map of schema references, typically used for the 'properties' field.
//
// Parameters:
//   - data_map: A map where keys are property names and values are schema references
//
// Returns:
//   - A map of property names to their corresponding schema references
pub fn decode_schemaref_map(data_map map[string]Any) !map[string]SchemaRef {
	mut schemaref_map := map[string]SchemaRef{}
	for key, val in data_map {
		schemaref_map[key] = decode_schemaref(val.as_map())!
	}
	return schemaref_map
}

// decode_schemaref parses a single schema reference, which can be either a direct schema
// or a reference to another schema via the $ref keyword.
//
// Parameters:
//   - data_map: The raw JSON data for a schema or reference
//
// Returns:
//   - Either a Reference object or a Schema object
pub fn decode_schemaref(data_map map[string]Any) !SchemaRef {
	if ref := data_map['\$ref'] {
		return Reference{
			ref: ref.str()
		}
	}
	return decode(data_map.str())!
}