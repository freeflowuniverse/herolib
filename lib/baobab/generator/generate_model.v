module generator

import freeflowuniverse.herolib.core.code { CodeItem, Struct, VFile }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.jsonschema.codegen { schema_to_struct }
import freeflowuniverse.herolib.baobab.specification { ActorSpecification }

pub fn generate_model_file(spec ActorSpecification) !VFile {
	actor_name_snake := texttools.snake_case(spec.name)
	actor_name_pascal := texttools.pascal_case(spec.name)

	return VFile{
		name:  'model'
		items: spec.objects.map(CodeItem(Struct{
			...schema_to_struct(it.schema)
			is_pub: true
		}))
	}
}
