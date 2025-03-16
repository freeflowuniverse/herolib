module qdrant

import freeflowuniverse.herolib.core.httpconnection
import json

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
	return json.decode(QDrantResponse[RetrievePointsResponse], response.data)!
}
