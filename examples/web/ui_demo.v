module main

import freeflowuniverse.herolib.web.ui

fn main() {
	println('Starting UI demo server on port 8080...')
	println('Visit http://localhost:8080 to see the admin interface')
	
	ui.start(
		title: 'Demo Admin Panel'
		port: 8080
	)!
}