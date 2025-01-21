module runpod

// Represents the nested machine structure in the response
pub struct Machine {
pub:
	pod_host_id string @[json: 'podHostId']
}

// Response structure for the mutation
pub struct PodResult {
pub:
	id             string   @[json: 'id']
	image_name     string   @[json: 'imageName']
	env            []string @[json: 'env']
	machine_id     int      @[json: 'machineId']
	machine        Machine  @[json: 'machine']
	desired_status string   @[json: 'desiredStatus']
}

// Input structure for the mutation
@[params]
pub struct PodFindAndDeployOnDemandRequest {
pub mut:
	cloud_type           CloudType                  @[json: 'cloudType']
	gpu_count            int                        @[json: 'gpuCount']
	volume_in_gb         int                        @[json: 'volumeInGb']
	container_disk_in_gb int                        @[json: 'containerDiskInGb']
	min_vcpu_count       int                        @[json: 'minVcpuCount']
	min_memory_in_gb     int                        @[json: 'minMemoryInGb']
	gpu_type_id          string                     @[json: 'gpuTypeId']
	name                 string                     @[json: 'name']
	image_name           string                     @[json: 'imageName']
	docker_args          string                     @[json: 'dockerArgs']
	ports                string                     @[json: 'ports']
	volume_mount_path    string                     @[json: 'volumeMountPath']
	env                  []EnvironmentVariableInput @[json: 'env']
}

// Create On-Demand Pod
pub fn (mut rp RunPod) create_on_demand_pod(input PodFindAndDeployOnDemandRequest) !PodResult {
	return rp.create_pod_find_and_deploy_on_demand_request(input)!
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

// Create Spot Pod
pub fn (mut rp RunPod) create_spot_pod(input PodRentInterruptableInput) !PodResult {
	return rp.create_create_spot_pod_request(input)!
}

@[params]
pub struct PodResume {
pub mut:
	pod_id      string @[json: 'podId']
	gpu_count   int    @[json: 'gpuCount']
	bid_per_gpu f32    @[json: 'bidPerGpu']
}

// Start On-Demand Pod
pub fn (mut rp RunPod) start_on_demand_pod(input PodResume) !PodResult {
	return rp.start_on_demand_pod_request(input)!
}

// Start Spot Pod
pub fn (mut rp RunPod) start_spot_pod(input PodResume) !PodResult {
	return rp.start_spot_pod_request(input)!
}
