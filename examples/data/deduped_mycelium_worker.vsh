#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.ourdb

// Create a worker node with a unique database path
mut streamer := ourdb.get_streamer(id: 'frBvtZQeqf') or {
	ourdb.new_streamer(
		incremental_mode: false
		server_port:      9001 // Use different port than master
		is_worker:        true
	)!
}

println('Starting worker node...')
println('Listening for updates from master...')
streamer.listen()! // This will keep running and listening for updates
