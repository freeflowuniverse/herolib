module specification

import freeflowuniverse.herolib.core.code { Struct, Function }
import freeflowuniverse.herolib.schemas.openrpc { ContentDescriptor, ErrorSpec }
import freeflowuniverse.herolib.schemas.openapi { OpenAPI, Info, ServerSpec, Components, Operation, PathItem, PathRef }
import freeflowuniverse.herolib.schemas.jsonschema {Schema, Reference, SchemaRef}

const openrpc_spec = openrpc.OpenRPC{
    openrpc: '1.0.0-rc1'
    info: openrpc.Info{
        title: 'Petstore'
        license: openrpc.License{
            name: 'MIT'
        }
        version: '1.0.0'
    }
    servers: [openrpc.Server{
        name: 'localhost'
        url: openrpc.RuntimeExpression('http://localhost:8080')
    }]
    methods: [
        openrpc.Method{
            name: 'list_pets'
            summary: 'List all pets'
            params: [openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                name: 'limit'
                description: 'How many items to return at one time (max 100)'
                required: false
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'integer'
                    minimum: 1
                })
            })]
            result: openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                name: 'pets'
                description: 'A paged array of pets'
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'array'
                    items: jsonschema.Items(jsonschema.SchemaRef(jsonschema.Reference{
                        ref: '#/components/schemas/Pet'
                    }))
                })
            })
            examples: [openrpc.ExamplePairing{
                name: 'listPetExample'
                description: 'List pet example'
            }]
        },
        openrpc.Method{
            name: 'create_pet'
            summary: 'Create a pet'
            params: [
                openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                    name: 'newPetName'
                    description: 'Name of pet to create'
                    required: true
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }),
                openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                    name: 'newPetTag'
                    description: 'Pet tag to create'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                })
            ]
            result: openrpc.ContentDescriptorRef(jsonschema.Reference{
                ref: '#/components/contentDescriptors/PetId'
            })
            examples: [openrpc.ExamplePairing{
                name: 'createPetExample'
                description: 'Create pet example'
            }]
        },
        openrpc.Method{
            name: 'get_pet'
            summary: 'Info for a specific pet'
            params: [openrpc.ContentDescriptorRef(jsonschema.Reference{
                ref: '#/components/contentDescriptors/PetId'
            })]
            result: openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                name: 'pet'
                description: 'Expected response to a valid request'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Pet'
                })
            })
            examples: [openrpc.ExamplePairing{
                name: 'getPetExample'
                description: 'Get pet example'
            }]
        },
        openrpc.Method{
            name: 'update_pet'
            summary: 'Update a pet'
            params: [
                openrpc.ContentDescriptorRef(jsonschema.Reference{
                    ref: '#/components/contentDescriptors/PetId'
                }),
                openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                    name: 'updatedPetName'
                    description: 'New name for the pet'
                    required: true
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }),
                openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                    name: 'updatedPetTag'
                    description: 'New tag for the pet'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                })
            ]
            result: openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                name: 'pet'
                description: 'Updated pet object'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Pet'
                })
            })
            examples: [openrpc.ExamplePairing{
                name: 'updatePetExample'
                description: 'Update pet example'
            }]
        },
        openrpc.Method{
            name: 'delete_pet'
            summary: 'Delete a pet'
            params: [openrpc.ContentDescriptorRef(jsonschema.Reference{
                ref: '#/components/contentDescriptors/PetId'
            })]
            result: openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                name: 'success'
                description: 'Boolean indicating success'
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'boolean'
                })
            })
            examples: [openrpc.ExamplePairing{
                name: 'deletePetExample'
                description: 'Delete pet example'
            }]
        }
    ]
    components: openrpc.Components{
        content_descriptors: {
            'PetId': openrpc.ContentDescriptorRef(openrpc.ContentDescriptor{
                name: 'petId'
                description: 'The ID of the pet'
                required: true
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/PetId'
                })
            })
        }
        schemas: {
            'PetId': jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'integer'
                minimum: 0
            }),
            'Pet': jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'object'
                properties: {
                    'id': jsonschema.SchemaRef(jsonschema.Reference{
                        ref: '#/components/schemas/PetId'
                    }),
                    'name': jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    }),
                    'tag': jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }
                required: ['id', 'name']
            })
        }
    }
}


