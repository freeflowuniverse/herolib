module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode }
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
		body := if is_base_object_new_method(method) {
			generate_base_object_new_body(method)!
		} else if is_base_object_get_method(method) {
			generate_base_object_get_body(method)!
		} else if is_base_object_set_method(method) {
			generate_base_object_set_body(method)!
		} else if is_base_object_delete_method(method) {
			generate_base_object_delete_body(method)!
		} else if is_base_object_list_method(method) {
			generate_base_object_list_body(method)!
		} else {
			// default actor method body
			"panic('implement')"
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
	return Function{
		name: texttools.name_fix_snake(method.name)
		receiver: code.new_param(v: 'mut actor ${actor_name_pascal}Actor')!
		result: Param{...content_descriptor_to_parameter(method.result)!, is_result: true}
		summary: method.summary
		description: method.description
		params: method.parameters.map(content_descriptor_to_parameter(it)!)
	}
}

fn is_base_object_new_method(method ActorMethod) bool {
	return method.name.starts_with('new')
}

fn is_base_object_get_method(method ActorMethod) bool {
	return method.name.starts_with('get')
}

fn is_base_object_set_method(method ActorMethod) bool {
	return method.name.starts_with('set')
}

fn is_base_object_delete_method(method ActorMethod) bool {
	return method.name.starts_with('delete')
}

fn is_base_object_list_method(method ActorMethod) bool {
	return method.name.starts_with('list')
}

fn generate_base_object_new_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.new[${parameter.typ.vgen()}](${parameter.name})!'
}

fn generate_base_object_get_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	result := content_descriptor_to_parameter(method.result)!
	return 'return actor.osis.get[${result.typ.vgen()}](${parameter.name})!'
}

fn generate_base_object_set_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.set[${parameter.typ.vgen()}](${parameter.name})!'
}

fn generate_base_object_delete_body(method ActorMethod) !string {
	parameter := content_descriptor_to_parameter(method.parameters[0])!
	return 'return actor.osis.delete(${parameter.name})!'
}

fn generate_base_object_list_body(method ActorMethod) !string {
	result := content_descriptor_to_parameter(method.result)!
	return 'return actor.osis.list[${result.typ.vgen()}]()!'
}
