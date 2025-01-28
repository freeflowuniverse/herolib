#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import os
import json
import freeflowuniverse.herolib.core.openapi.gen

const spec_path = '${os.dir(@FILE)}/openapi.json'

mod := gen.generate_client_module(
	api_name: 'Gitea'
)!
mod.write_v('${os.dir(@FILE)}/gitea_client',
	overwrite: true
)!