const actor_spec = specification.ActorSpecification{
    name: 'Petstore'
    structure: code.Struct{
        is_pub: false
    }
    interfaces: [.openrpc]
    methods: [specification.ActorMethod{
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
                items: jsonschema.Items(jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'object'
                    properties: {
                        'id': jsonschema.SchemaRef(jsonschema.Reference{
                            ref: '#/components/schemas/PetId'
                        }),
                        'name': jsonschema.SchemaRef(jsonschema.Schema{
                            typ: 'string'
                        }),
                        'tag': jsonschema.SchemaRef(jsonschema.Schema{
                            typ: 'string'
                        })
                    }
                    required: ['id', 'name']
                }))
            })
        }
    }, specification.ActorMethod{
        name: 'create_pet'
        summary: 'Create a pet'
        parameters: [openrpc.ContentDescriptor{
            name: 'newPetName'
            description: 'Name of pet to create'
            required: true
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'string'
            })
        }, openrpc.ContentDescriptor{
            name: 'newPetTag'
            description: 'Pet tag to create'
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'string'
            })
        }]
    }, specification.ActorMethod{
        name: 'get_pet'
        summary: 'Info for a specific pet'
        result: openrpc.ContentDescriptor{
            name: 'pet'
            description: 'Expected response to a valid request'
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'object'
                properties: {
                    'id': jsonschema.SchemaRef(jsonschema.Reference{
                        ref: '#/components/schemas/PetId'
                    }),
                    'name': jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    }),
                    'tag': jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }
                required: ['id', 'name']
            })
        }
    }, specification.ActorMethod{
        name: 'update_pet'
        summary: 'Update a pet'
        parameters: [openrpc.ContentDescriptor{
            name: 'updatedPetName'
            description: 'New name for the pet'
            required: true
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'string'
            })
        }, openrpc.ContentDescriptor{
            name: 'updatedPetTag'
            description: 'New tag for the pet'
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'string'
            })
        }]
        result: openrpc.ContentDescriptor{
            name: 'pet'
            description: 'Updated pet object'
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'object'
                properties: {
                    'id': jsonschema.SchemaRef(jsonschema.Reference{
                        ref: '#/components/schemas/PetId'
                    }),
                    'name': jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    }),
                    'tag': jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'string'
                    })
                }
                required: ['id', 'name']
            })
        }
    }, specification.ActorMethod{
        name: 'delete_pet'
        summary: 'Delete a pet'
        result: openrpc.ContentDescriptor{
            name: 'success'
            description: 'Boolean indicating success'
            schema: jsonschema.SchemaRef(jsonschema.Schema{
                typ: 'boolean'
            })
        }
    }]
    objects: [specification.BaseObject{
        schema: jsonschema.Schema{
            id: 'pet'
            title: 'Pet'
            typ: 'object'
            properties: {
                'id': jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/PetId'
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

pub fn test_from_openrpc() ! {
    actor_spec_ := from_openrpc(openrpc_spec)!
    assert actor_spec_.methods.len == actor_spec.methods.len
    assert_methods_match(actor_spec_.methods[0], actor_spec.methods[0])
	
    
    // assert from_openrpc(openrpc_spec)! == actor_spec
}

fn assert_methods_match(a ActorMethod, b ActorMethod) {
    // Compare method names
    assert a.name == b.name, 'Method names do not match: ${a.name} != ${b.name}'
    
    // Compare summaries
    assert a.summary == b.summary, 'Method summaries do not match for method ${a.name}.'

    // Compare descriptions
    assert a.description == b.description, 'Method descriptions do not match for method ${a.name}.'

    // Compare parameters count
    assert a.parameters.len == b.parameters.len, 'Parameter counts do not match for method ${a.name}.'

    // Compare each parameter
    for i, param_a in a.parameters {
        assert_params_match(param_a, b.parameters[i], a.name)
    }

    // Compare result
    assert_params_match(a.result, b.result, a.name)
}

fn assert_params_match(a openrpc.ContentDescriptor, b openrpc.ContentDescriptor, method_name string) {
    // Compare parameter names
    assert a.name == b.name, 'Parameter names do not match in method ${method_name}: ${a.name} != ${b.name}'

    // Compare summaries
    assert a.summary == b.summary, 'Parameter summaries do not match in method ${method_name}: ${a.name}'

    // Compare descriptions
    assert a.description == b.description, 'Parameter descriptions do not match in method ${method_name}: ${a.name}'

    // Compare required flags
    assert a.required == b.required, 'Required flags do not match in method ${method_name}: ${a.name}'

    // Compare schemas
    // assert_schemas_match(a.schema, b.schema, method_name, a.name)
}

// fn assert_schemas_match(a jsonschema.SchemaRef, b jsonschema.SchemaRef, method_name string, param_name string) {
//     if a is Schema &&
//     // Compare schema types
//     assert a.typ == b.typ, 'Schema types do not match for parameter ${param_name} in method ${method_name}: ${a.typ} != ${b.typ}'

//     // Compare schema titles
//     assert a.title == b.title, 'Schema titles do not match for parameter ${param_name} in method ${method_name}.'

//     // Compare schema descriptions
//     assert a.description == b.description, 'Schema descriptions do not match for parameter ${param_name} in method ${method_name}.'

//     // Compare other schema fields as needed (e.g., properties, additional properties, items, etc.)
//     // Add more checks here if needed for deeper schema comparisons
// }