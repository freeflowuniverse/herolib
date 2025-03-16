module generator

import freeflowuniverse.herolib.core.code { Array, Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode, Result }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}

pub fn generate_methods_interface_file(spec ActorSpecification) !VFile {
	return VFile {
		name: 'methods_interface'
		imports: [Import{mod: 'freeflowuniverse.herolib.baobab.osis', types: ['OSIS']}]
		items: [code.CodeItem(generate_methods_interface_declaration(spec)!)]
	}
}

// returns bodyless method prototype
pub fn generate_methods_interface_declaration(spec ActorSpecification) !code.Interface {
	name_snake := texttools.snake_case(spec.name)
	name_pascal := texttools.pascal_case(spec.name)
	receiver := generate_methods_receiver(spec.name)
	receiver_param := Param {
		mutable: true
		name: name_snake[0].ascii_str()
		typ: code.Object{receiver.name}
	}
	return code.Interface {
		is_pub: true
		name: 'I${name_pascal}'
		methods: spec.methods.map(generate_method_prototype(receiver_param, it)!)
	}
}
