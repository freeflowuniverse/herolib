module vastai

import json

// Represents a GPU offer from Vast.ai
pub struct GPUOffer {
pub:
	id                  int    // Unique instance ID
	cuda_max_good       int    // Maximum reliable CUDA version
	gpu_name            string // Name of the GPU
	gpu_ram             int    // GPU RAM in MB
	num_gpus            int    // Number of GPUs
	dlperf              f64    // Deep Learning Performance score
	dlperf_per_dphtotal f64    // Performance per dollar per hour
	reliability         f64    // Instance reliability score
	total_flops         f64    // Total FLOPS
	credit_discount     f64    // Credit discount
	rented              bool   // Whether instance is currently rented
	rentable            bool   // Whether instance can be rented
	verification        string // Verification status
	external            bool   // Whether instance is external
	dph_total           f64    // Total dollars per hour
	storage_total       int    // Total storage in GB
	inet_up             f64    // Upload bandwidth in Mbps
	inet_down           f64    // Download bandwidth in Mbps
}

// Search parameters for filtering GPU offers
@[params]
pub struct SearchParams {
pub mut:
	order           ?string // Sort order (default: score descending)
	query           ?string // Search query string
	min_gpu_ram     ?int    // Minimum GPU RAM in MB
	min_num_gpus    ?int    // Minimum number of GPUs
	min_dlperf      ?f64    // Minimum deep learning performance score
	max_dph         ?f64    // Maximum dollars per hour
	min_reliability ?f64    // Minimum reliability score
	verified_only   ?bool   // Only show verified instances
	external        ?bool   // Include external instances
	rentable        ?bool   // Show only rentable instances
	rented          ?bool   // Show only rented instances
}

// Response from the search API
struct SearchResponse {
	success bool
	offers  []GPUOffer
}

// Searches for GPU offers based on the provided parameters
pub fn (mut va VastAI) search_offers(params SearchParams) ![]GPUOffer {
	// Get HTTP client
	mut http_client := va.httpclient()!

	// Make request
	resp := http_client.send(method: .put, prefix: '/search/asks/?', data: json.encode(params))!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}
	// Parse response
	search_resp := json.decode(SearchResponse, resp.data)!

	return search_resp.offers
}

// Helper method to get top N offers sorted by performance/price
pub fn (mut v VastAI) get_top_offers(count int) ![]GPUOffer {
	params := SearchParams{
		order:           'dlperf_per_dphtotal-' // Sort by performance per dollar (descending)
		rentable:        true                   // Only show available instances
		min_reliability: 0.98                   // High reliability
	}

	offers := v.search_offers(params)!

	if offers.len <= count {
		return offers
	}
	return offers[..count]
}

// Helper method to find cheapest offers meeting minimum requirements
pub fn (mut va VastAI) find_cheapest_offers(min_gpu_ram int, min_gpus int, count int) ![]GPUOffer {
	params := SearchParams{
		order:           'dph_total' // Sort by price (ascending)
		min_gpu_ram:     min_gpu_ram
		min_num_gpus:    min_gpus
		rentable:        true // Only show available instances
		min_reliability: 0.95 // Reasonable reliability threshold
	}

	offers := va.search_offers(params)!

	if offers.len <= count {
		return offers
	}
	return offers[..count]
}

// Helper method to find most powerful GPUs available
pub fn (mut va VastAI) find_most_powerful(count int) ![]GPUOffer {
	params := SearchParams{
		order:           'dlperf-' // Sort by deep learning performance (descending)
		rentable:        true      // Only show available instances
		min_reliability: 0.95      // Reasonable reliability threshold
	}

	offers := va.search_offers(params)!

	if offers.len <= count {
		return offers
	}
	return offers[..count]
}

// CreateInstanceConfig represents the configuration for creating a new instance from an offer
@[params]
pub struct CreateInstanceConfig {
pub:
	template_id      ?string
	template_hash_id ?string
	image            ?string // Docker image name
	disk             ?int
	extra_env        ?map[string]string // Environment variables
	runtype          ?string            // "args" or "ssh"
	onstart          ?string
	label            ?string
	image_login      ?string
	price            ?f32
	target_state     ?string // "running" or "stopped"
	cancel_unavail   ?bool
	vm               ?bool
	client_id        ?string
	apikey_id        ?string
}

@[params]
pub struct CreateInstanceArgs {
pub:
	id     int
	config CreateInstanceConfig
}

// CreateInstanceResponse represents the response from creating a new instance
pub struct CreateInstanceResponse {
pub:
	success      bool
	new_contract int
}

