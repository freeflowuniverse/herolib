module jina

fn setup_client() !&Jina {
	mut client := get()!
	return client
}

fn test_create_embeddings() {
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
