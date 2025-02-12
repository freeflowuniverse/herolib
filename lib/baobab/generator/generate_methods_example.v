module generator

import freeflowuniverse.herolib.core.code { Array, Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode, Result }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc {Example}
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}

pub fn generate_methods_example_file(spec ActorSpecification) !VFile {
	name_snake := texttools.snake_case(spec.name)
	name_pascal := texttools.pascal_case(spec.name)
	
	receiver := generate_example_methods_receiver(spec.name)
	receiver_param := Param {
		mutable: true
		name: name_snake
		typ: code.Result{code.Object{receiver.name}}
	}
	mut items := [CodeItem(receiver), CodeItem(generate_core_example_factory(receiver_param))]
	for method in spec.methods {
		method_fn := generate_method_function(receiver_param, method)!
		items << Function{...method_fn, 
			body: generate_method_example_body(method_fn, method)!
		}
	}
	
	return VFile {
		name: 'methods_example'
		imports: [
			Import{mod: 'freeflowuniverse.herolib.baobab.osis', types: ['OSIS']},
			Import{mod: 'x.json2 as json'}
		]
		items: items
	}
}

fn generate_core_example_factory(receiver code.Param) code.Function {
	return code.Function {
		is_pub: true
		name: 'new_${receiver.name}_example'
		body: "return ${receiver.typ.symbol().trim_left('!?')}{OSIS: osis.new()!}"
		result: receiver
	}
}

fn generate_example_methods_receiver(name string) code.Struct {
	return code.Struct {
		is_pub: true
		name: '${texttools.pascal_case(name)}Example'
		embeds: [code.Struct{name:'OSIS'}]
	}
}

fn generate_method_example_body(func Function, method ActorMethod) !string {
	return if !method_is_void(method)! {
		if method.example.result is Example {
			"data := '${method.example.result.value}'
			return ${generate_decode_stmt('data', method.result)!}"
		} else {
			"return ${func.result.typ.empty_value()}"
		}
	} else {
		""
	}
}