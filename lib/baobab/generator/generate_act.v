module generator

import freeflowuniverse.herolib.core.code { Result, Object, Param, Folder, IFile, VFile, CodeItem, File, Function, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.openrpc {ContentDescriptor}
import freeflowuniverse.herolib.schemas.jsonschema.codegen {schemaref_to_type}
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification}

fn generate_handle_file(spec ActorSpecification) !VFile {
	mut items := []CodeItem{}
	items << CustomCode{generate_handle_function(spec)}
	for method in spec.methods {
		items << generate_method_handle(spec.name, method)!
	}
	return VFile {
		name: 'act'
		imports: [
			Import{mod:'freeflowuniverse.herolib.baobab.stage' types:['Action']}
			Import{mod:'x.json2 as json'}
		]
		items: items
	}
}

pub fn generate_handle_function(spec ActorSpecification) string {
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	mut operation_handlers := []string{}
	mut routes := []string{}

	// Iterate over OpenAPI paths and operations
	for method in spec.methods {
		operation_id := method.name
		params := method.parameters.map(it.name).join(', ')

		// Generate route case
		route := generate_route_case(method.name, operation_id)
		routes << route
	}

	// Combine the generated handlers and main router into a single file
	return [
		'// AUTO-GENERATED FILE - DO NOT EDIT MANUALLY',
		'',
		'pub fn (mut actor ${actor_name_pascal}Actor) act(action Action) !Action {',
		'    return match action.name {',
		routes.join('\n'),
		'        else {',
		'            return error("Unknown operation: \${action.name}")',
		'        }',
		'    }',
		'}',
	].join('\n')
}

pub fn generate_method_handle(actor_name string, method ActorMethod) !Function {
	actor_name_pascal := texttools.name_fix_snake_to_pascal(actor_name)
	name_fixed := texttools.name_fix_snake(method.name)
	mut body := ''
	if method.parameters.len == 1 {
		param := method.parameters[0]
		param_name := texttools.name_fix_snake(param.name)
		decode_stmt := generate_decode_stmt('action.params', param)!
		body += '${param_name} := ${decode_stmt}\n'
	}
	if method.parameters.len > 1 {
		body += 'params_arr := json.raw_decode(action.params)!.arr()\n'
		for i, param in method.parameters {
			param_name := texttools.name_fix_snake(param.name)
			decode_stmt := generate_decode_stmt('params_arr[${i}]', param)!
			body += '${param_name} := ${decode_stmt}'
		}
	}
	call_stmt := generate_call_stmt(method)!
	body += '${call_stmt}\n'
	body += '${generate_return_stmt(method)!}\n'
	return Function {
		name: 'handle_${name_fixed}'
		description: '// Handler for ${name_fixed}\n'
		receiver: Param{name: 'actor', mutable: true, typ: Object{'${actor_name_pascal}Actor'}}
		params: [Param{name: 'action', typ: Object{'Action'}}]
		result: Param{typ: Result{Object{'Action'}}}
		body: body
	}
}

fn generate_call_stmt(method ActorMethod) !string {
	mut call_stmt := if schemaref_to_type(method.result.schema)!.vgen().trim_space() != '' {
		'${texttools.name_fix_snake(method.result.name)} := '
	} else {''}
	name_fixed := texttools.name_fix_snake(method.name)
	param_names := method.parameters.map(texttools.name_fix_snake(it.name))
	call_stmt += 'actor.${name_fixed}(${param_names.join(", ")})!'
	return call_stmt
}

fn generate_return_stmt(method ActorMethod) !string {
	if schemaref_to_type(method.result.schema)!.vgen().trim_space() != '' {
		return 'return Action{...action, result: json.encode(${texttools.name_fix_snake(method.result.name)})}'
	} 
	return "return action"
}

// generates decode statement for variable with given name
fn generate_decode_stmt(name string, param ContentDescriptor) !string {
	param_type := schemaref_to_type(param.schema)!
	if param_type is Object {
		return 'json.decode[${schemaref_to_type(param.schema)!.vgen()}](${name})'
	}
	// else if param.schema.typ == 'array' {
	// 	return 'json2.decode[${schemaref_to_type(param.schema)!.vgen()}](${name})'
	// }
	param_symbol := param_type.vgen()
	return if param_symbol == 'string' {
		'${name}.str()'
	} else {'${name}.${param_type.vgen()}()'}
}

// Helper function to generate a case block for the main router
fn generate_route_case(method string, operation_id string) string {
	name_fixed := texttools.name_fix_snake(operation_id)
	return "'${operation_id}' {actor.handle_${name_fixed}(action)}"
}