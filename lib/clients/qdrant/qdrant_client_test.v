module qdrant

fn test_qdrant_client() {
	mut client := QDrantClient{
		name: 'test_client'
		url: 'http://localhost:6333'
	}

	// Test creating a collection
	vectors_config := VectorsConfig{
		size: 128
		distance: .cosine
	}

	// Create collection
	create_result := client.create_collection(
		collection_name: 'test_collection'
		vectors: vectors_config
	) or {
		assert false, 'Failed to create collection: ${err}'
		return
	}
	assert create_result == true

	// List collections
	collections := client.list_collections() or {
		assert false, 'Failed to list collections: ${err}'
		return
	}
	assert 'test_collection' in collections.result

	// Get collection info
	collection_info := client.get_collection(
		collection_name: 'test_collection'
	) or {
		assert false, 'Failed to get collection info: ${err}'
		return
	}
	assert collection_info.vectors_count == 0

	// Upsert points
	points := [
		PointStruct{
			id: '1'
			vector: [f32(0.1), 0.2, 0.3, 0.4]
			payload: {
				'color': 'red'
				'category': 'furniture'
			}
		},
		PointStruct{
			id: '2'
			vector: [f32(0.2), 0.3, 0.4, 0.5]
			payload: {
				'color': 'blue'
				'category': 'electronics'
			}
		}
	]

	upsert_result := client.upsert_points(
		collection_name: 'test_collection'
		points: points
		wait: true
	) or {
		assert false, 'Failed to upsert points: ${err}'
		return
	}
	assert upsert_result.status == 'ok'

	// Search for points
	search_result := client.search(
		collection_name: 'test_collection'
		vector: [f32(0.1), 0.2, 0.3, 0.4]
		limit: 1
	) or {
		assert false, 'Failed to search points: ${err}'
		return
	}
	assert search_result.result.len > 0

	// Get a point
	point := client.get_point(
		collection_name: 'test_collection'
		id: '1'
	) or {
		assert false, 'Failed to get point: ${err}'
		return
	}
	if result := point.result {
		assert result.id == '1'
	} else {
		assert false, 'Point not found'
	}

	// Delete a point
	delete_result := client.delete_points(
		collection_name: 'test_collection'
		points_selector: PointsSelector{
			points: ['1']
		}
		wait: true
	) or {
		assert false, 'Failed to delete point: ${err}'
		return
	}
	assert delete_result.status == 'ok'

	// Delete collection
	delete_collection_result := client.delete_collection(
		collection_name: 'test_collection'
	) or {
		assert false, 'Failed to delete collection: ${err}'
		return
	}
	assert delete_collection_result == true
}
