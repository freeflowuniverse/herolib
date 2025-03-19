module qdrant

import freeflowuniverse.herolib.core.httpconnection
import json

// QdrantClient is the main client for interacting with the Qdrant API
pub struct QdrantClient {
pub mut:
	name   string = 'default'
	secret string
	url    string = 'http://localhost:6333'
}

// httpclient creates a new HTTP connection to the Qdrant API
fn (mut self QdrantClient) httpclient() !&httpconnection.HTTPConnection {
	mut http_conn := httpconnection.new(
		name: 'Qdrant_vclient'
		url:  self.url
	)!

	// Add authentication header if API key is provided
	if self.secret.len > 0 {
		http_conn.default_header.add_custom('api_key', self.secret)!
	}
	return http_conn
}

// Collections API

@[params]
pub struct CreateCollectionParams {
pub mut:
	collection_name          string        @[required]
	vectors                  VectorsConfig @[required]
	shard_number             ?int
	replication_factor       ?int
	write_consistency_factor ?int
	on_disk_payload          ?bool
	hnsw_config              ?HnswConfig
	optimizers_config        ?OptimizersConfig
	wal_config               ?WalConfig
	quantization_config      ?QuantizationConfig
	init_from                ?InitFrom
	timeout                  ?int
}

// Create a new collection
pub fn (mut q QdrantClient) create_collection(params CreateCollectionParams) !bool {
	mut collection_params := CollectionParams{
		vectors: params.vectors
	}

	if v := params.shard_number {
		collection_params.shard_number = v
	}

	if v := params.replication_factor {
		collection_params.replication_factor = v
	}

	if v := params.write_consistency_factor {
		collection_params.write_consistency_factor = v
	}

	if v := params.on_disk_payload {
		collection_params.on_disk_payload = v
	}

	if v := params.hnsw_config {
		collection_params.hnsw_config = v
	}

	if v := params.optimizers_config {
		collection_params.optimizers_config = v
	}

	if v := params.wal_config {
		collection_params.wal_config = v
	}

	if v := params.quantization_config {
		collection_params.quantization_config = v
	}

	if v := params.init_from {
		collection_params.init_from = v
	}

	mut query_params := map[string]string{}
	if v := params.timeout {
		query_params['timeout'] = v.str()
	}

	req := httpconnection.Request{
		method:     .put
		prefix:     'collections/${params.collection_name}'
		dataformat: .json
		data:       json.encode(collection_params)
		params:     query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	result := json.decode(OperationResponse, response.data)!
	return result.result
}

@[params]
pub struct ListCollectionsParams {
pub mut:
	timeout ?int
}

// List all collections
pub fn (mut q QdrantClient) list_collections(params ListCollectionsParams) !CollectionsResponse {
	mut query_params := map[string]string{}
	if v := params.timeout {
		query_params['timeout'] = v.str()
	}

	req := httpconnection.Request{
		method: .get
		prefix: 'collections'
		params: query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return json.decode(CollectionsResponse, response.data)!
}

@[params]
pub struct DeleteCollectionParams {
pub mut:
	collection_name string @[required]
	timeout         ?int
}

// Delete a collection
pub fn (mut q QdrantClient) delete_collection(params DeleteCollectionParams) !bool {
	mut query_params := map[string]string{}
	if v := params.timeout {
		query_params['timeout'] = v.str()
	}

	req := httpconnection.Request{
		method: .delete
		prefix: 'collections/${params.collection_name}'
		params: query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	result := json.decode(OperationResponse, response.data)!
	return result.result
}

@[params]
pub struct GetCollectionParams {
pub mut:
	collection_name string @[required]
	timeout         ?int
}

// Get collection info
pub fn (mut q QdrantClient) get_collection(params GetCollectionParams) !CollectionInfo {
	mut query_params := map[string]string{}
	if v := params.timeout {
		query_params['timeout'] = v.str()
	}

	req := httpconnection.Request{
		method: .get
		prefix: 'collections/${params.collection_name}'
		params: query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	result := json.decode(CollectionInfoResponse, response.data)!
	return result.result
}

// Points API

@[params]
pub struct UpsertPointsParams {
pub mut:
	collection_name string        @[required]
	points          []PointStruct @[required]
	wait            ?bool
	ordering        ?WriteOrdering
}

// Upsert points
pub fn (mut q QdrantClient) upsert_points(params UpsertPointsParams) !PointsOperationResponse {
	mut query_params := map[string]string{}
	if v := params.wait {
		query_params['wait'] = v.str()
	}

	mut request_body := map[string]string{}
	request_body['points'] = json.encode(params.points)

	if v := params.ordering {
		request_body['ordering'] = json.encode(v)
	}

	req := httpconnection.Request{
		method:     .put
		prefix:     'collections/${params.collection_name}/points'
		dataformat: .json
		data:       json.encode(request_body)
		params:     query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return json.decode(PointsOperationResponse, response.data)!
}

@[params]
pub struct DeletePointsParams {
pub mut:
	collection_name string         @[required]
	points_selector PointsSelector @[required]
	wait            ?bool
	ordering        ?WriteOrdering
}

// Delete points
pub fn (mut q QdrantClient) delete_points(params DeletePointsParams) !PointsOperationResponse {
	mut query_params := map[string]string{}
	if v := params.wait {
		query_params['wait'] = v.str()
	}

	mut request_body := map[string]string{}

	if params.points_selector.points != none {
		request_body['points'] = params.points_selector.points.str()
	} else if params.points_selector.filter != none {
		request_body['filter'] = params.points_selector.filter.str()
	}

	if v := params.ordering {
		request_body['ordering'] = v.str()
	}

	req := httpconnection.Request{
		method:     .post
		prefix:     'collections/${params.collection_name}/points/delete'
		dataformat: .json
		data:       json.encode(request_body)
		params:     query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return json.decode(PointsOperationResponse, response.data)!
}

@[params]
pub struct GetPointParams {
pub mut:
	collection_name string @[required]
	id              string @[required]
	with_payload    ?WithPayloadSelector
	with_vector     ?WithVector
}

// Get a point by ID
pub fn (mut q QdrantClient) get_point(params GetPointParams) !GetPointResponse {
	mut query_params := map[string]string{}

	if v := params.with_payload {
		query_params['with_payload'] = json.encode(v)
	}

	if v := params.with_vector {
		query_params['with_vector'] = json.encode(v)
	}

	req := httpconnection.Request{
		method: .get
		prefix: 'collections/${params.collection_name}/points/${params.id}'
		params: query_params
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return json.decode(GetPointResponse, response.data)!
}

@[params]
pub struct SearchParams {
pub mut:
	collection_name string @[required]
	vector          []f32  @[required]
	limit           int = 10
	filter          ?Filter
	params          ?SearchParamsConfig
	with_payload    ?WithPayloadSelector
	with_vector     ?WithVector
	score_threshold ?f32
}

// Search for points
pub fn (mut q QdrantClient) search(params SearchParams) !SearchResponse {
	// Create a struct to serialize to JSON
	struct SearchRequest {
	pub mut:
		vector          []f32
		limit           int
		filter          ?Filter
		params          ?SearchParamsConfig
		with_payload    ?WithPayloadSelector
		with_vector     ?WithVector
		score_threshold ?f32
	}

	mut request := SearchRequest{
		vector: params.vector
		limit:  params.limit
	}

	if v := params.filter {
		request.filter = v
	}

	if v := params.params {
		request.params = v
	}

	if v := params.with_payload {
		request.with_payload = v
	}

	if v := params.with_vector {
		request.with_vector = v
	}

	if v := params.score_threshold {
		request.score_threshold = v
	}

	req := httpconnection.Request{
		method:     .post
		prefix:     'collections/${params.collection_name}/points/search'
		dataformat: .json
		data:       json.encode(request)
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return json.decode(SearchResponse, response.data)!
}

// Service API

// Get Qdrant service info
pub fn (mut q QdrantClient) get_service_info() !ServiceInfoResponse {
	req := httpconnection.Request{
		method: .get
		prefix: ''
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return json.decode(ServiceInfoResponse, response.data)!
}

// Check Qdrant health
pub fn (mut q QdrantClient) health_check() !bool {
	req := httpconnection.Request{
		method: .get
		prefix: 'healthz'
	}

	mut httpclient := q.httpclient()!
	response := httpclient.send(req)!

	return response.code == 200
}
