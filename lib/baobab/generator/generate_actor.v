module generator

import freeflowuniverse.herolib.core.code { Folder, IFile, VFile, CodeItem, File, Function, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.baobab.specification {ActorMethod, ActorSpecification, ActorInterface}
import json

@[params]
pub struct Params {
pub:
	interfaces []ActorInterface // the interfaces to be supported
}

pub fn generate_actor_module(spec ActorSpecification, params Params) !Module {
	mut files := []IFile{}
	
	files = [
		generate_readme_file(spec)!,
		generate_actor_file(spec)!,
		generate_specs_file(spec.name, params.interfaces)!,
		generate_actor_test_file(spec)!,
		generate_handle_file(spec)!,
		generate_methods_file(spec)!
		generate_client_file(spec)!
		generate_model_file(spec)!
	]

	mut docs_files := []IFile{}

	// generate code files for supported interfaces
	for iface in params.interfaces {
		match iface {
			.openrpc {
				// convert actor spec to openrpc spec
				openrpc_spec := spec.to_openrpc()
				
				// generate openrpc code files
				// files << generate_openrpc_client_file(openrpc_spec)!
				// files << generate_openrpc_client_test_file(openrpc_spec)!
				iface_file, iface_test_file := generate_openrpc_interface_files()
				files << iface_file
				files << iface_test_file

				// add openrpc.json to docs
				docs_files << generate_openrpc_file(openrpc_spec)!
			}
			.openapi {
				// convert actor spec to openrpc spec
				openapi_spec := spec.to_openapi()
				
				// generate openrpc code files
				iface_file, iface_test_file := generate_openapi_interface_files()
				files << iface_file
				files << iface_test_file

				// add openrpc.json to docs
				docs_files << generate_openapi_file(openapi_spec)!
			}
			.http {
				// generate openrpc code files
				iface_file, iface_test_file := generate_http_interface_files()
				files << iface_file
				files << iface_test_file
			}
			.command {
				files << generate_command_file(spec)!
			}
			else {
				return error('unsupported interface ${iface}')
			}
		}
	}


	// folder with docs
	docs_folder := Folder {
		name: 'docs'
		files: docs_files
	}
	
	// create module with code files and docs folder
	name_fixed := texttools.name_fix_snake(spec.name)
	return code.new_module(
		name: '${name_fixed}_actor'
		files: files
		folders: [
			docs_folder,
			generate_scripts_folder()
		]
	)
}

fn generate_readme_file(spec ActorSpecification) !File {
	return File{
		name: 'README'
		extension: 'md'
		content: '# ${spec.name}\n${spec.description}'
	}
}

fn generate_actor_file(spec ActorSpecification) !VFile {
	dollar := '$'
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	actor_code := $tmpl('./templates/actor.v.template')
	return VFile {
		name: 'actor'
		items: [CustomCode{actor_code}]
	}
}

fn generate_actor_test_file(spec ActorSpecification) !VFile {
	dollar := '$'
	actor_name_snake := texttools.name_fix_snake(spec.name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(spec.name)
	actor_test_code := $tmpl('./templates/actor_test.v.template')
	return VFile {
		name: 'actor_test'
		items: [CustomCode{actor_test_code}]
	}
}

fn generate_specs_file(name string, interfaces []ActorInterface) !VFile {
	support_openrpc := ActorInterface.openrpc in interfaces
	support_openapi := ActorInterface.openapi in interfaces
	dollar := '$'
	actor_name_snake := texttools.name_fix_snake(name)
	actor_name_pascal := texttools.name_fix_snake_to_pascal(name)
	actor_code := $tmpl('./templates/specifications.v.template')
	return VFile {
		name: 'specifications'
		items: [CustomCode{actor_code}]
	}
}
