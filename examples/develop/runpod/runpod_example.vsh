#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

// import freeflowuniverse.herolib.core.base
import freeflowuniverse.herolib.clients.runpod

// Example 1: Create client with direct API key
mut rp := runpod.get_or_create(
	name:    'example1'
	api_key: 'rpa_JDYDWBS0PDTC55T1BYT1PX85CL4D5YEBZ48LETRXyf4gxr'
)!

// Create a new on demand pod
pod_response := rp.create_on_demand_pod(
	name:       'RunPod Tensorflow'
	image_name: 'runpod/tensorflow'
	cloud_type: .all
	gpu_count: 1
	volume_in_gb: 40
	container_disk_in_gb: 40
	min_memory_in_gb: 15
	min_vcpu_count: 2
	gpu_type_id: "NVIDIA RTX A6000"
	ports: "8888/http"
	volume_mount_path: "/workspace"
	env:        [
		runpod.EnvironmentVariableInput{
			key:   'JUPYTER_PASSWORD'
			value: 'rn51hunbpgtltcpac3ol'
		},
	]
)!

println('Created pod with ID: ${pod_response.id}')

// create a spot pod
spot_pod_resp := rp.create_spot_pod(
	port:                 1826
	bid_per_gpu:          0.2
	cloud_type:           .secure
	gpu_count:            1
	volume_in_gb:         40
	container_disk_in_gb: 40
	min_vcpu_count:       2
	min_memory_in_gb:     15
	gpu_type_id:          'NVIDIA RTX A6000'
	name:                 'RunPod Pytorch'
	image_name:           'runpod/pytorc2h'
	docker_args:          ''
	ports:                '8888/http'
	volume_mount_path:    '/workspace'
	env:                  [
		runpod.EnvironmentVariableInput{
			key:   'JUPYTER_PASSWORD'
			value: 'rn51hunbpgtltcpac3ol'
		},
	]
)!
println('Created spot pod with ID: ${spot_pod_resp.id}')
