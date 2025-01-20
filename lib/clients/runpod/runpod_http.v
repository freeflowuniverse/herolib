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
struct GqlResponse {
	data GqlResponseData
}

struct GqlResponseData {
	pod_find_and_deploy_on_demand PodFindAndDeployOnDemandResponse @[json: 'podFindAndDeployOnDemand']
}

fn (mut rp RunPod) create_pod_request[T, R](request T, response R) !R {
	gql := rp.build_query[T, R](request, response)
	println('gql: ${gql}')
	response_ := rp.make_request[GqlResponse](.post, '/graphql', gql)!
	println('response: ${json.encode(response_)}')
	return response
	// return response.data.pod_find_and_deploy_on_demand
}
