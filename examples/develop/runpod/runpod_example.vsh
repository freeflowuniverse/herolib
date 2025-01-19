#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.clients.runpod

// Example 1: Create client with direct API key
mut rp := runpod.get_or_create(
	name:    'example1'
	api_key: 'rpa_1G9W44SJM2A70ILYQSPAPEKDCTT181SRZGZK03A22lpazg'
)!

// Create a new pod

pod_response := rp.create_pod(
	name:       'test-pod'
	image_name: 'runpod/tensorflow'
)!

println('Created pod with ID: ${pod_response.id}')
