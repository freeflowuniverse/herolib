module generator

import freeflowuniverse.herolib.core.code { Function, Param, Result, Struct, Type }
import freeflowuniverse.herolib.schemas.openrpc

const test_actor_specification = ActorSpecification {
	methods: [
		ActorMethod{
			func: Function{
				name: 'get_object'
				params: [
					Param{
						name: 'id'
						typ: Type{
							symbol: 'int'
						}
					},
				]
				result: Result{
					typ: Type{
						symbol: 'Object'
					}
				}
			}
		},
	]
	objects: [BaseObject{
		structure: Struct{
			name: 'Object'
		}
	}]
}

pub fn test_generate_openrpc() ! {
	actor := Actor{
		
	}
	object := generate_openrpc(actor)
	panic(object.encode()!)
}
