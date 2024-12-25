module jsonschema

import freeflowuniverse.herolib.code.codemodel
import freeflowuniverse.herolib.ui.console

fn test_struct_to_schema() {
	struct_ := codemodel.Struct{
		name:        'test_name'
		description: 'a codemodel struct to test struct to schema serialization'
		fields:      [
			codemodel.StructField{
				name:        'test_field'
				description: 'a field of the test struct to test fields serialization into schema'
				typ:         codemodel.Type{
					symbol: 'string'
				}
			},
		]
	}

	schema := struct_to_schema(struct_)
	console.print_debug(schema)
}
