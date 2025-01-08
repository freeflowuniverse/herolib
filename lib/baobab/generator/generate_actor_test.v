module generator

import freeflowuniverse.herolib.core.code
import freeflowuniverse.herolib.baobab.specification
import freeflowuniverse.herolib.schemas.openrpc
import freeflowuniverse.herolib.schemas.jsonschema
import os

const actor_spec = specification.ActorSpecification{
    name: 'Pet Store'
    structure: code.Struct{}
    interfaces: [.openrpc]
    methods: [
        specification.ActorMethod{
            name: 'list_pets'
            summary: 'List all pets'
            parameters: [openrpc.ContentDescriptor{
                name: 'limit'
                description: 'How many items to return at one time (max 100)'
                required: false
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'integer'
                    minimum: 1
                })
            }]
            result: openrpc.ContentDescriptor{
                name: 'pets'
                description: 'A paged array of pets'
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'array'
                    items: jsonschema.Items(jsonschema.SchemaRef(jsonschema.Reference{
                        ref: '#/components/schemas/Pet'
                    }))
                })
            }
        },
        specification.ActorMethod{
            name: 'create_pet'
            summary: 'Create a pet'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'newPetName'
                    description: 'Name of pet to create'
                    required: true
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                },
                openrpc.ContentDescriptor{
                    name: 'newPetTag'
                    description: 'Pet tag to create'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'petId'
                description: 'The ID of the created pet'
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'integer'
                })
            }
        },
        specification.ActorMethod{
            name: 'get_pet'
            summary: 'Info for a specific pet'
            parameters: [openrpc.ContentDescriptor{
                name: 'petId'
                description: 'The ID of the pet to retrieve'
                required: true
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'integer'
                })
            }]
            result: openrpc.ContentDescriptor{
                name: 'pet'
                description: 'The pet details'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Pet'
                })
            }
        },
        specification.ActorMethod{
            name: 'update_pet'
            summary: 'Update a pet'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'petId'
                    description: 'The ID of the pet to update'
                    required: true
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'integer'
                    })
                },
                openrpc.ContentDescriptor{
                    name: 'updatedPetName'
                    description: 'New name for the pet'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                },
                openrpc.ContentDescriptor{
                    name: 'updatedPetTag'
                    description: 'New tag for the pet'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'pet'
                description: 'The updated pet object'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Pet'
                })
            }
        },
        specification.ActorMethod{
            name: 'delete_pet'
            summary: 'Delete a pet'
            parameters: [openrpc.ContentDescriptor{
                name: 'petId'
                description: 'The ID of the pet to delete'
                required: true
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'integer'
                })
            }]
        }
    ]
    objects: [specification.BaseObject{
        schema: jsonschema.Schema{
            id: 'pet'
            title: 'Pet'
            description: 'A pet object'
            typ: 'object'
            properties: {
                'id': jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'integer'
                }),
                'name': jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'string'
                }),
                'tag': jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'string'
                })
            }
            required: ['id', 'name']
        }
    }]
}

const destination = '${os.dir(@FILE)}/testdata'

fn test_generate_plain_actor_module() {
    // plain actor module without interfaces
	actor_module := generate_actor_module(actor_spec)!
	actor_module.write(destination, 
        format: true
        overwrite: true
        compile: true
        test: true
    )!
}

fn test_generate_actor_module_with_openrpc_interface() {
    // plain actor module without interfaces
	actor_module := generate_actor_module(actor_spec, interfaces: [.openrpc])!
	actor_module.write(destination, 
        format: true
        overwrite: true
        compile: true
        test: true
    )!
}

fn test_generate_actor_module_with_openapi_interface() {
    // plain actor module without interfaces
	actor_module := generate_actor_module(actor_spec, 
        interfaces: [.openapi]
    )!
	actor_module.write(destination, 
        format: true
        overwrite: true
        compile: true
        test: true
    )!
}

fn test_generate_actor_module_with_all_interfaces() {
    // plain actor module without interfaces
	actor_module := generate_actor_module(actor_spec, 
        interfaces: [.openapi, .openrpc, .http]
    )!
	actor_module.write(destination, 
        format: true
        overwrite: true
        compile: true
        test: true
    )!
}
