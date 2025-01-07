module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}

pub fn generate_model_file(spec ActorSpecification) !VFile {
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	
	return VFile {
		name: 'model'
		items: spec.objects.map(CodeItem(it.structure))
	}
}