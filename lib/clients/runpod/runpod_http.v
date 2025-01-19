module runpod

import freeflowuniverse.herolib.core.httpconnection
import json

fn (mut rp RunPod) httpclient() !&httpconnection.HTTPConnection {
	mut http_conn := httpconnection.new(
		name:  'runpod_${rp.name}'
		url:   'https://api.runpod.io'
		cache: true
		retry: 3
	)!

	// Add authorization header
	http_conn.default_header.add(.authorization, 'Bearer ${rp.api_key}')
	return http_conn
}

// Represents the entire mutation and input structure
struct PodFindAndDeployOnDemand[T, V] {
	input    T @[json: 'input']
	response V @[json: 'response']
}

// GraphQL query structs
struct GqlQuery {
	query string
}

struct GqlInput {
	cloud_type           string @[json: 'cloudType']
	gpu_count            int    @[json: 'gpuCount']
	volume_in_gb         int    @[json: 'volumeInGb']
	container_disk_in_gb int    @[json: 'containerDiskInGb']
	min_vcpu_count       int    @[json: 'minVcpuCount']
	min_memory_in_gb     int    @[json: 'minMemoryInGb']
	gpu_type_id          string @[json: 'gpuTypeId']
	name                 string
	image_name           string @[json: 'imageName']
	docker_args          string @[json: 'dockerArgs']
	ports                string
	volume_mount_path    string @[json: 'volumeMountPath']
	env                  []map[string]string
}

// GraphQL response wrapper
struct GqlResponse {
	data GqlResponseData
}

struct GqlResponseData {
	pod_find_and_deploy_on_demand PodFindAndDeployOnDemandResponse @[json: 'podFindAndDeployOnDemand']
}

fn (mut rp RunPod) get_response_fields[T](response_fields_str_ string, struct_ T) string {
	mut response_fields_str := response_fields_str_

	// Start the current level
	response_fields_str += '{'

	$for field in struct_.fields {
		$if field.is_struct {
			// Recursively process nested structs
			response_fields_str += '${field.name}'
			response_fields_str += ' '
			response_fields_str += rp.get_response_fields('', struct_.$(field.name))
		} $else {
			// Process attributes to fetch the JSON field name or fallback to field name
			if field.attrs.len > 0 {
				for attr in field.attrs {
					attrs := attr.trim_space().split(':')
					if attrs.len == 2 && attrs[0] == 'json' {
						response_fields_str += '${attrs[1]}'
						break
					}
				}
			} else {
				response_fields_str += '${field.name}'
			}
		}
		response_fields_str += ' '
	}
	// End the current level
	response_fields_str = response_fields_str.trim_space()
	response_fields_str += '}'
	return response_fields_str
}

fn (mut rp RunPod) build_query(request PodFindAndDeployOnDemandRequest, response PodFindAndDeployOnDemandResponse) string {
	// Convert input to JSON
	input_json := json.encode(request)

	// Build the GraphQL mutation string
	response_fields_str := ''
	mut response_fields := rp.get_response_fields(response_fields_str, response)

	// Wrap the query correctly
	query := 'mutation { podFindAndDeployOnDemand(input: ${input_json}) ${response_fields} }'

	// Wrap in the final structure
	gql := GqlQuery{
		query: query
	}

	// Return the final GraphQL query as a JSON string
	return json.encode(gql)
}

enum HTTPMethod {
	get
	post
	put
	delete
}

fn (mut rp RunPod) make_request[T](method HTTPMethod, path string, data string) !T {
	mut request := httpconnection.Request{
		prefix:     path
		data:       data
		debug:      true
		dataformat: .json
	}

	mut http := rp.httpclient()!
	mut response := T{}

	match method {
		.get {
			request.method = .get
			response = http.get_json_generic[T](request)!
		}
		.post {
			request.method = .post
			response = http.post_json_generic[T](request)!
		}
		.put {
			request.method = .put
			response = http.put_json_generic[T](request)!
		}
		.delete {
			request.method = .delete
			response = http.delete_json_generic[T](request)!
		}
	}
	return response
}

fn (mut rp RunPod) create_pod_request(request PodFindAndDeployOnDemandRequest) !PodFindAndDeployOnDemandResponse {
	response_type := PodFindAndDeployOnDemandResponse{}
	gql := rp.build_query(request, response_type)
	println('gql: ${gql}')
	response := rp.make_request[GqlResponse](.post, '/graphql', gql)!
	println('response: ${json.encode(response)}')
	return response_type
	// return response.data.pod_find_and_deploy_on_demand
}
