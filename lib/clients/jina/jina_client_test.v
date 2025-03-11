module jina

import time

fn setup_client() !&Jina {
	mut client := get()!
	return client
}

fn test_create_embeddings() {
	time.sleep(1 * time.second)
	mut client := setup_client()!
	embeddings := client.create_embeddings(
		input: ['Hello', 'World']
		model: .jina_embeddings_v3
		task:  'separation'
	) or { panic('Error while creating embeddings: ${err}') }

	assert embeddings.data.len > 0
	assert embeddings.object == 'list' // Check the object type
	assert embeddings.model == 'jina-embeddings-v3'
}

fn test_rerank() {
	time.sleep(1 * time.second)
	mut client := setup_client()!
	rerank_result := client.rerank(
		model:     .reranker_v2_base_multilingual
		query:     'skincare products'
		documents: ['Product A', 'Product B', 'Product C']
		top_n:     2
	) or { panic('Error while reranking: ${err}') }

	assert rerank_result.results.len == 2
	assert rerank_result.model == 'jina-reranker-v2-base-multilingual'
}

fn test_train() {
	time.sleep(1 * time.second)
	mut client := setup_client()!
	train_result := client.train(
		model: .jina_clip_v1
		input: [
			TrainingExample{
				text:  'A photo of a cat'
				label: 'cat'
			},
			TrainingExample{
				text:  'A photo of a dog'
				label: 'dog'
			},
		]
	) or { panic('Error while training: ${err}') }

	assert train_result.classifier_id.len > 0
	assert train_result.num_samples == 2
}

fn test_classify() {
	time.sleep(1 * time.second)
	mut client := setup_client()!
	classify_result := client.classify(
		model:  .jina_clip_v1
		input:  [
			ClassificationInput{
				text: 'A photo of a cat'
			},
			ClassificationInput{
				image: 'https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg'
			},
		]
		labels: ['cat', 'dog']
	) or { panic('Error while classifying: ${err}') }

	assert classify_result.data.len == 2
	assert classify_result.data[0].prediction in ['cat', 'dog']
	assert classify_result.data[1].prediction in ['cat', 'dog']
	assert classify_result.data[0].object == 'classification'
	assert classify_result.data[1].object == 'classification'
}
