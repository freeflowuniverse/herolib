#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.baobab.generator
import freeflowuniverse.herolib.baobab.specification
import freeflowuniverse.herolib.schemas.openapi
import os

const example_dir = os.dir(@FILE)
const openapi_spec_path = os.join_path(example_dir, 'openapi.json')

// the actor specification obtained from the OpenRPC Specification
openapi_spec := openapi.new(path: openapi_spec_path)!
actor_spec := specification.from_openapi(openapi_spec)!

println(actor_spec)

// actor_module := generator.generate_actor_module(actor_spec,
// 	interfaces: [.openapi, .http]
// )!

actor_module := generator.generate_actor_module(actor_spec,
	interfaces: [ .http]
)!

actor_module.write(example_dir,
	format:    true
	overwrite: true
	compile:   false
)!

// os.execvp('bash', ['${example_dir}/meeting_scheduler_actor/scripts/run.sh'])!
