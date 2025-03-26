#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.jina
import freeflowuniverse.herolib.osal
import os

// Example of using the Jina client

fn main() {
	// Set environment variable for testing
	// In production, you would set this in your environment
	// osal.env_set(key: 'JINAKEY', value: 'your-api-key')

	// Check if JINAKEY environment variable exists
	if !osal.env_exists('JINAKEY') {
		println('JINAKEY environment variable not set. Please set it before running this example.')
		exit(1)
	}

	// Create a Jina client instance
	mut client := jina.get(name: 'default')!

	println('Jina client initialized successfully.')

	// Example: Create embeddings
	model := 'jina-embeddings-v3'
	texts := ['Hello, world!', 'How are you doing?']

	println('Creating embeddings for texts: ${texts}')
	result := client.create_embeddings(texts, model, 'retrieval.query')!

	println('Embeddings created successfully.')
	println('Model: ${result['model']}')
	println('Data count: ${result['data'].arr().len}')

	// Example: List classifiers
	println('\nListing classifiers:')
	classifiers := client.list_classifiers() or {
		println('Failed to list classifiers: ${err}')
		return
	}

	println('Classifiers retrieved successfully.')

	// Example: Create a classifier
	println('\nTraining a classifier:')
	examples := [
		jina.TrainingExample{
			text:  'This movie was great!'
			label: 'positive'
		},
		jina.TrainingExample{
			text:  'I did not like this movie.'
			label: 'negative'
		},
		jina.TrainingExample{
			text:  'The movie was okay.'
			label: 'neutral'
		},
	]

	training_result := client.train(examples, model, 'private') or {
		println('Failed to train classifier: ${err}')
		return
	}

	println('Classifier trained successfully.')
	println('Classifier ID: ${training_result['classifier_id']}')
}
