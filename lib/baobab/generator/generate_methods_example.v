module generator

import freeflowuniverse.herolib.core.code { Array, Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode, Result }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc {Example}
import freeflowuniverse.herolib.schemas.jsonschema {Schema}
import freeflowuniverse.herolib.schemas.jsonschema.codegen as jsonschema_codegen {schema_to_struct}
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}

pub fn generate_methods_example_file(spec ActorSpecification) !VFile {
	name_snake := texttools.snake_case(spec.name)
	name_pascal := texttools.pascal_case(spec.name)
	
	receiver := generate_example_methods_receiver(spec.name)
	receiver_param := Param {
		mutable: true
		name: name_snake[0].ascii_str()
		typ: code.Result{code.Object{receiver.name}}
	}
	mut items := [CodeItem(receiver), CodeItem(generate_core_example_factory(receiver_param))]
	for method in spec.methods {
		items << generate_method_example_code(receiver_param, ActorMethod{...method, category: spec.method_type(method)})!
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
		name: 'new_${texttools.snake_case(receiver.typ.symbol())}'
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


// returns bodyless method prototype
pub fn generate_method_example_code(receiver code.Param, method ActorMethod) ![]CodeItem {
	result_param := content_descriptor_to_parameter(method.result)!
	
	mut method_code := []CodeItem{}
	// TODO: document assumption
	// obj_params := method.parameters.filter(if it.schema is Schema {it.schema.typ == 'object'} else {false}).map(schema_to_struct(it.schema as Schema))
	// if obj_param := obj_params[0] {
	// 	method_code << Struct{...obj_param, name: method.name}
	// }

	// check if method is a Base Object CRUD Method and
		// if so generate the method's body
		body := if !method_is_void(method)! {
		if method.example.result is Example {
			"json_str := '${method.example.result.value}'
			return ${generate_decode_stmt('json_str', method.result)!}"
		} else {
			"return ${result_param.typ.empty_value()}"
		}
	} else {
		""
	}

	fn_prototype := generate_method_prototype(receiver, method)!
	method_code << Function{
		...fn_prototype
		body: body
	}
	return method_code
}