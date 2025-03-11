#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.jina

mut jina_client := jina.get()!

// Create embeddings
embeddings := jina_client.create_embeddings(
	input: ['Hello', 'World']
	model: .jina_embeddings_v3
	task:  'separation'
) or { panic('Error while creating embeddings: ${err}') }

println('Created embeddings: ${embeddings}')

// Rerank
rerank_result := jina_client.rerank(
	model:     .reranker_v2_base_multilingual
	query:     'skincare products'
	documents: ['Product A', 'Product B', 'Product C']
	top_n:     2
) or { panic('Error while reranking: ${err}') }

println('Rerank result: ${rerank_result}')

// Train
train_result := jina_client.train(
	model: .jina_clip_v1
	input: [
		jina.TrainingExample{
			text:  'Sample text'
			label: 'positive'
		},
		jina.TrainingExample{
			image: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg'
			label: 'negative'
		},
	]
) or { panic('Error while training: ${err}') }

println('Train result: ${train_result}')

// Classify
classify_result := jina_client.classify(
	model:  .jina_clip_v1
	input:  [
		jina.ClassificationInput{
			text: 'A photo of a cat'
		},
		jina.ClassificationInput{
			image: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg'
		},
	]
	labels: ['cat', 'dog']
) or { panic('Error while classifying: ${err}') }

println('Classification result: ${classify_result}')
