module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc
import freeflowuniverse.herolib.schemas.openrpc.codegen {content_descriptor_to_parameter}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}
import os
import json

pub fn generate_client_file(spec ActorSpecification) !VFile {
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	
	mut items := []CodeItem{}

	items << CustomCode {'
	pub struct Client {
		actor.Client
	}

	fn new_client() !Client {
		mut redis := redisclient.new(\'localhost:6379\')!
		mut rpc_q := redis.rpc_get(\'actor_\${name}\')
		return Client{
			rpc: rpc_q
		}
	}'}
	
	for method in spec.methods {
		items << generate_client_method(method)!
	}
	
	return VFile {
		imports: [
			Import{
				mod: 'freeflowuniverse.herolib.baobab.actor'
			},
			Import{
				mod: 'freeflowuniverse.herolib.core.redisclient'
			}
		]
		name: 'client'
		items: items
	}
}

pub fn generate_client_method(method ActorMethod) !Function {
	name_fixed := texttools.name_fix_snake(method.name)

	call_params := if method.parameters.len > 0 {
		method.parameters.map(it.name).join(', ')
	} else {''}

	body := "client.call_to_action(
	method: ${name_fixed}
	params: paramsparser.encode(${call_params}))"

	return Function {
		receiver: code.new_param(v: 'mut client Client')!
		result: code.new_param(v:'!')!
		name: name_fixed
		summary: method.summary
		description: method.description
		params: method.parameters.map(content_descriptor_to_parameter(it)!)
	}
}