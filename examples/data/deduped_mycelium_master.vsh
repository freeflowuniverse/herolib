#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.data.ourdb
import time

// Known worker public key
worker_public_key := '46a9f9cee1ce98ef7478f3dea759589bbf6da9156533e63fed9f233640ac072c'

// Create master node
mut streamer := ourdb.new_streamer(
	incremental_mode: false
	server_port:      9000 // Master uses default port
	is_worker:        false
	id:               'frBvtZQeqf'
)!

println('Starting master node...')

// Add worker to whitelist and initialize its database
streamer.add_worker(worker_public_key)!

// Write some test data
// id := streamer.write(id: 1, value: 'Record 1')!
// println('Wrote record with ID: ${id}')

// // Verify data in master
// master_data := streamer.read(id: id)!
// master_data_str := master_data.bytestr()
// println('Master data: ${master_data_str}')

// Keep master running to handle worker connections
mut id_ := u32(1)

for {
	time.sleep(1 * time.second)
	// Write some test data
	mut id := streamer.write(id: id_, value: 'Record ${id_}')!
	println('Wrote record with ID: ${id}')
	// Verify data in master
	master_data := streamer.read(id: id)!
	master_data_str := master_data.bytestr()
	println('Master data: ${master_data_str}')
	id_++
}
