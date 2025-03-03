#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.ourdb

worker_public_key := '46a9f9cee1ce98ef7478f3dea759589bbf6da9156533e63fed9f233640ac072c'

// Create a worker node with a unique database path
mut streamer := ourdb.get_streamer(id: 'frBvtZQeqf') or {
	ourdb.new_streamer(
		incremental_mode: false
		server_port:      9000 // Use different port than master
		is_worker:        true
	)!
}

// Add worker to the tree
streamer.add_worker(worker_public_key)!
// This will keep running and listening for updates
streamer.listen()!

println('Listening for updates...')
// Now we can read from the database
data := streamer.read(
	id:                1
	worker_public_key: worker_public_key
)!

println('Worker data: ${data.bytestr()}')
