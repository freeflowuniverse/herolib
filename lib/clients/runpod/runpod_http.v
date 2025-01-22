module runpod

import x.json2
import json

// fn main() {
// 	mut fields := []Field{}
// 	fields << new_field('gpuTypes', {
// 		'id': '"NVIDIA GeForce RTX 3090"'
// 	}, [
// 		new_field('displayName', {}, []),
// 		new_field('d', {}, []),
// 		new_field('communmemoryInGb', {}, []),
// 		new_field('secureClouityCloud', {}, []),
// 		new_field('lowestPrice', {
// 			'gpuCount': '1'
// 		}, [
// 			new_field('minimumBidPrice', {}, []),
// 			new_field('uninterruptablePrice', {}, []),
// 		]),
// 	])

// 	// Create Query Builder
// 	mut builder := QueryBuilder{}
// 	builder.add_operation(.query, fields, {})

// 	// Build and print the query
// 	query := builder.build_query()
// 	println('query: ${query}')
// }

// #### Internally method doing a network call to create a new on-demand pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) create_on_demand_pod_request(input PodFindAndDeployOnDemandRequest) !PodResult {
	mut fields := []Field{}
	mut machine_fields := []Field{}
	mut output_fields := []Field{}
	mut arguments := map[string]string{}
	mut builder := QueryBuilder{}

	// $for field in input.fields {
	// 	// TODO: Handle option fields
	// 	// TODO: Handle the skip chars \

	// 	item := input.$(field.name)
	// 	arguments[get_field_name(field)] = '${item}'
	// }

	machine_fields << new_field('podHostId', {}, [])
	output_fields << new_field('id', {}, [])
	output_fields << new_field('imageName', {}, [])
	output_fields << new_field('env', {}, [])
	output_fields << new_field('machineId', {}, [])
	output_fields << new_field('desiredStatus', {}, [])
	output_fields << new_field('machine', {}, machine_fields)
	fields << new_field('podFindAndDeployOnDemand', {
		'input': '\$arguments'
	}, output_fields)

	builder.add_operation(.mutation, fields, {
		'\$arguments': 'PodFindAndDeployOnDemandInput'
	})

	query := builder.build_query()
	encoded_input := json.encode(input)
	decoded_input := json2.raw_decode(encoded_input)!.as_map()
	mut q_map := map[string]json2.Any{}
	mut variables := map[string]json2.Any{}

	variables['arguments'] = decoded_input
	q_map['query'] = json2.Any(query)
	q_map['variables'] = json2.Any(variables)

	q := json2.encode(q_map)

	println('query: ${q}')
	response := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', q)!
	return response.data['podFindAndDeployOnDemand'] or {
		return error('Could not find "podFindAndDeployOnDemand" in response data: ${response.data}')
	}
	// return PodResult{}
}

// #### Internally method doing a network call to create a new spot pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) create_spot_pod_request(input PodRentInterruptableInput) !PodResult {
	// gql := build_query(
	// 	query_type:     .mutation
	// 	method_name:    'podRentInterruptable'
	// 	request_model:  input
	// 	response_model: PodResult{}
	// )
	// response := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	// return response.data['podRentInterruptable'] or {
	// 	return error('Could not find "podRentInterruptable" in response data: ${response.data}')
	// }
	return PodResult{}
}

// #### Internally method doing a network call to start on demand pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) start_on_demand_pod_request(input PodResume) !PodResult {
	// gql := build_query(
	// 	query_type:     .mutation
	// 	method_name:    'podResume'
	// 	request_model:  input
	// 	response_model: PodResult{}
	// )
	// response := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	// return response.data['podResume'] or {
	// 	return error('Could not find "podResume" in response data: ${response.data}')
	// }
	return PodResult{}
}

// #### Internally method doing a network call to start spot pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) start_spot_pod_request(input PodBidResume) !PodResult {
	// gql := build_query(
	// 	query_type:     .mutation
	// 	method_name:    'podBidResume'
	// 	request_model:  input
	// 	response_model: PodResult{}
	// )
	// response := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	// return response.data['podBidResume'] or {
	// 	return error('Could not find "podBidResume" in response data: ${response.data}')
	// }
	return PodResult{}
}

// #### Internally method doing a network call to stop a pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) stop_pod_request(input PodResume) !PodResult {
	// gql := build_query(
	// 	query_type:     .mutation
	// 	method_name:    'podStop'
	// 	request_model:  input
	// 	response_model: PodResult{}
	// )
	// response := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	// return response.data['podStop'] or {
	// 	return error('Could not find "podStop" in response data: ${response.data}')
	// }
	return PodResult{}
}
