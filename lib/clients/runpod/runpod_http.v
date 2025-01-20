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

// GraphQL response wrapper
struct GqlResponse[T] {
	data map[string]T
}

// struct GqlResponseData[T] {
// 	pod_find_and_deploy_on_demand T @[json: 'podFindAndDeployOnDemand']
// }

fn (mut rp RunPod) create_pop_find_and_deploy_on_demand_request(request PodFindAndDeployOnDemandRequest) !PodFindAndDeployOnDemandResponse {
	gql := build_query(BuildQueryArgs{
		query_type:  .mutation
		method_name: 'podFindAndDeployOnDemand'
	}, request, PodFindAndDeployOnDemandResponse{})
	println('gql: ${gql}')
	response_ := rp.make_request[GqlResponse[PodFindAndDeployOnDemandResponse]](.post,
		'/graphql', gql)!
	println('response: ${json.encode(response_)}')
	return response_.data['podFindAndDeployOnDemand'] or {
		return error('Could not find podFindAndDeployOnDemand in response data: ${response_.data}')
	}
	// return response.data.pod_find_and_deploy_on_demand
}
