module runpod

pub const version = '1.14.3'
const singleton = false
const default = true

// heroscript_default returns the default heroscript configuration for RunPod
pub fn heroscript_default() !string {
	return "
    !!runpod.configure
        name:'default'
        api_key:''
        base_url:'https://api.runpod.io/v1'
    "
}

// RunPod represents a RunPod client instance
@[heap]
pub struct RunPod {
pub mut:
	name     string = 'default'
	api_key  string
	base_url string = 'https://api.runpod.io/v1'
}

enum CloudType {
	all
	secure
	community
}

fn (ct CloudType) to_string() string {
	return match ct {
		.all {
			'ALL'
		}
		.secure {
			'SECURE'
		}
		.community {
			'COMMUNITY'
		}
	}
}

// Input structure for the mutation
@[params]
pub struct PodFindAndDeployOnDemandRequest {
pub mut:
	cloud_type           CloudType           = .all           @[json: 'cloudType']
	gpu_count            int                 = 1                 @[json: 'gpuCount']
	volume_in_gb         int                 = 40                 @[json: 'volumeInGb']
	container_disk_in_gb int                 = 40                 @[json: 'containerDiskInGb']
	min_vcpu_count       int                 = 2                 @[json: 'minVcpuCount']
	min_memory_in_gb     int                 = 15                 @[json: 'minMemoryInGb']
	gpu_type_id          string              = 'NVIDIA RTX A6000'              @[json: 'gpuTypeId']
	name                 string              = 'RunPod Tensorflow'              @[json: 'name']
	image_name           string              = 'runpod/tensorflow'              @[json: 'imageName']
	docker_args          string              = ''              @[json: 'dockerArgs']
	ports                string              = '8888/http'              @[json: 'ports']
	volume_mount_path    string              = '/workspace'              @[json: 'volumeMountPath']
	env                  []map[string]string = [] @[json: 'env']
}

// Represents the nested machine structure in the response
struct Machine {
	pod_host_id string @[json: 'podHostId']
}

// Response structure for the mutation
pub struct PodFindAndDeployOnDemandResponse {
pub:
	id         string              @[json: 'id']
	image_name string              @[json: 'imageName']
	env        []map[string]string @[json: 'env']
	machine_id int                 @[json: 'machineId']
	machine    Machine             @[json: 'machine']
}

// new creates a new RunPod client
pub fn new(api_key string) !&RunPod {
	if api_key == '' {
		return error('API key is required')
	}
	return &RunPod{
		api_key: api_key
	}
}

// create_endpoint creates a new endpoint
pub fn (mut rp RunPod) create_pod(pod PodFindAndDeployOnDemandRequest) !PodFindAndDeployOnDemandResponse {
	response_type := PodFindAndDeployOnDemandResponse{}
	request_type := pod
	response := rp.create_pod_request[PodFindAndDeployOnDemandRequest, PodFindAndDeployOnDemandResponse](request_type,
		response_type)!
	return response
}

// // list_endpoints lists all endpoints
// pub fn (mut rp RunPod) list_endpoints() ![]Endpoint {
// 	response := rp.list_endpoints_request()!
// 	endpoints := json.decode([]Endpoint, response) or {
// 		return error('Failed to parse endpoints from response: ${response}')
// 	}
// 	return endpoints
// }

// // get_endpoint gets an endpoint by ID
// pub fn (mut rp RunPod) get_endpoint(id string) !Endpoint {
// 	response := rp.get_endpoint_request(id)!
// 	endpoint := json.decode(Endpoint, response) or {
// 		return error('Failed to parse endpoint from response: ${response}')
// 	}
// 	return endpoint
// }

// // delete_endpoint deletes an endpoint
// pub fn (mut rp RunPod) delete_endpoint(id string) ! {
// 	rp.delete_endpoint_request(id)!
// }

// // list_gpu_instances lists available GPU instances
// pub fn (mut rp RunPod) list_gpu_instances() ![]GPUInstance {
// 	response := rp.list_gpu_instances_request()!
// 	instances := json.decode([]GPUInstance, response) or {
// 		return error('Failed to parse GPU instances from response: ${response}')
// 	}
// 	return instances
// }

// // run_on_endpoint runs a request on an endpoint
// pub fn (mut rp RunPod) run_on_endpoint(endpoint_id string, request RunRequest) !RunResponse {
// 	response := rp.run_on_endpoint_request(endpoint_id, request)!
// 	run_response := json.decode(RunResponse, response) or {
// 		return error('Failed to parse run response: ${response}')
// 	}
// 	return run_response
// }

// // get_run_status gets the status of a run
// pub fn (mut rp RunPod) get_run_status(endpoint_id string, run_id string) !RunResponse {
// 	response := rp.get_run_status_request(endpoint_id, run_id)!
// 	run_response := json.decode(RunResponse, response) or {
// 		return error('Failed to parse run status response: ${response}')
// 	}
// 	return run_response
// }

// // cfg_play configures a RunPod instance from heroscript parameters
// fn cfg_play(p paramsparser.Params) ! {
// 	mut rp := RunPod{
// 		name:     p.get_default('name', 'default')!
// 		api_key:  p.get('api_key')!
// 		base_url: p.get_default('base_url', 'https://api.runpod.io/v1')!
// 	}
// 	set(rp)!
// }

// fn obj_init(obj_ RunPod) !RunPod {
// 	// never call get here, only thing we can do here is work on object itself
// 	mut obj := obj_
// 	return obj
// }
