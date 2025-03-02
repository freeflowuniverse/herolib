#!/usr/bin/env -S v -n -w -gc none  -cc tcc -d use_openssl -enable-globals run

import freeflowuniverse.herolib.clients.mycelium
import freeflowuniverse.herolib.installers.net.mycelium_installer
import freeflowuniverse.herolib.data.ourdb
import freeflowuniverse.herolib.osal
import time
import os
import encoding.base64
import json

// NOTE: Before running this script, ensure that the mycelium binary is installed and in the PATH

const master_port = 9000
const slave_public_key = '46a9f9cee1ce98ef7478f3dea759589bbf6da9156533e63fed9f233640ac072c'
const slave_address = '59c:28ee:8597:6c20:3b2f:a9ee:2e18:9d4f'

// Struct to hold data for syncing
struct SyncData {
	id    u32
	data  string
	topic string = 'db_sync'
}

mycelium.delete()!

// Initialize mycelium clients
mut master := mycelium.get()!
master.server_url = 'http://localhost:${master_port}'
master.name = 'master_node'

// Get public keys for communication
// master_inspect := mycelium.inspect(key_file_path: '/tmp/mycelium_server1/priv_key.bin')!
// println('Server 1 (Master Node) public key: ${master_inspect.public_key}')

// Initialize ourdb instances
mut db := ourdb.new(
	record_nr_max:   16777216 - 1
	record_size_max: 1024
	path:            '/tmp/ourdb1'
	reset:           true
)!

defer {
	db.destroy() or { panic('failed to destroy db1: ${err}') }
}

// Store in master db
println('\nStoring data in master node DB...')
data := 'Test data for sync - ' + time.now().str()
id := db.set(data: data.bytes())!
println('Successfully stored data in master node DB with ID: ${id}')

// Create sync data
sync_data := SyncData{
	id:   id
	data: data
}

// Convert to JSON
json_data := json.encode(sync_data)

// Send sync message to slave
println('\nSending sync message to slave...')
msg := master.send_msg(
	public_key: slave_public_key
	payload:    json_data
	topic:      'db_sync'
)!

println('Sync message sent with ID: ${msg.id} to slave with public key: ${slave_public_key}')

// Receive messages
// Parameters: wait_for_message, peek_only, topic_filter
received := master.receive_msg(wait: true, peek: false, topic: 'db_sync')!
println('Received message from: ${received.src_pk}')
println('Message payload: ${base64.decode_str(received.payload)}')

master.reply_msg(
	id:         received.id
	public_key: received.src_pk
	payload:    'Got your message!'
	topic:      'db_sync'
)!

println('Message sent to slave with ID: ${msg.id}')
