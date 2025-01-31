#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.graphdb

fn main() {
	// Create a new graph database
	mut gdb := graphdb.new(path: '/tmp/graphdb_example', reset: true)!

	// Create some nodes
	println('\nCreating nodes...')
	mut alice_id := gdb.create_node({
		'name': 'Alice',
		'age': '30',
		'city': 'New York'
	})!
	println(gdb.debug_node(alice_id)!)

	mut bob_id := gdb.create_node({
		'name': 'Bob',
		'age': '25',
		'city': 'Boston'
	})!
	println(gdb.debug_node(bob_id)!)

	mut techcorp_id := gdb.create_node({
		'name': 'TechCorp',
		'industry': 'Technology',
		'location': 'New York'
	})!
	println(gdb.debug_node(techcorp_id)!)

	// Create relationships
	println('\nCreating relationships...')
	knows_edge_id := gdb.create_edge(alice_id, bob_id, 'KNOWS', {
		'since': '2020',
		'relationship': 'Colleague'
	})!
	println(gdb.debug_edge(knows_edge_id)!)

	works_at_id := gdb.create_edge(alice_id, techcorp_id, 'WORKS_AT', {
		'role': 'Software Engineer',
		'since': '2019'
	})!
	println(gdb.debug_edge(works_at_id)!)

	// Show current database state
	println('\nInitial database state:')
	gdb.debug_db()!

	// Print graph structure
	println('\nGraph structure:')
	gdb.print_graph()!

	// Query nodes by property
	println('\nQuerying nodes in New York:')
	ny_nodes := gdb.query_nodes_by_property('city', 'New York')!
	for node in ny_nodes {
		println('Found: ${node.properties['name']}')
	}

	// Get connected nodes
	println('\nPeople Alice knows:')
	alice_knows := gdb.get_connected_nodes(alice_id, 'KNOWS', 'out')!
	for node in alice_knows {
		println('${node.properties['name']} (${node.properties['city']})')
	}

	println('\nWhere Alice works:')
	alice_works := gdb.get_connected_nodes(alice_id, 'WORKS_AT', 'out')!
	for node in alice_works {
		println('${node.properties['name']} (${node.properties['industry']})')
	}

	// Update node properties
	println('\nUpdating Alice\'s age...')
	gdb.update_node(alice_id, {
		'name': 'Alice',
		'age': '31',
		'city': 'New York'
	})!
	println(gdb.debug_node(alice_id)!)

	// Update edge properties
	println('\nUpdating work relationship...')
	gdb.update_edge(works_at_id, {
		'role': 'Senior Software Engineer',
		'since': '2019'
	})!
	println(gdb.debug_edge(works_at_id)!)

	// Show final state
	println('\nFinal database state:')
	gdb.debug_db()!
}
