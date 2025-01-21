module runpod

// #### Internally method doing a network call to create a new on-demand pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
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

// #### Internally method doing a network call to create a new spot pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
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

// #### Internally method doing a network call to start on demand pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) start_on_demand_pod_request(input PodResume) !PodResult {
	gql := build_query(
		query_type:     .mutation
		method_name:    'podResume'
		request_model:  input
		response_model: PodResult{}
	)
	response_ := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	return response_.data['podResume'] or {
		return error('Could not find podRentInterruptable in response data: ${response_.data}')
	}
}

// #### Internally method doing a network call to start spot pod.
// - Build the required query based pn the input sent by the user and send the request.
// - Decode the response received from the API into two objects `Data` and `Error`.
// - The data field should contains the pod details same as `PodResult` struct.
// - The error field should contain the error message.
fn (mut rp RunPod) start_spot_pod_request(input PodResume) !PodResult {
	gql := build_query(
		query_type:     .mutation
		method_name:    'podBidResume'
		request_model:  input
		response_model: PodResult{}
	)
	response_ := rp.make_request[GqlResponse[PodResult]](.post, '/graphql', gql)!
	return response_.data['podBidResume'] or {
		return error('Could not find podRentInterruptable in response data: ${response_.data}')
	}
}
