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

fn (mut rp RunPod) create_pod_find_and_deploy_on_demand_request(request PodFindAndDeployOnDemandRequest) !PodResult {
	gql := build_query(
		query_type:     .mutation
		method_name:    'podFindAndDeployOnDemand'
		request_model:  request
		response_model: PodResult{}
	)
	response_ := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	return response_.data['podFindAndDeployOnDemand'] or {
		return error('Could not find podFindAndDeployOnDemand in response data: ${response_.data}')
	}
}

fn (mut rp RunPod) create_create_spot_pod_request(input PodRentInterruptableInput) !PodResult {
	gql := build_query(
		query_type:     .mutation
		method_name:    'podRentInterruptable'
		request_model:  input
		response_model: PodResult{}
	)
	response_ := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	return response_.data['podRentInterruptable'] or {
		return error('Could not find podRentInterruptable in response data: ${response_.data}')
	}
}
