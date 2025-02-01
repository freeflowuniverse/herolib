module stage

import freeflowuniverse.herolib.baobab.osis {OSIS}

@[heap]
pub interface IActor {
	name string
mut:
	act(Action) !Action
}

pub struct Actor {
pub:
	name string
	redis_url string = 'localhost:6379'
mut:
	osis OSIS
}

pub fn new_actor(name string) !Actor {
	return Actor{
		osis: osis.new()!
		name: name
	}
}

pub fn (mut a IActor) handle(method string, data string) !string {
	action := a.act(
		name: method
		params: data
	)!
	return action.result
}

// // Actor listens to the Redis queue for method invocations
// pub fn (mut a IActor) run() ! {
// 	mut redis := redisclient.new('localhost:6379') or { panic(err) }
// 	mut rpc := redis.rpc_get(a.name)

// 	println('Actor started and listening for tasks...')
// 	for {
// 		rpc.process(a.handle)!
// 		time.sleep(time.millisecond * 100) // Prevent CPU spinning
// 	}
// }
