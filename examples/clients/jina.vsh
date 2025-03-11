#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.jina

mut jina_client := jina.get()!

embeddings := jina_client.create_embeddings(
	input: ['Hello', 'World']
	model: .jina_embeddings_v3
	task:  'separation'
) or { panic('Error while creating embeddings: ${err}') }

println('Created embeddings: ${embeddings}')
