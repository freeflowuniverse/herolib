module generator

import freeflowuniverse.herolib.core.code
import freeflowuniverse.herolib.baobab.specification
import freeflowuniverse.herolib.core.pathlib
import freeflowuniverse.herolib.schemas.openrpc
import freeflowuniverse.herolib.schemas.jsonschema
import os

const actor_spec = specification.ActorSpecification{
    name: 'Pet Store'
    description: 'A sample API for a pet store'
    interfaces: [.openapi]
    methods: [
        specification.ActorMethod{
            name: 'listPets'
            summary: 'List all pets'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'limit'
                    summary: 'Maximum number of pets to return'
                    description: 'Maximum number of pets to return'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'integer'
                        format: 'int32'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Pets'
                })
            }
            errors: [
                openrpc.ErrorSpec{
                    code: 400
                    message: 'Invalid request'
                }
            ]
        },
        specification.ActorMethod{
            name: 'createPet'
            summary: 'Create a new pet'
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
            }
            errors: [
                openrpc.ErrorSpec{
                    code: 400
                    message: 'Invalid input'
                }
            ]
        },
        specification.ActorMethod{
            name: 'getPet'
            summary: 'Get a pet by ID'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'petId'
                    summary: 'ID of the pet to retrieve'
                    description: 'ID of the pet to retrieve'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'integer'
                        format: 'int64'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Pet'
                })
            }
            errors: [
                openrpc.ErrorSpec{
                    code: 404
                    message: 'Pet not found'
                }
            ]
        },
        specification.ActorMethod{
            name: 'deletePet'
            summary: 'Delete a pet by ID'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'petId'
                    summary: 'ID of the pet to delete'
                    description: 'ID of the pet to delete'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'integer'
                        format: 'int64'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
            }
            errors: [
                openrpc.ErrorSpec{
                    code: 404
                    message: 'Pet not found'
                }
            ]
        },
        specification.ActorMethod{
            name: 'listOrders'
            summary: 'List all orders'
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
                schema: jsonschema.SchemaRef(jsonschema.Schema{
                    typ: 'array'
                    items: jsonschema.Items(jsonschema.SchemaRef(jsonschema.Reference{
                        ref: '#/components/schemas/Order'
                    }))
                })
            }
        },
        specification.ActorMethod{
            name: 'getOrder'
            summary: 'Get an order by ID'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'orderId'
                    summary: 'ID of the order to retrieve'
                    description: 'ID of the order to retrieve'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'integer'
                        format: 'int64'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
                schema: jsonschema.SchemaRef(jsonschema.Reference{
                    ref: '#/components/schemas/Order'
                })
            }
            errors: [
                openrpc.ErrorSpec{
                    code: 404
                    message: 'Order not found'
                }
            ]
        },
        specification.ActorMethod{
            name: 'deleteOrder'
            summary: 'Delete an order by ID'
            parameters: [
                openrpc.ContentDescriptor{
                    name: 'orderId'
                    summary: 'ID of the order to delete'
                    description: 'ID of the order to delete'
                    schema: jsonschema.SchemaRef(jsonschema.Schema{
                        typ: 'integer'
                        format: 'int64'
                    })
                }
            ]
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
            }
            errors: [
                openrpc.ErrorSpec{
                    code: 404
                    message: 'Order not found'
                }
            ]
        },
        specification.ActorMethod{
            name: 'createUser'
            summary: 'Create a user'
            result: openrpc.ContentDescriptor{
                name: 'result'
                description: 'The response of the operation.'
            }
        }
    ]
    objects: [
        specification.BaseObject{
            structure: code.Struct{
                name: 'Pet'
            }
        },
        specification.BaseObject{
            structure: code.Struct{
                name: 'NewPet'
            }
        },
        specification.BaseObject{
            structure: code.Struct{
                name: 'Pets'
            }
        },
        specification.BaseObject{
            structure: code.Struct{
                name: 'Order'
            }
        },
        specification.BaseObject{
            structure: code.Struct{
                name: 'User'
            }
        },
        specification.BaseObject{
            structure: code.Struct{
                name: 'NewUser'
            }
        }
    ]
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
