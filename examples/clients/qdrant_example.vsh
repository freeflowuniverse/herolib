#!/usr/bin/env -S v -n -w -gc none -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.qdrant
import freeflowuniverse.herolib.core.httpconnection
import rand

// 1. Get the qdrant client
mut qdrant_client := qdrant.get()!

// 2. Generate collection name

collection_name := 'collection_' + rand.string(4)

// 2. Create a new collection

created_collection := qdrant_client.create_collection(
	collection_name: collection_name
	size:            15
	distance:        'Cosine'
)!

println('Created Collection: ${created_collection}')

// 3. Get the created collection
get_collection := qdrant_client.get_collection(
	collection_name: collection_name
)!

println('Get Collection: ${get_collection}')

// 4. Delete the created collection
// deleted_collection := qdrant_client.delete_collection(
// 	collection_name: collection_name
// )!

// println('Deleted Collection: ${deleted_collection}')

// 5. List all collections
list_collection := qdrant_client.list_collections()!
println('List Collection: ${list_collection}')

// 6. Check collection existence
collection_existence := qdrant_client.is_collection_exists(
	collection_name: collection_name
)!
println('Collection Existence: ${collection_existence}')

// 7. Retrieve points
collection_points := qdrant_client.retrieve_points(
	collection_name: collection_name
	ids:             [
		0,
		3,
		100,
	]
)!

println('Collection Points: ${collection_points}')

// 8. Upsert points
upsert_points := qdrant_client.upsert_points(
	collection_name: collection_name
	points:          [
		qdrant.Point{
			payload: {
				'key': 'value'
			}
			vector:  [1.0, 2.0, 3.0]
		},
		qdrant.Point{
			payload: {
				'key': 'value'
			}
			vector:  [4.0, 5.0, 6.0]
		},
		qdrant.Point{
			payload: {
				'key': 'value'
			}
			vector:  [7.0, 8.0, 9.0]
		},
	]
)!

println('Upsert Points: ${upsert_points}')
