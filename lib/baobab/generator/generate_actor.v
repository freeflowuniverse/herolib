module generator

import freeflowuniverse.herolib.core.code { Folder, IFolder, IFile, VFile, CodeItem, File, Function, Import, Module, Struct, CustomCode }
import freeflowuniverse.herolib.schemas.openapi
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
	mut folders := []IFolder{}
	
	files = [
		generate_readme_file(spec)!,
		generate_actor_file(spec)!,
		generate_actor_test_file(spec)!,
		generate_specs_file(spec.name, params.interfaces)!,
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
				iface_file, iface_test_file := generate_openrpc_interface_files(params.interfaces)
				files << iface_file
				files << iface_test_file

				// add openrpc.json to docs
				// TODO
				docs_files << generate_openrpc_file(openrpc_spec)!
			}
			.openapi {
				// convert actor spec to openrpc spec
				openapi_spec_raw := spec.to_openapi()
				docs_files << generate_openapi_file(openapi_spec_raw)!
				
				openapi_spec := openapi.process(openapi_spec_raw)!
				// generate openrpc code files
				iface_file, iface_test_file := generate_openapi_interface_files(params.interfaces)
				files << iface_file
				files << iface_test_file

				// add openapi.json to docs
				folders << generate_openapi_ts_client(openapi_spec)!
			}
			.http {
				// interfaces that have http controllers
				controllers := params.interfaces.filter(it == .openrpc || it == .openapi)
				// generate openrpc code files
				iface_file, iface_test_file := generate_http_interface_files(controllers)
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
	folders << Folder {
		name: 'docs'
		files: docs_files
	}
	folders << generate_scripts_folder(spec.name, false)
	folders << generate_examples_folder(spec, params)!
	
	// create module with code files and docs folder
	name_fixed := texttools.snake_case(spec.name)
	return code.new_module(
		name: '${name_fixed}_actor'
		description: spec.description
		files: files
		folders: folders
		in_src: true
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
	actor_name_snake := texttools.snake_case(spec.name)
	actor_name_pascal := texttools.snake_case_to_pascal(spec.name)
	actor_code := $tmpl('./templates/actor.v.template')
	return VFile {
		name: 'actor'
		items: [CustomCode{actor_code}]
	}
}

fn generate_actor_example_file(spec ActorSpecification) !VFile {
	dollar := '$'
	actor_name_snake := texttools.snake_case(spec.name)
	actor_name_pascal := texttools.snake_case_to_pascal(spec.name)
	actor_code := $tmpl('./templates/actor_example.v.template')
	return VFile {
		name: 'actor_example'
		items: [CustomCode{actor_code}]
	}
}

fn generate_actor_test_file(spec ActorSpecification) !VFile {
	dollar := '$'
	actor_name_snake := texttools.snake_case(spec.name)
	actor_name_pascal := texttools.snake_case_to_pascal(spec.name)
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
	actor_name_snake := texttools.snake_case(name)
	actor_name_pascal := texttools.snake_case_to_pascal(name)
	actor_code := $tmpl('./templates/specifications.v.template')
	return VFile {
		name: 'specifications'
		items: [CustomCode{actor_code}]
	}
}

pub fn generate_examples_folder(spec ActorSpecification, params Params) !Folder {
	return Folder {
		name: 'examples'
		modules: [generate_example_actor_module(spec, params)!]
	}
}

pub fn generate_example_actor_module(spec ActorSpecification, params Params) !Module {
	mut files := []IFile{}
	mut folders := []IFolder{}
	
	files = [
		generate_readme_file(spec)!,
		generate_actor_example_file(spec)!,
		generate_specs_file(spec.name, params.interfaces)!,
		generate_handle_example_file(spec)!,
		generate_example_client_file(spec)!
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
				iface_file, iface_test_file := generate_openrpc_interface_files(params.interfaces)
				files << iface_file
				files << iface_test_file

				// add openrpc.json to docs
				// TODO
				docs_files << generate_openrpc_file(openrpc_spec)!
			}
			.openapi {
				// convert actor spec to openrpc spec
				openapi_spec := spec.to_openapi()
				
				// generate openrpc code files
				iface_file, iface_test_file := generate_openapi_interface_files(params.interfaces)
				files << iface_file
				files << iface_test_file

				// add openapi.json to docs
				docs_files << generate_openapi_file(openapi_spec)!
			}
			.http {
				// interfaces that have http controllers
				controllers := params.interfaces.filter(it == .openrpc || it == .openapi)
				// generate openrpc code files
				iface_file, iface_test_file := generate_http_interface_files(controllers)
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
	folders << Folder {
		name: 'docs'
		files: docs_files
	}
	folders << generate_scripts_folder('example_${spec.name}', true)
	
	// create module with code files and docs folder
	name_fixed := texttools.snake_case(spec.name)
	return code.new_module(
		name: 'example_${name_fixed}_actor'
		files: files
		folders: folders
	)
}