// Creates a new instance by accepting a provider offer
pub fn (mut va VastAI) create_instance(args CreateInstanceArgs) !CreateInstanceResponse {
	// Get HTTP client
	mut http_client := va.httpclient()!

	// Make request
	resp := http_client.send(
		method: .put
		prefix: '/asks/${args.id}/?'
		data:   json.encode(args.config)
	)!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}

	// Parse response
	instance_resp := json.decode(CreateInstanceResponse, resp.data)!

	return instance_resp
}

@[params]
pub struct StopInstanceArgs {
pub:
	id    int @[required]
	state string
}

pub struct StopInstanceResponse {
pub:
	success bool
	msg     string
}

// Stops a running container and updates its status to 'stopped'.
pub fn (mut va VastAI) stop_instance(args StopInstanceArgs) !StopInstanceResponse {
	// Get HTTP client
	mut http_client := va.httpclient()!
	payload := {
		'state': args.state
	}

	// Make request
	resp := http_client.send(
		method: .put
		prefix: '/instances/${args.id}/?'
		data:   json.encode(payload)
	)!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}

	// Parse response
	instance_resp := json.decode(StopInstanceResponse, resp.data)!

	return instance_resp
}

@[params]
pub struct DestroyInstanceArgs {
pub:
	id int @[required]
}

pub struct DestroyInstanceResponse {
pub:
	success bool
	msg     string
}

// Destroys an instance.
pub fn (mut va VastAI) destroy_instance(args DestroyInstanceArgs) !DestroyInstanceResponse {
	// Get HTTP client
	mut http_client := va.httpclient()!

	// Make request
	resp := http_client.send(
		method: .delete
		prefix: '/instances/${args.id}/?'
	)!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}

	// Parse response
	instance_resp := json.decode(DestroyInstanceResponse, resp.data)!

	return instance_resp
}

@[params]
pub struct AttachSshKeyToInstanceArgs {
pub:
	id      int @[required]
	ssh_key string
}

pub struct AttachSshKeyToInstanceResponse {
pub:
	success bool
	msg     string
}

// Attach SSH Key to Instance
pub fn (mut va VastAI) attach_sshkey_to_instance(args AttachSshKeyToInstanceArgs) !AttachSshKeyToInstanceResponse {
	// Get HTTP client
	mut http_client := va.httpclient()!
	payload := {
		'ssh_key': args.ssh_key
	}

	// Make request
	resp := http_client.send(
		method: .post
		prefix: '/instances/${args.id}/ssh/?'
		data:   json.encode(payload)
	)!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}

	// Parse response
	instance_resp := json.decode(AttachSshKeyToInstanceResponse, resp.data)!

	return instance_resp
}

@[params]
pub struct LaunchInstanceArgs {
pub:
	num_gpus int    @[required]
	gpu_name string @[required]
	region   string @[required]
	image    string @[required]
	disk     int    @[required]
	env      ?string
	args     ?[]string
}

// Launch an instance, This endpoint launches an instance based on the specified parameters, selecting the first available offer that meets the criteria.
pub fn (mut va VastAI) launch_instance(args LaunchInstanceArgs) !CreateInstanceResponse {
	// Get HTTP client
	mut http_client := va.httpclient()!

	// Make request
	resp := http_client.send(
		method: .put
		prefix: '/launch_instance/?'
		data:   json.encode(args)
	)!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}

	// Parse response
	instance_resp := json.decode(CreateInstanceResponse, resp.data)!

	return instance_resp
}

@[params]
pub struct StartInstancesArgs {
pub:
	ids []int @[json: 'IDs'; required]
}

pub struct StartInstancesResponse {
pub:
	success bool
	msg     string
}

// Start Instances, Start a list of instances specified by their IDs.
pub fn (mut va VastAI) start_instances(args StartInstancesArgs) !StartInstancesResponse {
	// Get HTTP client
	mut http_client := va.httpclient()!
	// Make request
	resp := http_client.send(
		method: .post
		prefix: '/instances/start'
		data:   json.encode(args)
	)!

	if resp.code != 200 {
		return error('request failed with code ${resp.code}: ${resp.data}')
	}

	// Parse response
	instance_resp := json.decode(StartInstancesResponse, resp.data)!

	return instance_resp
}

@[params]
pub struct StartInstanceArgs {
pub:
	id int @[required]
}

// Start Instance, Start an instance specified by its ID.
pub fn (mut va VastAI) start_instance(args StartInstanceArgs) !StartInstancesResponse {
	return va.start_instances(StartInstancesArgs{ ids: [args.id] })
}
