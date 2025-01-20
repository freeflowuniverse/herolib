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

pub enum CloudType {
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
	cloud_type           CloudType = .all                  @[json: 'cloudType']
	gpu_count            int       = 1                        @[json: 'gpuCount']
	volume_in_gb         int       = 40                        @[json: 'volumeInGb']
	container_disk_in_gb int       = 40                        @[json: 'containerDiskInGb']
	min_vcpu_count       int       = 2                        @[json: 'minVcpuCount']
	min_memory_in_gb     int       = 15                        @[json: 'minMemoryInGb']
	gpu_type_id          string    = 'NVIDIA RTX A6000'                     @[json: 'gpuTypeId']
	name                 string    = 'RunPod Tensorflow'                     @[json: 'name']
	image_name           string    = 'runpod/tensorflow'                     @[json: 'imageName']
	docker_args          string    = ''                     @[json: 'dockerArgs']
	ports                string    = '8888/http'                     @[json: 'ports']
	volume_mount_path    string    = '/workspace'                     @[json: 'volumeMountPath']
	env                  []EnvironmentVariableInput @[json: 'env']
}

pub struct EnvironmentVariableInput {
pub:
	key   string
	value string
}

// Represents the nested machine structure in the response
pub struct Machine {
pub:
	pod_host_id string @[json: 'podHostId']
}

// Response structure for the mutation
pub struct PodFindAndDeployOnDemandResponse {
pub:
	id         string   @[json: 'id']
	image_name string   @[json: 'imageName']
	env        []string @[json: 'env']
	machine_id int      @[json: 'machineId']
	machine    Machine  @[json: 'machine']
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
pub fn (mut rp RunPod) create_on_demand_pod(pod PodFindAndDeployOnDemandRequest) !PodFindAndDeployOnDemandResponse {
	response_type := PodFindAndDeployOnDemandResponse{}
	request_type := pod
	response := rp.create_pop_find_and_deploy_on_demand_request(request_type)!
	return response
}

@[params]
pub struct PodRentInterruptableInput {
pub mut:
	port                  int                        @[json: 'port']
	network_volume_id     string                     @[json: 'networkVolumeId'; omitempty]
	start_jupyter         bool                       @[json: 'startJupyter']
	start_ssh             bool                       @[json: 'startSsh']
	bid_per_gpu           f32                        @[json: 'bidPerGpu']
	cloud_type            CloudType                  @[json: 'cloudType']
	container_disk_in_gb  int                        @[json: 'containerDiskInGb']
	country_code          string                     @[json: 'countryCode'; omitempty]
	docker_args           string                     @[json: 'dockerArgs'; omitempty]
	env                   []EnvironmentVariableInput @[json: 'env']
	gpu_count             int                        @[json: 'gpuCount']
	gpu_type_id           string                     @[json: 'gpuTypeId'; omitempty]
	image_name            string                     @[json: 'imageName'; omitempty]
	min_disk              int                        @[json: 'minDisk']
	min_download          int                        @[json: 'minDownload']
	min_memory_in_gb      int                        @[json: 'minMemoryInGb']
	min_upload            int                        @[json: 'minUpload']
	min_vcpu_count        int                        @[json: 'minVcpuCount']
	name                  string                     @[json: 'name'; omitempty]
	ports                 string                     @[json: 'ports'; omitempty]
	stop_after            string                     @[json: 'stopAfter'; omitempty]
	support_public_ip     bool                       @[json: 'supportPublicIp']
	template_id           string                     @[json: 'templateId'; omitempty]
	terminate_after       string                     @[json: 'terminateAfter'; omitempty]
	volume_in_gb          int                        @[json: 'volumeInGb']
	volume_key            string                     @[json: 'volumeKey'; omitempty]
	volume_mount_path     string                     @[json: 'volumeMountPath'; omitempty]
	data_center_id        string                     @[json: 'dataCenterId'; omitempty]
	cuda_version          string                     @[json: 'cudeVersion'; omitempty]
	allowed_cuda_versions []string                   @[json: 'allowedCudaVersions']
}

pub fn (mut rp RunPod) create_spot_pod(input PodRentInterruptableInput) !PodFindAndDeployOnDemandResponse {
	gql := build_query(BuildQueryArgs{
		query_type:  .mutation
		method_name: 'podRentInterruptable'
	}, input, PodFindAndDeployOnDemandResponse{})
	println('gql: ${gql}')
	response_ := rp.make_request[GqlResponse[PodFindAndDeployOnDemandResponse]](.post,
		'/graphql', gql)!
	println('response: ${response_}')
	return response_.data['podRentInterruptable'] or {
		return error('Could not find podRentInterruptable in response data: ${response_.data}')
	}
}
