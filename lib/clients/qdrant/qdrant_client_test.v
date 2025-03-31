module qdrant

import os

fn test_client_creation() {
	// Create a client with default settings
	mut client := QDrantClient{
		name: 'test_client'
		url:  'http://localhost:6333'
	}

	assert client.name == 'test_client'
	assert client.url == 'http://localhost:6333'
	assert client.secret == ''
}

fn test_client_with_auth() {
	// Create a client with authentication
	mut client := QDrantClient{
		name:   'auth_client'
		url:    'http://localhost:6333'
		secret: 'test_api_key'
	}

	assert client.name == 'auth_client'
	assert client.url == 'http://localhost:6333'
	assert client.secret == 'test_api_key'
}

// The following tests require a running Qdrant server
// They are commented out to avoid test failures when no server is available

/*
fn test_collection_operations() {
	if os.getenv('QDRANT_TEST_URL') == '' {
		println('Skipping test_collection_operations: QDRANT_TEST_URL not set')
		return
	}

	mut client := QDrantClient{
		name: 'test_client'
		url: os.getenv('QDRANT_TEST_URL')
	}
	
	// Create a test collection
	create_result := client.create_collection(
		collection_name: 'test_collection'
		size: 128
		distance: 'cosine'
	) or {
		assert false, 'Failed to create collection: ${err}'
		return
	}
	
	assert create_result.status == 'ok'
	
	// Check if collection exists
	exists_result := client.is_collection_exists(
		collection_name: 'test_collection'
	) or {
		assert false, 'Failed to check collection existence: ${err}'
		return
	}
	
	assert exists_result.result.exists == true
	
	// Get collection info
	get_result := client.get_collection(
		collection_name: 'test_collection'
	) or {
		assert false, 'Failed to get collection: ${err}'
		return
	}
	
	assert get_result.result.config.params.vectors.size == 128
	assert get_result.result.config.params.vectors.distance == 'cosine'
	
	// Create an index
	create_index_result := client.create_index(
		collection_name: 'test_collection'
		field_name: 'category'
		field_schema: FieldSchema{
			field_type: 'keyword'
		}
		wait: true
	) or {
		assert false, 'Failed to create index: ${err}'
		return
	}
	
	assert create_index_result.status == 'ok'
	
	// Delete the index
	delete_index_result := client.delete_index(
		collection_name: 'test_collection'
		field_name: 'category'
		wait: true
	) or {
		assert false, 'Failed to delete index: ${err}'
		return
	}
	
	assert delete_index_result.status == 'ok'
	
	// List collections
	list_result := client.list_collections() or {
		assert false, 'Failed to list collections: ${err}'
		return
	}
	
	assert 'test_collection' in list_result.result.collections.map(it.collection_name)
	
	// Delete collection
	delete_result := client.delete_collection(
		collection_name: 'test_collection'
	) or {
		assert false, 'Failed to delete collection: ${err}'
		return
	}
	
	assert delete_result.status == 'ok'
}

fn test_points_operations() {
	if os.getenv('QDRANT_TEST_URL') == '' {
		println('Skipping test_points_operations: QDRANT_TEST_URL not set')
		return
	}

	mut client := QDrantClient{
		name: 'test_client'
		url: os.getenv('QDRANT_TEST_URL')
	}
	
	// Create a test collection
	client.create_collection(
		collection_name: 'test_points'
		size: 4
		distance: 'cosine'
	) or {
		assert false, 'Failed to create collection: ${err}'
		return
	}
	
	// Upsert points
	points := [
		Point{
			id: '1'
			vector: [f64(0.1), 0.2, 0.3, 0.4]
			payload: {
				'color': 'red'
				'category': 'furniture'
			}
		},
		Point{
			id: '2'
			vector: [f64(0.2), 0.3, 0.4, 0.5]
			payload: {
				'color': 'blue'
				'category': 'electronics'
			}
		}
	]
	
	upsert_result := client.upsert_points(
		collection_name: 'test_points'
		points: points
		wait: true
	) or {
		assert false, 'Failed to upsert points: ${err}'
		return
	}
	
	assert upsert_result.status == 'ok'
	
	// Get a point
	get_result := client.get_point(
		collection_name: 'test_points'
		id: '1'
		with_payload: true
		with_vector: true
	) or {
		assert false, 'Failed to get point: ${err}'
		return
	}
	
	assert get_result.result.id == '1'
	assert get_result.result.payload['color'] == 'red'
	
	// Search for points
	search_result := client.search(
		collection_name: 'test_points'
		vector: [f64(0.1), 0.2, 0.3, 0.4]
		limit: 10
	) or {
		assert false, 'Failed to search points: ${err}'
		return
	}
	
	assert search_result.result.points.len > 0
	
	// Scroll through points
	scroll_result := client.scroll_points(
		collection_name: 'test_points'
		limit: 10
		with_payload: true
		with_vector: true
	) or {
		assert false, 'Failed to scroll points: ${err}'
		return
	}
	
	assert scroll_result.result.points.len > 0
	
	// Count points
	count_result := client.count_points(
		collection_name: 'test_points'
	) or {
		assert false, 'Failed to count points: ${err}'
		return
	}
	
	assert count_result.result.count == 2
	
	// Set payload
	set_payload_result := client.set_payload(
		collection_name: 'test_points'
		payload: {
			'price': '100'
			'in_stock': 'true'
		}
		points: ['1']
	) or {
		assert false, 'Failed to set payload: ${err}'
		return
	}
	
	assert set_payload_result.status == 'ok'
	
	// Get point to verify payload was set
	get_result_after_set := client.get_point(
		collection_name: 'test_points'
		id: '1'
		with_payload: true
	) or {
		assert false, 'Failed to get point after setting payload: ${err}'
		return
	}
	
	assert get_result_after_set.result.payload['price'] == '100'
	assert get_result_after_set.result.payload['in_stock'] == 'true'
	
	// Delete specific payload key
	delete_payload_result := client.delete_payload(
		collection_name: 'test_points'
		keys: ['price']
		points: ['1']
	) or {
		assert false, 'Failed to delete payload: ${err}'
		return
	}
	
	assert delete_payload_result.status == 'ok'
	
	// Clear all payload
	clear_payload_result := client.clear_payload(
		collection_name: 'test_points'
		points: ['1']
	) or {
		assert false, 'Failed to clear payload: ${err}'
		return
	}
	
	assert clear_payload_result.status == 'ok'
	
	// Delete points
	delete_result := client.delete_points(
		collection_name: 'test_points'
		points_selector: PointsSelector{
			points: ['1', '2']
		}
		wait: true
	) or {
		assert false, 'Failed to delete points: ${err}'
		return
	}
	
	assert delete_result.status == 'ok'
	
	// Clean up
	client.delete_collection(
		collection_name: 'test_points'
	) or {
		assert false, 'Failed to delete collection: ${err}'
		return
	}
}

fn test_service_operations() {
	if os.getenv('QDRANT_TEST_URL') == '' {
		println('Skipping test_service_operations: QDRANT_TEST_URL not set')
		return
	}

	mut client := QDrantClient{
		name: 'test_client'
		url: os.getenv('QDRANT_TEST_URL')
	}
	
	// Get service info
	info_result := client.get_service_info() or {
		assert false, 'Failed to get service info: ${err}'
		return
	}
	
	assert info_result.result.version != ''
	
	// Check health
	health_result := client.health_check() or {
		assert false, 'Failed to check health: ${err}'
		return
	}
	
	assert health_result == true
}
*/
