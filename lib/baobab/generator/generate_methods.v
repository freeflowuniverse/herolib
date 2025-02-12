module generator

import freeflowuniverse.herolib.core.code { Array, Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode, Result }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}
	
const crud_prefixes = ['new', 'get', 'set', 'delete', 'list']

pub fn generate_methods_file(spec ActorSpecification) !VFile {
	name_snake := texttools.snake_case(spec.name)
	actor_name_pascal := texttools.snake_case_to_pascal(spec.name)
	
	receiver := generate_methods_receiver(spec.name)
	receiver_param := Param {
		mutable: true
		name: name_snake
		typ: code.Result{code.Object{receiver.name}}
	}

	mut items := [CodeItem(receiver), CodeItem(generate_core_factory(receiver_param))]
	for method in spec.methods {
		method_fn := generate_method_function(receiver_param, method)!
		// check if method is a Base Object CRUD Method and
		// if so generate the method's body
		body := match spec.method_type(method) {
			.base_object_new { base_object_new_body(method)! }
			.base_object_get { base_object_get_body(method)! }
			.base_object_set { base_object_set_body(method)! }
			.base_object_delete { base_object_delete_body(method)! }
			.base_object_list { base_object_list_body(method)! }
			else {"panic('implement')"}
		}
		items << Function{...method_fn, body: body}
	}
	
	return VFile {
		name: 'methods'
		imports: [Import{mod: 'freeflowuniverse.herolib.baobab.osis', types: ['OSIS']}]
		items: items
	}
}

fn generate_methods_receiver(name string) code.Struct {
	return code.Struct {
		is_pub: true
		name: '${texttools.pascal_case(name)}'
		embeds: [code.Struct{name:'OSIS'}]
	}
}

fn generate_core_factory(receiver code.Param) code.Function {
	return code.Function {
		is_pub: true
		name: 'new_${receiver.name}'
		body: "return ${receiver.typ.symbol().trim_left('!?')}{OSIS: osis.new()!}"
		result: receiver
	}
}

// returns bodyless method prototype
pub fn generate_method_function(receiver code.Param, method ActorMethod) !Function {
	result_param := content_descriptor_to_parameter(method.result)!
	return Function{
		name: texttools.snake_case(method.name)
		receiver: receiver
		result: Param {...result_param, typ: Result{result_param.typ}}
		summary: method.summary
		description: method.description
		params: method.parameters.map(content_descriptor_to_parameter(it)!)
	}
}

fn base_object_new_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.new[${parameter.typ.vgen()}](${texttools.snake_case(parameter.name)})!'
}

fn base_object_get_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	result := content_descriptor_to_parameter(method.result)!
	return 'return actor.osis.get[${result.typ.vgen()}](${texttools.snake_case(parameter.name)})!'
}

fn base_object_set_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.set[${parameter.typ.vgen()}](${parameter.name})!'
}

fn base_object_delete_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'actor.osis.delete(${texttools.snake_case(parameter.name)})!'
}

fn base_object_list_body(method ActorMethod) !string {
	result := content_descriptor_to_parameter(method.result)!
	base_object_type := (result.typ as Array).typ
	return 'return actor.osis.list[${base_object_type.symbol()}]()!'
}
