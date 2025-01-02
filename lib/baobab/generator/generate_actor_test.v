module generator

import freeflowuniverse.herolib.core.code
import freeflowuniverse.herolib.baobab.specification
import freeflowuniverse.herolib.core.pathlib
import os

const actor_spec = specification.ActorSpecification{
    name: 'Pet Store'
    description: 'A sample API for a pet store'
	interfaces: [.openrpc, .command]
    methods: [specification.ActorMethod{
        name: 'listPets'
        description: 'List all pets'
        func: code.Function{
            name: 'listPets'
            params: [code.Param{
                description: 'Maximum number of pets to return'
                name: 'limit'
                typ: code.Type{
                    symbol: 'int'
                }
            }]
        }
    }, specification.ActorMethod{
        name: 'createPet'
        description: 'Create a new pet'
        func: code.Function{
            name: 'createPet'
        }
    }, specification.ActorMethod{
        name: 'getPet'
        description: 'Get a pet by ID'
        func: code.Function{
            name: 'getPet'
            params: [code.Param{
                required: true
                description: 'ID of the pet to retrieve'
                name: 'petId'
                typ: code.Type{
                    symbol: 'int'
                }
            }]
        }
    }, specification.ActorMethod{
        name: 'deletePet'
        description: 'Delete a pet by ID'
        func: code.Function{
            name: 'deletePet'
            params: [code.Param{
                required: true
                description: 'ID of the pet to delete'
                name: 'petId'
                typ: code.Type{
                    symbol: 'int'
                }
            }]
        }
    }, specification.ActorMethod{
        name: 'listOrders'
        description: 'List all orders'
        func: code.Function{
            name: 'listOrders'
        }
    }, specification.ActorMethod{
        name: 'getOrder'
        description: 'Get an order by ID'
        func: code.Function{
            name: 'getOrder'
            params: [code.Param{
                required: true
                description: 'ID of the order to retrieve'
                name: 'orderId'
                typ: code.Type{
                    symbol: 'int'
                }
            }]
        }
    }, specification.ActorMethod{
        name: 'deleteOrder'
        description: 'Delete an order by ID'
        func: code.Function{
            name: 'deleteOrder'
            params: [code.Param{
                required: true
                description: 'ID of the order to delete'
                name: 'orderId'
                typ: code.Type{
                    symbol: 'int'
                }
            }]
        }
    }, specification.ActorMethod{
        name: 'createUser'
        description: 'Create a user'
        func: code.Function{
            name: 'createUser'
        }
    }]
    objects: [specification.BaseObject{
        structure: code.Struct{
            name: 'Pet'
        }
    }, specification.BaseObject{
        structure: code.Struct{
            name: 'NewPet'
        }
    }, specification.BaseObject{
        structure: code.Struct{
            name: 'Pets'
        }
    }, specification.BaseObject{
        structure: code.Struct{
            name: 'Order'
        }
    }, specification.BaseObject{
        structure: code.Struct{
            name: 'User'
        }
    }, specification.BaseObject{
        structure: code.Struct{
            name: 'NewUser'
        }
    }]
}

const destination = '${os.dir(@FILE)}/testdata'

fn test_generate_actor_module() {
	actor_module := generate_actor_module(actor_spec)!
	actor_module.write(destination, 
        format: true
        overwrite: true
    )!
}
