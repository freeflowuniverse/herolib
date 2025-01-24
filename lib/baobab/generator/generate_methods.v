module generator

import freeflowuniverse.herolib.core.code { Array, Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode, Result }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}
	
const crud_prefixes = ['new', 'get', 'set', 'delete', 'list']

pub fn generate_methods_file(spec ActorSpecification) !VFile {
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	
	mut items := []CodeItem{}
	for method in spec.methods {
		method_fn := generate_method_function(spec.name, method)!
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
		items: items
	}
}

// returns bodyless method prototype
pub fn generate_method_function(actor_name string, method ActorMethod) !Function {
	actor_name_pascal := texttools.name_fix_snake_to_pascal(actor_name)
	result_param := content_descriptor_to_parameter(method.result)!
	return Function{
		name: texttools.name_fix_snake(method.name)
		receiver: code.new_param(v: 'mut actor ${actor_name_pascal}Actor')!
		result: Param {...result_param, typ: Result{result_param.typ}}
		summary: method.summary
		description: method.description
		params: method.parameters.map(content_descriptor_to_parameter(it)!)
	}
}

fn base_object_new_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.new[${parameter.typ.vgen()}](${texttools.name_fix_snake(parameter.name)})!'
}

fn base_object_get_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	result := content_descriptor_to_parameter(method.result)!
	return 'return actor.osis.get[${result.typ.vgen()}](${texttools.name_fix_snake(parameter.name)})!'
}

fn base_object_set_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.set[${parameter.typ.vgen()}](${parameter.name})!'
}

fn base_object_delete_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'actor.osis.delete(${texttools.name_fix_snake(parameter.name)})!'
}

fn base_object_list_body(method ActorMethod) !string {
	result := content_descriptor_to_parameter(method.result)!
	base_object_type := (result.typ as Array).typ
	return 'return actor.osis.list[${base_object_type.symbol()}]()!'
}
