module codegen

import freeflowuniverse.herolib.core.code { VFile, CodeItem, CustomCode, Function, Struct, parse_function }
import freeflowuniverse.herolib.schemas.jsonschema.codegen as jsonschema_codegen {schemaref_to_type}
import freeflowuniverse.herolib.schemas.openrpc {Method, ContentDescriptor}
import freeflowuniverse.herolib.core.texttools

// converts OpenRPC Method to Code Function
pub fn method_to_function(method Method) !Function {
	mut params := []code.Param{}
	for param in method.params {
		if param is ContentDescriptor {
			params << content_descriptor_to_parameter(param)!
		}
	}
	result := if method.result is ContentDescriptor {
		content_descriptor_to_parameter(method.result)!
	} else {
		panic('Method must be inflated')
	}

	return Function{
		name: texttools.name_fix_pascal_to_snake(method.name)
		params: params
		result: result
	}
}

pub fn content_descriptor_to_parameter(cd ContentDescriptor) !code.Param {
	return code.Param{
		name: cd.name
		typ: schemaref_to_type(cd.schema)
	}
}

// //
// pub fn (s Schema) to_struct() code.Struct {
// 	mut attributes := []Attribute{}
// 	if c.depracated {
// 		attributes << Attribute {name: 'deprecated'}
// 	}
// 	if !c.required {
// 		attributes << Attribute {name: 'params'}
// 	}

// 	return code.Struct {
// 		name: name
// 		description: summary
// 		required: required
// 		schema: Schema {

// 		}
// 		attrs: attributes
// 	}
// }
