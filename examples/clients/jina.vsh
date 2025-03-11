#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.jina

mut jina_client := jina.get()!

embeddings := jina_client.create_embeddings(
	input: ['Hello', 'World']
	model: .jina_embeddings_v3
	task:  'separation'
) or { panic('Error while creating embeddings: ${err}') }

println('Created embeddings: ${embeddings}')

rerank_result := jina_client.rerank(
	model:     .reranker_v2_base_multilingual
	query:     'skincare products'
	documents: ['Product A', 'Product B', 'Product C']
	top_n:     2
) or { panic('Error while reranking: ${err}') }

println('Rerank result: ${rerank_result}')
