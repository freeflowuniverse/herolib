module qdrant

import freeflowuniverse.herolib.core.httpconnection
import json
import rand

// Retrieves all details from multiple points.
@[params]
pub struct RetrievePointsParams {
pub mut:
	ids             []int  @[json: 'ids'; required]             // Look for points with ids
	collection_name string @[json: 'collection_name'; required] // Name of the collection
	shard_key       ?string // Specify in which shards to look for the points, if not specified - look in all shards
	with_payload    ?bool   // Select which payload to return with the response. Default is true.
	with_vectors    ?bool   // Options for specifying which vectors to include into response. Default is false.
}

pub struct RetrievePointsResponse {
pub mut:
	id          int               // Type, used for specifying point ID in user interface
	payload     map[string]string // Payload - values assigned to the point
	vector      []f64             // Vector of the point
	shard_id    string            // Shard name
	order_value f64               // Order value
}

// Retrieves all details from multiple points.
pub fn (mut self QDrantClient) retrieve_points(params RetrievePointsParams) !QDrantResponse[RetrievePointsResponse] {
	mut http_conn := self.httpclient()!
	req := httpconnection.Request{
		method: .post
		prefix: '/collections/${params.collection_name}/points'
		data:   json.encode(params)
	}

	mut response := http_conn.send(req)!

	if response.code >= 400 {
		error_ := json.decode(QDrantErrorResponse, response.data)!
		return error('Error retrieving points: ' + error_.status.error)
	}

	return json.decode(QDrantResponse[RetrievePointsResponse], response.data)!
}

// Parameters for upserting points into a Qdrant collection.
@[params]
pub struct UpsertPointsParams {
pub mut:
	collection_name string  @[json: 'collection_name'; required] // Name of the collection
	points          []Point @[json: 'points'; required]          // List of points to upsert
	shard_key       ?string // Optional shard key for sharding
}

// Represents a single point to be upserted.
pub struct Point {
pub mut:
	id      string = rand.uuid_v4()            @[json: 'id'; required]            // Point ID (can be string or integer, serialized as string)
	payload map[string]string @[json: 'payload']          // Payload key-value pairs (optional)
	vector  []f64             @[json: 'vector'; required] // Vector data for the point
}

// Response structure for the upsert points operation.
pub struct UpsertPointsResponse {
pub mut:
	status       string @[json: 'status']
	operation_id int    @[json: 'operation_id']
}

// Upserts points into a Qdrant collection.
// Performs insert + update actions on specified points. Any point with an existing {id} will be overwritten.
pub fn (mut self QDrantClient) upsert_points(params UpsertPointsParams) !QDrantResponse[UpsertPointsResponse] {
	mut http_conn := self.httpclient()!
	req := httpconnection.Request{
		method: .put
		prefix: '/collections/${params.collection_name}/points'
		data:   json.encode(params)
	}

	mut response := http_conn.send(req)!

	if response.code >= 400 {
		error_ := json.decode(QDrantErrorResponse, response.data)!
		return error('Error upserting points: ' + error_.status.error)
	}

	return json.decode(QDrantResponse[UpsertPointsResponse], response.data)!
}
