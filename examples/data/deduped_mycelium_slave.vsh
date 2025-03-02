#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium
import freeflowuniverse.herolib.installers.net.mycelium_installer
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.osal
import time
import os
import encoding.base64
import json

// TODO: Make the worker read the data from the streamer instead.

const slave_port = 9000
const master_public_key = '89c2eeb24bcdfaaac78c0023a166d88f760c097c1a57748770e432ba10757179'
const master_address = '458:90d4:a3ef:b285:6d32:a22d:9e73:697f'

mycelium.delete()!

// Initialize mycelium clients
mut slave := mycelium.get()!
slave.server_url = 'http://localhost:${slave_port}'
slave.name = 'slave_node'

// Get public keys for communication
slave_inspect := mycelium.inspect(key_file_path: '/tmp/mycelium_server1/priv_key.bin')!

println('Server 2 (slave Node) public key: ${slave_inspect.public_key}')

// Initialize ourdb instances
mut worker := ourdb.new(
	record_nr_max:   16777216 - 1
	record_size_max: 1024
	path:            '/tmp/ourdb1'
	reset:           true
)!

defer {
	worker.destroy() or { panic('failed to destroy db1: ${err}') }
}

// Receive messages
// Parameters: wait_for_message, peek_only, topic_filter
received := slave.receive_msg(wait: true, peek: false, topic: 'sync_db')!
println('Received message from: ${received.src_pk}')
println('Message payload: ${base64.decode_str(received.payload)}')

payload := base64.decode(received.payload)
println('Payload: ${payload.str()}')
worker.sync_updates(received.payload.bytes()) or {
	error('Failed to sync updates to worker due to: ${err}')
}

// Get last index
last_index := worker.get_last_index()!
println('Last index: ${last_index}')
