module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Param, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}
import os
import json

pub fn generate_methods_file(spec ActorSpecification) !VFile {
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	
	mut items := []CodeItem{}
	for method in spec.methods {
		items << generate_method_function(spec.name, method)!
	}
	
	return VFile {
		name: 'methods'
		items: items
	}
}

pub fn generate_method_function(actor_name string, method ActorMethod) !Function {
	actor_name_pascal := texttools.name_fix_snake_to_pascal(actor_name)
	return Function{
		name: texttools.name_fix_snake(method.name)
		receiver: code.new_param(v: 'mut actor ${actor_name_pascal}Actor')!
		result: Param{...content_descriptor_to_parameter(method.result)!, is_result: true}
		body:"panic('implement')"
		summary: method.summary
		description: method.description
		params: method.parameters.map(content_descriptor_to_parameter(it)!)
	}
}