#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.hero.generation

generation.generate_actor(
	name: 'Example'
	interfaces: []
)
