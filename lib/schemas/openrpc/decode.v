module openrpc

import json
import x.json2 { Any }
import freeflowuniverse.herolib.schemas.jsonschema { Reference, decode_schemaref }

pub fn decode(data string) !OpenRPC {
	mut object := json.decode(OpenRPC, data) or { return error('Failed to decode json\n${err}') }
	data_map := json2.raw_decode(data)!.as_map()
	if 'components' in data_map {
		object.components = decode_components(data_map) or {
			return error('Failed to decode components\n${err}')
		}
	}

	methods_any := data_map['methods'] or {return object}
	for i, method in methods_any.arr() {
		method_map := method.as_map()
		
		if result_any := method_map['result'] {
			object.methods[i].result = decode_content_descriptor_ref(result_any.as_map()) or {
				return error('Failed to decode result\n${err}')
			}
		}
		if params_any := method_map['params'] {
			params_arr := params_any.arr()
			object.methods[i].params = params_arr.map(decode_content_descriptor_ref(it.as_map()) or {
				return error('Failed to decode params\n${err}')
			})
		}
	}
	// object.methods = decode_method(data_map['methods'].as_array)!
	return object
}

// fn decode_method(data_map map[string]Any) !Method {
// 	method := Method {
// 		name: data_map['name']
// 		description: data_map['description']
// 		result: json.decode(data_map['result'])
// 	}

// 	return method
// }

// fn decode_method_param(data_map map[string]Any) !Method {
// 	method := Method {}

// 	return method
// }

fn decode_components(data_map map[string]Any) !Components {
	mut components := Components{}
	mut components_map := map[string]Any
	if components_any := data_map['components'] {
		components_map = components_any.as_map()
	}

	if cd_any := components_map['contentDescriptors'] {
		descriptors_map := cd_any.as_map()
		for key, value in descriptors_map {
			descriptor := decode_content_descriptor_ref(value.as_map())!
			components.content_descriptors[key] = descriptor
		}
	}

	if schemas_any := components_map['schemas'] {
		schemas_map := schemas_any.as_map()
		for key, value in schemas_map {
			schema := jsonschema.decode(value.str())!
			components.schemas[key] = schema
		}
	}

	return components
}

fn decode_content_descriptor_ref(data_map map[string]Any) !ContentDescriptorRef {
	if ref_any := data_map['\$ref'] {
		return Reference{
			ref: ref_any.str()
		}
	}
	mut descriptor := json.decode(ContentDescriptor, data_map.str())!
	if schema_any := data_map['schema'] {
		descriptor.schema = decode_schemaref(schema_any.as_map())!
	}
	return descriptor
}
