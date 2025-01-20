#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.clients.runpod

// Example 1: Create client with direct API key
mut rp := runpod.get_or_create(
	name:    'example1'
	api_key: 'rpa_JDYDWBS0PDTC55T1BYT1PX85CL4D5YEBZ48LETRXyf4gxr'
)!

// Create a new pod
pod_response := rp.create_pod(
	name:       'RunPod Tensorflow'
	image_name: 'runpod/tensorflow'
	env: [
		{"JUPYTER_PASSWORD": "rn51hunbpgtltcpac3ol"}
	]
)!

println('Created pod with ID: ${pod_response.id}')
