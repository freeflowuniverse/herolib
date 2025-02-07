module graphdb

fn test_basic_operations() ! {
	mut gdb := new(path: '/tmp/graphdb_test', reset: true)!

	// Test creating nodes with properties
	mut person1_id := gdb.create_node({
		'name': 'Alice'
		'age':  '30'
	})!

	mut person2_id := gdb.create_node({
		'name': 'Bob'
		'age':  '25'
	})!

	// Test retrieving nodes
	person1 := gdb.get_node(person1_id)!
	assert person1.properties['name'] == 'Alice'
	assert person1.properties['age'] == '30'

	person2 := gdb.get_node(person2_id)!
	assert person2.properties['name'] == 'Bob'
	assert person2.properties['age'] == '25'

	// Test creating edge between nodes
	edge_id := gdb.create_edge(person1_id, person2_id, 'KNOWS', {
		'since': '2020'
	})!

	// Test retrieving edge
	edge := gdb.get_edge(edge_id)!
	assert edge.edge_type == 'KNOWS'
	assert edge.properties['since'] == '2020'
	assert edge.from_node == person1_id
	assert edge.to_node == person2_id

	// Test querying nodes by property
	alice_nodes := gdb.query_nodes_by_property('name', 'Alice')!
	assert alice_nodes.len == 1
	assert alice_nodes[0].properties['age'] == '30'

	// Test getting connected nodes
	bob_knows := gdb.get_connected_nodes(person1_id, 'KNOWS', 'out')!
	assert bob_knows.len == 1
	assert bob_knows[0].properties['name'] == 'Bob'

	alice_known_by := gdb.get_connected_nodes(person2_id, 'KNOWS', 'in')!
	assert alice_known_by.len == 1
	assert alice_known_by[0].properties['name'] == 'Alice'

	// Test updating node properties
	gdb.update_node(person1_id, {
		'name': 'Alice'
		'age':  '31'
	})!
	updated_alice := gdb.get_node(person1_id)!
	assert updated_alice.properties['age'] == '31'

	// Test updating edge properties
	gdb.update_edge(edge_id, {
		'since': '2021'
	})!
	updated_edge := gdb.get_edge(edge_id)!
	assert updated_edge.properties['since'] == '2021'

	// Test getting edges between nodes
	edges := gdb.get_edges_between(person1_id, person2_id)!
	assert edges.len == 1
	assert edges[0].edge_type == 'KNOWS'

	// Test deleting edge
	gdb.delete_edge(edge_id)!
	remaining_edges := gdb.get_edges_between(person1_id, person2_id)!
	assert remaining_edges.len == 0

	// Test deleting node
	gdb.delete_node(person1_id)!
	if _ := gdb.get_node(person1_id) {
		assert false, 'Expected error for deleted node'
	}
}

fn test_complex_graph() ! {
	mut gdb := new(path: '/tmp/graphdb_test_complex', reset: true)!

	// Create nodes representing people
	mut alice_id := gdb.create_node({
		'name': 'Alice'
		'age':  '30'
		'city': 'New York'
	})!

	mut bob_id := gdb.create_node({
		'name': 'Bob'
		'age':  '25'
		'city': 'Boston'
	})!

	mut charlie_id := gdb.create_node({
		'name': 'Charlie'
		'age':  '35'
		'city': 'New York'
	})!

	// Create nodes representing companies
	mut company1_id := gdb.create_node({
		'name':     'TechCorp'
		'industry': 'Technology'
	})!

	mut company2_id := gdb.create_node({
		'name':     'FinCo'
		'industry': 'Finance'
	})!

	// Create relationships
	gdb.create_edge(alice_id, bob_id, 'KNOWS', {
		'since': '2020'
	})!
	gdb.create_edge(bob_id, charlie_id, 'KNOWS', {
		'since': '2019'
	})!
	gdb.create_edge(charlie_id, alice_id, 'KNOWS', {
		'since': '2018'
	})!

	gdb.create_edge(alice_id, company1_id, 'WORKS_AT', {
		'role': 'Engineer'
	})!
	gdb.create_edge(bob_id, company2_id, 'WORKS_AT', {
		'role': 'Analyst'
	})!
	gdb.create_edge(charlie_id, company1_id, 'WORKS_AT', {
		'role': 'Manager'
	})!

	// Test querying by property
	ny_people := gdb.query_nodes_by_property('city', 'New York')!
	assert ny_people.len == 2

	// Test getting connected nodes with different edge types
	alice_knows := gdb.get_connected_nodes(alice_id, 'KNOWS', 'out')!
	assert alice_knows.len == 1
	assert alice_knows[0].properties['name'] == 'Bob'

	alice_works_at := gdb.get_connected_nodes(alice_id, 'WORKS_AT', 'out')!
	assert alice_works_at.len == 1
	assert alice_works_at[0].properties['name'] == 'TechCorp'

	// Test getting nodes connected in both directions
	charlie_connections := gdb.get_connected_nodes(charlie_id, 'KNOWS', 'both')!
	assert charlie_connections.len == 2

	// Test company employees
	techcorp_employees := gdb.get_connected_nodes(company1_id, 'WORKS_AT', 'in')!
	assert techcorp_employees.len == 2

	finco_employees := gdb.get_connected_nodes(company2_id, 'WORKS_AT', 'in')!
	assert finco_employees.len == 1
	assert finco_employees[0].properties['name'] == 'Bob'
}

fn test_edge_cases() ! {
	mut gdb := new(path: '/tmp/graphdb_test_edge', reset: true)!

	// Test empty properties
	node_id := gdb.create_node(map[string]string{})!
	node := gdb.get_node(node_id)!
	assert node.properties.len == 0

	// Test node with many properties
	mut large_props := map[string]string{}
	for i in 0 .. 100 {
		large_props['key${i}'] = 'value${i}'
	}
	large_node_id := gdb.create_node(large_props)!
	large_node := gdb.get_node(large_node_id)!
	assert large_node.properties.len == 100

	// Test edge with empty properties
	other_node_id := gdb.create_node({})!
	edge_id := gdb.create_edge(node_id, other_node_id, 'TEST', map[string]string{})!
	edge := gdb.get_edge(edge_id)!
	assert edge.properties.len == 0

	// Test querying non-existent property
	empty_results := gdb.query_nodes_by_property('nonexistent', 'value')!
	assert empty_results.len == 0

	// Test getting edges between unconnected nodes
	no_edges := gdb.get_edges_between(node_id, large_node_id)!
	assert no_edges.len == 0

	// Test getting connected nodes with non-existent edge type
	no_connections := gdb.get_connected_nodes(node_id, 'NONEXISTENT', 'both')!
	assert no_connections.len == 0

	// Test deleting non-existent edge
	if _ := gdb.delete_edge(u32(99999)) {
		assert false, 'Expected error for non-existent edge'
	}

	// Test deleting non-existent node
	if _ := gdb.delete_node(u32(99999)) {
		assert false, 'Expected error for non-existent node'
	}
}
