module generator

import freeflowuniverse.herolib.core.codemodel { CodeItem, CustomCode, Import, VFile }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.core.codeparser
import freeflowuniverse.herolib.data.markdownparser
import freeflowuniverse.herolib.data.markdownparser.elements
import freeflowuniverse.herolib.rpc.openrpc
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.hero.baobab.specification { ActorMethod, ActorSpecification }
import os
import json

pub fn generate_client_file(spec ActorSpecification) !VFile {
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)

	mut items := []CodeItem{}

	items << CustomCode{'
	pub struct Client {
		actor.Client
	}

	fn new_client() Client {
		return Client{}
	}'}

	for method in spec.methods {
		items << CustomCode{generate_client_method(method)!}
	}

	return VFile{
		imports: [
			Import{
				mod: 'freeflowuniverse.herolib.data.paramsparser'
			},
			Import{
				mod: 'freeflowuniverse.herolib.hero.baobab.actor'
			},
		]
		name:    'client'
		items:   items
	}
}

pub fn generate_client_method(method ActorMethod) !string {
	name_fixed := texttools.name_fix_snake(method.name)
	mut handler := '// Method for ${name_fixed}\n'
	params := if method.func.params.len > 0 {
		method.func.params.map(it.vgen()).join(', ')
	} else {
		''
	}

	call_params := if method.func.params.len > 0 {
		method.func.params.map(it.name).join(', ')
	} else {
		''
	}

	handler += 'fn (mut client Client) ${name_fixed}(${params}) ! {
		client.call_to_action(
			method: ${name_fixed}
			params: paramsparser.encode(${call_params})
		)
	}'
	return handler
}
