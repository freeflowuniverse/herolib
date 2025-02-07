module graphdb

fn test_search() ! {
	mut gdb := new(NewArgs{
		path:  'test_search.db'
		reset: true
	})!

	// Create test nodes of different types
	mut user1 := Node{
		properties: {
			'name': 'User 1'
		}
		node_type:  'user'
	}
	user1_id := gdb.db.set(data: serialize_node(user1))!
	user1.id = user1_id
	gdb.node_cache.set(user1_id, &user1)

	mut user2 := Node{
		properties: {
			'name': 'User 2'
		}
		node_type:  'user'
	}
	user2_id := gdb.db.set(data: serialize_node(user2))!
	user2.id = user2_id
	gdb.node_cache.set(user2_id, &user2)

	mut post1 := Node{
		properties: {
			'title': 'Post 1'
		}
		node_type:  'post'
	}
	post1_id := gdb.db.set(data: serialize_node(post1))!
	post1.id = post1_id
	gdb.node_cache.set(post1_id, &post1)

	mut post2 := Node{
		properties: {
			'title': 'Post 2'
		}
		node_type:  'post'
	}
	post2_id := gdb.db.set(data: serialize_node(post2))!
	post2.id = post2_id
	gdb.node_cache.set(post2_id, &post2)

	// Create edges with different weights
	mut edge1 := Edge{
		from_node: user1_id
		to_node:   post1_id
		edge_type: 'created'
		weight:    1
	}
	edge1_id := gdb.db.set(data: serialize_edge(edge1))!
	edge1.id = edge1_id
	gdb.edge_cache.set(edge1_id, &edge1)

	mut edge2 := Edge{
		from_node: post1_id
		to_node:   post2_id
		edge_type: 'related'
		weight:    2
	}
	edge2_id := gdb.db.set(data: serialize_edge(edge2))!
	edge2.id = edge2_id
	gdb.edge_cache.set(edge2_id, &edge2)

	mut edge3 := Edge{
		from_node: user2_id
		to_node:   post2_id
		edge_type: 'created'
		weight:    1
	}
	edge3_id := gdb.db.set(data: serialize_edge(edge3))!
	edge3.id = edge3_id
	gdb.edge_cache.set(edge3_id, &edge3)

	// Update node edge references
	user1.edges_out << EdgeRef{
		edge_id:   edge1_id
		edge_type: 'created'
	}
	gdb.db.set(id: user1_id, data: serialize_node(user1))!
	gdb.node_cache.set(user1_id, &user1)

	post1.edges_in << EdgeRef{
		edge_id:   edge1_id
		edge_type: 'created'
	}
	post1.edges_out << EdgeRef{
		edge_id:   edge2_id
		edge_type: 'related'
	}
	gdb.db.set(id: post1_id, data: serialize_node(post1))!
	gdb.node_cache.set(post1_id, &post1)

	post2.edges_in << EdgeRef{
		edge_id:   edge2_id
		edge_type: 'related'
	}
	post2.edges_in << EdgeRef{
		edge_id:   edge3_id
		edge_type: 'created'
	}
	gdb.db.set(id: post2_id, data: serialize_node(post2))!
	gdb.node_cache.set(post2_id, &post2)

	user2.edges_out << EdgeRef{
		edge_id:   edge3_id
		edge_type: 'created'
	}
	gdb.db.set(id: user2_id, data: serialize_node(user2))!
	gdb.node_cache.set(user2_id, &user2)

	// Test 1: Search for posts within distance 2
	results1 := gdb.search(user1_id, SearchConfig{
		types:        ['post']
		max_distance: 2
	})!

	assert results1.len == 1 // Should only find post1 within distance 2
	assert results1[0].node.properties['title'] == 'Post 1'
	assert results1[0].distance == 1

	// Test 2: Search for posts within distance 4
	results2 := gdb.search(user1_id, SearchConfig{
		types:        ['post']
		max_distance: 4
	})!

	assert results2.len == 2 // Should find both posts
	assert results2[0].node.properties['title'] == 'Post 1'
	assert results2[1].node.properties['title'] == 'Post 2'
	assert results2[1].distance == 3

	// Test 3: Search for users within distance 3
	results3 := gdb.search(post2_id, SearchConfig{
		types:        ['user']
		max_distance: 3
	})!

	assert results3.len == 2 // Should find both users
	assert results3[0].node.properties['name'] in ['User 1', 'User 2']
	assert results3[1].node.properties['name'] in ['User 1', 'User 2']

	// Test 4: Search without type filter
	results4 := gdb.search(user1_id, SearchConfig{
		types:        []
		max_distance: 4
	})!

	assert results4.len == 4 // Should find all nodes
}
