module generator

import freeflowuniverse.herolib.core.code {Folder, File}
import freeflowuniverse.herolib.core.texttools
import freeflowuniverse.herolib.schemas.jsonschema.codegen { schema_to_struct }
import freeflowuniverse.herolib.schemas.openrpc.codegen as openrpc_codegen { content_descriptor_to_parameter }
import freeflowuniverse.herolib.baobab.specification {ActorSpecification, ActorMethod, BaseObject} 

pub fn typescript_client_folder(spec ActorSpecification) code.Folder {
	return Folder {
		name: 'client_typescript'
		files: [
			ts_client_model_file(spec.objects),
			ts_client_methods_file(spec)
		]
	}
}

// generates a model.ts file for given base objects
fn ts_client_model_file(objs []BaseObject) File {
	return File {
		name: 'model'
		extension: 'ts'
		content: objs.map(schema_to_struct(it.schema) or {panic(err)})
		.map(it.typescript())
		.join_lines()
	}
}

// generates a methods.ts file for given actor methods
pub fn ts_client_methods_file(spec_ ActorSpecification) File {
	spec := spec_.validate()
	mut files := []File{}
	mut methods := []string{}

	// for each base object generate ts client methods
	// for the objects existing CRUD+LF methods
	for obj in spec.objects {
		if m := obj.new_method {
			methods << ts_client_new_fn(obj.name())
		}
		if m := obj.get_method {
			methods << ts_client_get_fn(obj.name())
		}
		if m := obj.set_method {
			methods << ts_client_set_fn(obj.name())
		}
		if m := obj.delete_method {
			methods << ts_client_delete_fn(obj.name())
		}
		if m := obj.list_method {
			methods << ts_client_list_fn(obj.name())
		}
		methods << obj.other_methods.map(ts_client_fn_prototype(it))
	}
	
	return File {
		name: 'methods'
		extension: 'ts'
		content: methods.join_lines()
	}
}

@[params]
pub struct TSClientFunctionParams {
	endpoint string // prefix for the Rest API endpoint
}

fn get_endpoint_root(root string) string {
	return if root == '' {
		''
	} else {
		"/${root.trim('/')}"
	}
}

// generates a Base Object's `create` method
pub fn ts_client_new_fn(object string, params TSClientFunctionParams) string {
	name_snake := texttools.name_fix_snake(object)
	name_pascal := texttools.name_fix_pascal(object)
	root := get_endpoint_root(params.endpoint)

	return "async create${name_snake}(object: Omit<${name_pascal}, 'id'>): Promise<${name_pascal}> {
        return this.restClient.post<${name_pascal}>('${root}/${name_snake}', board);
    }"
}

pub fn ts_client_get_fn(object string, params TSClientFunctionParams) string {
    name_snake := texttools.name_fix_snake(object)
    name_pascal := texttools.name_fix_pascal(object)
    root := get_endpoint_root(params.endpoint)

    return "async get${name_pascal}(id: string): Promise<${name_pascal}> {\n        return this.restClient.get<${name_pascal}>(`/${root}/${name_snake}/\${id}`);\n    }"
}

pub fn ts_client_set_fn(object string, params TSClientFunctionParams) string {
    name_snake := texttools.name_fix_snake(object)
    name_pascal := texttools.name_fix_pascal(object)
    root := get_endpoint_root(params.endpoint)

    return "async set${name_pascal}(id: string, ${name_snake}: Partial<${name_pascal}>): Promise<${name_pascal}> {\n        return this.restClient.put<${name_pascal}>(`/${root}/${name_snake}/\${id}`, ${name_snake});\n    }"
}

pub fn ts_client_delete_fn(object string, params TSClientFunctionParams) string {
    name_snake := texttools.name_fix_snake(object)
    name_pascal := texttools.name_fix_pascal(object)
    root := get_endpoint_root(params.endpoint)

    return "async delete${name_pascal}(id: string): Promise<void> {\n        return this.restClient.delete<void>(`/${root}/${name_snake}/\${id}`);\n    }"
}

pub fn ts_client_list_fn(object string, params TSClientFunctionParams) string {
    name_snake := texttools.name_fix_snake(object)
    name_pascal := texttools.name_fix_pascal(object)
    root := get_endpoint_root(params.endpoint)

    return "async list${name_pascal}(): Promise<${name_pascal}[]> {\n        return this.restClient.get<${name_pascal}[]>(`/${root}/${name_snake}`);\n    }"
}

// generates a function prototype given an `ActorMethod`
pub fn ts_client_fn_prototype(method ActorMethod) string {
	name := texttools.name_fix_pascal(method.name)
	params := method.parameters
		.map(content_descriptor_to_parameter(it) or {panic(err)})
		.map(it.typescript())
		.join(', ')
	
	return_type := content_descriptor_to_parameter(method.result) or {panic(err)}.typ.typescript()
	return 'async ${name}(${params}): Promise<${return_type}> {}'
}