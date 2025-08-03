#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.core.generator.generic as generator
import freeflowuniverse.herolib.core.pathlib

mut args := generator.GeneratorArgs{
	path: '~/code/github/freeflowuniverse/herolib/lib/clients/postgresql_client'
	force: true
}

// mut args := generator.GeneratorArgs{
// 	path: '~/code/github/freeflowuniverse/herolib/lib'
// 	force: true
// }


generator.scan(args)!
